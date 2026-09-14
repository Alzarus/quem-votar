import 'package:equatable/equatable.dart';
import 'package:quem_votar/core/errors/failures.dart';

/// Tipo monadico selado para isolamento estrito de falhas de operacao.
/// Garante que erros de infraestrutura nao cruzem as fronteiras da camada
/// de Dados para a camada de Dominio sem tipagem explicita.
sealed class Result<S, F extends Failure> extends Equatable {
  const Result();

  /// Cria uma instancia representativa de Sucesso com sua respectiva carga.
  const factory Result.success(S value) = Success<S, F>;

  /// Cria uma instancia representativa de Falha com o objeto correspondente.
  const factory Result.failure(F failure) = FailureResult<S, F>;

  /// Indica se a operacao foi concluida com sucesso.
  bool get isSuccess => this is Success<S, F>;

  /// Indica se a operacao culminou em falha.
  bool get isFailure => this is FailureResult<S, F>;

  /// Obtem o valor retornado em caso de sucesso, ou nulo caso contrario.
  S? get successOrNull {
    final current = this;
    if (current is Success<S, F>) {
      return current.value;
    }
    return null;
  }

  /// Obtem o objeto de falha retornado, ou nulo caso contrario.
  F? get failureOrNull {
    final current = this;
    if (current is FailureResult<S, F>) {
      return current.failure;
    }
    return null;
  }

  /// Desempacota o resultado aplicando a funcao adequada a cada estado.
  R fold<R>(R Function(F failure) onFailure, R Function(S success) onSuccess) {
    final current = this;
    if (current is Success<S, F>) {
      return onSuccess(current.value);
    }
    return onFailure((current as FailureResult<S, F>).failure);
  }

  /// Executa o callback nomeado correspondente ao estado do resultado.
  R when<R>({required R Function(S value) success, required R Function(F failure) failure}) {
    final current = this;
    if (current is Success<S, F>) {
      return success(current.value);
    }
    return failure((current as FailureResult<S, F>).failure);
  }
}

/// Representa o estado de sucesso de uma computacao ou requisicao.
final class Success<S, F extends Failure> extends Result<S, F> {
  final S value;

  const Success(this.value);

  @override
  List<Object?> get props => [value];
}

/// Representa o estado de falha encapsulado de uma computacao ou requisicao.
final class FailureResult<S, F extends Failure> extends Result<S, F> {
  final F failure;

  const FailureResult(this.failure);

  @override
  List<Object?> get props => [failure];
}
