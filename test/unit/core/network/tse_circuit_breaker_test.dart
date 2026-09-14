import 'package:flutter_test/flutter_test.dart';
import 'package:quem_votar/core/network/circuit_breaker_state.dart';
import 'package:quem_votar/core/network/tse_circuit_breaker.dart';

void main() {
  group('TseCircuitBreaker', () {
    late DateTime simulatedTime;
    late TseCircuitBreaker circuitBreaker;

    setUp(() {
      simulatedTime = DateTime(2026, 9, 13, 12, 0, 0);
      circuitBreaker = TseCircuitBreaker(
        failureThreshold: 3,
        failureWindow: const Duration(minutes: 2),
        cooldownDuration: const Duration(minutes: 5),
        clock: () => simulatedTime,
      );
    });

    test('deve iniciar no estado closed permitindo execucao com contadores zerados', () {
      expect(circuitBreaker.state, equals(CircuitBreakerState.closed));
      expect(circuitBreaker.canExecute(), isTrue);
      expect(circuitBreaker.failureCount, equals(0));
      expect(circuitBreaker.getRemainingCooldown(), equals(Duration.zero));
    });

    test('deve manter estado closed e acumular falhas abaixo do limiar', () {
      circuitBreaker.recordFailure();
      expect(circuitBreaker.state, equals(CircuitBreakerState.closed));
      expect(circuitBreaker.canExecute(), isTrue);
      expect(circuitBreaker.failureCount, equals(1));

      circuitBreaker.recordFailure();
      expect(circuitBreaker.state, equals(CircuitBreakerState.closed));
      expect(circuitBreaker.failureCount, equals(2));
    });

    test('deve abrir o circuito ao atingir exatamente o limiar de 3 falhas na janela', () {
      circuitBreaker.recordFailure();
      circuitBreaker.recordFailure();
      circuitBreaker.recordFailure();

      expect(circuitBreaker.state, equals(CircuitBreakerState.open));
      expect(circuitBreaker.canExecute(), isFalse);
      expect(circuitBreaker.getRemainingCooldown(), equals(const Duration(minutes: 5)));
    });

    test('deve descartar falhas antigas fora da janela deslizante de 2 minutos', () {
      circuitBreaker.recordFailure();
      simulatedTime = simulatedTime.add(const Duration(minutes: 1));
      circuitBreaker.recordFailure();

      // Avanca tempo para 2 minutos e 1 segundo apos a primeira falha
      simulatedTime = simulatedTime.add(const Duration(minutes: 1, seconds: 1));
      circuitBreaker.recordFailure();

      // A primeira falha expirou, restando apenas 2 falhas na janela
      expect(circuitBreaker.failureCount, equals(2));
      expect(circuitBreaker.state, equals(CircuitBreakerState.closed));
      expect(circuitBreaker.canExecute(), isTrue);
    });

    test('deve calcular decrescimo correto de remainingCooldown no estado open', () {
      circuitBreaker.recordFailure();
      circuitBreaker.recordFailure();
      circuitBreaker.recordFailure();

      simulatedTime = simulatedTime.add(const Duration(minutes: 2));
      expect(circuitBreaker.state, equals(CircuitBreakerState.open));
      expect(circuitBreaker.getRemainingCooldown(), equals(const Duration(minutes: 3)));
    });

    test('deve transitar automaticamente para halfOpen apos expirar cooldown de 5 minutos', () {
      circuitBreaker.recordFailure();
      circuitBreaker.recordFailure();
      circuitBreaker.recordFailure();

      simulatedTime = simulatedTime.add(const Duration(minutes: 5));
      expect(circuitBreaker.state, equals(CircuitBreakerState.halfOpen));
      expect(circuitBreaker.canExecute(), isTrue);
      expect(circuitBreaker.getRemainingCooldown(), equals(Duration.zero));
    });

    test('deve retornar para open imediatamente se ocorrer falha no estado halfOpen', () {
      circuitBreaker.recordFailure();
      circuitBreaker.recordFailure();
      circuitBreaker.recordFailure();

      simulatedTime = simulatedTime.add(const Duration(minutes: 5));
      expect(circuitBreaker.state, equals(CircuitBreakerState.halfOpen));

      circuitBreaker.recordFailure();
      expect(circuitBreaker.state, equals(CircuitBreakerState.open));
      expect(circuitBreaker.canExecute(), isFalse);
      expect(circuitBreaker.getRemainingCooldown(), equals(const Duration(minutes: 5)));
    });

    test('deve restaurar estado closed e limpar falhas quando tiver sucesso em halfOpen', () {
      circuitBreaker.recordFailure();
      circuitBreaker.recordFailure();
      circuitBreaker.recordFailure();

      simulatedTime = simulatedTime.add(const Duration(minutes: 5));
      expect(circuitBreaker.state, equals(CircuitBreakerState.halfOpen));

      circuitBreaker.recordSuccess();
      expect(circuitBreaker.state, equals(CircuitBreakerState.closed));
      expect(circuitBreaker.canExecute(), isTrue);
      expect(circuitBreaker.failureCount, equals(0));
    });

    test('deve resetar o disjuntor para closed com falhas zeradas ao chamar reset()', () {
      circuitBreaker.recordFailure();
      circuitBreaker.recordFailure();
      circuitBreaker.recordFailure();
      expect(circuitBreaker.state, equals(CircuitBreakerState.open));

      circuitBreaker.reset();
      expect(circuitBreaker.state, equals(CircuitBreakerState.closed));
      expect(circuitBreaker.canExecute(), isTrue);
      expect(circuitBreaker.failureCount, equals(0));
    });
  });
}
