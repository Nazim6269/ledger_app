class SplitResult {
  final Map<String, double> amountByUserId;
  final String? error;

  SplitResult.success(this.amountByUserId) : error = null;
  SplitResult.failure(this.error) : amountByUserId = const {};

  bool get isValid => error == null;
}
