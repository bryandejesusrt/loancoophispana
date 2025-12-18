import 'dart:math';
import '../models/loan_tier.dart';

class LoanCalculator {
  static const List<LoanTier> tiers = [
    LoanTier(
      minAmount: 499,
      maxAmount: 100000,
      maxInstallments: 24,
      annualRate: 18,
      insuranceLoan: 500,
      insuranceLife: 200,
    ),
    LoanTier(
      minAmount: 100000,
      maxAmount: 500000,
      maxInstallments: 48,
      annualRate: 12,
      insuranceLoan: 645,
      insuranceLife: 800,
    ),
    LoanTier(
      minAmount: 500000,
      maxAmount: 1000000,
      maxInstallments: 72,
      annualRate: 10,
      insuranceLoan: 1000,
      insuranceLife: 1000,
    ),
    LoanTier(
      minAmount: 1000000,
      maxAmount: 1500000,
      maxInstallments: 96,
      annualRate: 9,
      insuranceLoan: 300,
      insuranceLife: 600,
    ),
    LoanTier(
      minAmount: 1500000,
      maxAmount: 3000000,
      maxInstallments: 120,
      annualRate: 6,
      insuranceLoan: 1200,
      insuranceLife: 1200,
    ),
  ];

  static LoanTier? tierFor(double amount) {
    if (amount <= 0) return null;
    try {
      return tiers.firstWhere((tier) => tier.matches(amount));
    } catch (_) {
      return null;
    }
  }

  static double? monthlyPayment({
    required double amount,
    required int installments,
  }) {
    final tier = tierFor(amount);
    if (tier == null || installments <= 0) return null;

    final monthlyRate = tier.annualRate / 12 / 100;
    
    final double principal;
    if (monthlyRate == 0) {
      principal = amount / installments;
    } else {
      final factor = pow(1 + monthlyRate, installments);
      principal = amount * (monthlyRate * factor) / (factor - 1);
    }

    final insurance = (tier.insuranceLoan + tier.insuranceLife) / 12;
    return principal + insurance;
  }

  static String? validateAmount(double amount) {
    if (amount > 3000000) {
      return 'Monto máximo permitido: RD 3,000,000.00';
    }
    return null;
  }
}