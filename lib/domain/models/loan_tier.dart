class LoanTier {
  const LoanTier({
    required this.minAmount,
    required this.maxAmount,
    required this.maxInstallments,
    required this.annualRate,
    required this.insuranceLoan,
    required this.insuranceLife,
  });

  final double minAmount;
  final double maxAmount;
  final int maxInstallments;
  final double annualRate; // percentage
  final double insuranceLoan;
  final double insuranceLife;

  bool matches(double amount) => amount > minAmount && amount <= maxAmount;
}
