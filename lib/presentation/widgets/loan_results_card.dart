import 'package:flutter/material.dart';
import '../../domain/models/loan_tier.dart';
import 'result_row.dart';

class LoanResultsCard extends StatelessWidget {
  const LoanResultsCard({
    super.key,
    required this.tier,
    required this.monthlyPayment,
  });

  final LoanTier? tier;
  final double? monthlyPayment;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Resultados',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ResultRow(
              label: 'Tasa de Interés Anual',
              value: tier != null ? '${tier!.annualRate.toStringAsFixed(2)}%' : '--',
            ),
            ResultRow(
              label: 'Seguro Préstamo',
              value: tier != null ? 'RD ${tier!.insuranceLoan.toStringAsFixed(2)}' : '--',
            ),
            ResultRow(
              label: 'Seguro de Vida',
              value: tier != null ? 'RD ${tier!.insuranceLife.toStringAsFixed(2)}' : '--',
            ),
            const Divider(height: 24),
            ResultRow(
              label: 'Monto de Cuota Mensual',
              value: monthlyPayment != null ? 'RD ${monthlyPayment!.toStringAsFixed(2)}' : '--',
              highlight: true,
            ),
          ],
        ),
      ),
    );
  }
}
