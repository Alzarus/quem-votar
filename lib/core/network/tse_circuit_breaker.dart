import 'circuit_breaker_state.dart';

/// Disjuntor em memoria para proteger o aplicativo contra indisponibilidade do TSE.
/// Implementa a maquina de estados descrita na secao 2.3 de docs/arquitetura.md.
class TseCircuitBreaker {
  final int failureThreshold;
  final Duration failureWindow;
  final Duration cooldownDuration;
  final DateTime Function() clock;

  CircuitBreakerState _state = CircuitBreakerState.closed;
  DateTime? _lastStateChange;
  final List<DateTime> _failureTimestamps = <DateTime>[];

  TseCircuitBreaker({
    this.failureThreshold = 3,
    this.failureWindow = const Duration(minutes: 2),
    this.cooldownDuration = const Duration(minutes: 5),
    DateTime Function()? clock,
  }) : clock = clock ?? DateTime.now;

  /// Retorna o estado atual do disjuntor apos avaliar o tempo de resguardo.
  CircuitBreakerState get state => _evaluateCurrentState();

  /// Retorna a quantidade de falhas ativas na janela deslizante atual.
  int get failureCount {
    _pruneExpiredFailures(clock());
    return _failureTimestamps.length;
  }

  /// Indica se uma requisicao de rede pode ser despachada.
  bool canExecute() {
    final currentState = _evaluateCurrentState();
    return currentState != CircuitBreakerState.open;
  }

  /// Calcula o tempo restante de resguardo caso o circuito esteja aberto.
  Duration getRemainingCooldown() {
    if (_state != CircuitBreakerState.open) {
      return Duration.zero;
    }
    final elapsed = clock().difference(_lastStateChange ?? clock());
    final remaining = cooldownDuration - elapsed;
    return remaining.isNegative ? Duration.zero : remaining;
  }

  /// Registra uma resposta bem-sucedida da rede.
  void recordSuccess() {
    _failureTimestamps.clear();
    if (_state == CircuitBreakerState.halfOpen) {
      _transitionTo(CircuitBreakerState.closed);
    }
  }

  /// Registra uma falha de conexao, timeout ou erro de servidor (HTTP 5xx).
  void recordFailure() {
    final now = clock();
    _pruneExpiredFailures(now);
    _failureTimestamps.add(now);

    if (_state == CircuitBreakerState.halfOpen) {
      _transitionTo(CircuitBreakerState.open);
      return;
    }

    if (_failureTimestamps.length >= failureThreshold) {
      _transitionTo(CircuitBreakerState.open);
    }
  }

  /// Restaura o estado inicial fechado com historico de falhas zerado.
  void reset() {
    _failureTimestamps.clear();
    _transitionTo(CircuitBreakerState.closed);
  }

  CircuitBreakerState _evaluateCurrentState() {
    if (_state == CircuitBreakerState.open) {
      final elapsed = clock().difference(_lastStateChange ?? clock());
      if (elapsed >= cooldownDuration) {
        _transitionTo(CircuitBreakerState.halfOpen);
      }
    }
    return _state;
  }

  void _pruneExpiredFailures(DateTime referenceTime) {
    final cutoff = referenceTime.subtract(failureWindow);
    _failureTimestamps.removeWhere((timestamp) => timestamp.isBefore(cutoff));
  }

  void _transitionTo(CircuitBreakerState newState) {
    _state = newState;
    _lastStateChange = clock();
  }
}
