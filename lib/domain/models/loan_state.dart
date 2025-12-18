class LoanState {
  final double amount;
  final int installments;

  const LoanState({
    required this.amount,
    required this.installments,
  });

  LoanState copyWith({
    double? amount,
    int? installments,
  }) {
    return LoanState(
      amount: amount ?? this.amount,
      installments: installments ?? this.installments,
    );
  }
}
