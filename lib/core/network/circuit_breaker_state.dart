/// Estados operacionais do disjuntor de conexao em memoria (Circuit Breaker).
/// Empregado para resiliencia do cliente HTTP contra indisponibilidade do TSE.
enum CircuitBreakerState {
  /// Estado Fechado: Operacao normal, requisicoes trafegam livremente.
  closed,

  /// Estado Aberto: Falhas consecutivas excederam o limiar. Requisicoes bloqueadas.
  open,

  /// Estado Semi-Aberto: Periodo de resguardo expirou; permite requisicao canary de teste.
  halfOpen,
}
