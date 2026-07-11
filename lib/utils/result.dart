sealed class Result<F, S> {
  const Result();

  R when<R>({
    required R Function(F failure) failure,
    required R Function(S success) success,
  }) {
    final self = this;
    if (self is Failed<F, S>) return failure(self.failure);
    if (self is Succeeded<F, S>) return success(self.data);
    throw StateError('Unhandled Result subtype');
  }

  bool get isSuccess => this is Succeeded<F, S>;
  bool get isFailure => this is Failed<F, S>;
}

class Succeeded<F, S> extends Result<F, S> {
  const Succeeded(this.data);
  final S data;
}

class Failed<F, S> extends Result<F, S> {
  const Failed(this.failure);
  final F failure;
}
