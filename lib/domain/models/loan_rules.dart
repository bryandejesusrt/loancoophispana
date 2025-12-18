class LoanRule {
  final double minAmount;
  final double maxAmount;
  final int maxInstallments;
  final double annualRate;
  final double insuranceLoan;
  final double insuranceLife;

  const LoanRule({
    required this.minAmount,
    required this.maxAmount,
    required this.maxInstallments,
    required this.annualRate,
    required this.insuranceLoan,
    required this.insuranceLife,
  });

  bool matches(double amount) {
    return amount > minAmount && amount <= maxAmount;
  }
}
