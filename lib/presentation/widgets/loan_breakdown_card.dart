import 'package:flutter/material.dart';
import 'dart:math';
import '../../domain/models/loan_tier.dart';

class LoanBreakdownCard extends StatelessWidget {
  const LoanBreakdownCard({
    super.key,
    required this.tier,
    required this.amount,
    required this.installments,
    required this.monthlyPayment,
  });

  final LoanTier tier;
  final double amount;
  final int installments;
  final double monthlyPayment;

  @override
  Widget build(BuildContext context) {
    final monthlyRate = tier.annualRate / 12 / 100;
    final factor = pow(1 + monthlyRate, installments);
    final monthlyPrincipal = amount * (monthlyRate * factor) / (factor - 1);
    final monthlyInsurance = (tier.insuranceLoan + tier.insuranceLife) / 12;
    final totalInterest = (monthlyPrincipal * installments) - amount;
    final totalInsurance = monthlyInsurance * installments;
    final totalPayment = monthlyPayment * installments;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Desglose Detallado',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF7ED321),
              ),
            ),
            const SizedBox(height: 14),

            _DetailRow(
              label: 'Monto del Préstamo',
              value: 'RD ${amount.toStringAsFixed(2)}',
              bold: true,
            ),
            _DetailRow(
              label: 'Plazo',
              value: '$installments meses',
            ),
            _DetailRow(
              label: 'Tasa de Interés Anual',
              value: '${tier.annualRate.toStringAsFixed(2)}%',
            ),
            _DetailRow(
              label: 'Tasa de Interés Mensual',
              value: '${(tier.annualRate / 12).toStringAsFixed(2)}%',
            ),
            
            const Divider(height: 24, color: Colors.white24),

            const Text(
              'Cuota Mensual',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.white70,
              ),
            ),
            const SizedBox(height: 8),
            _DetailRow(
              label: 'Capital + Interés',
              value: 'RD ${monthlyPrincipal.toStringAsFixed(2)}',
            ),
            _DetailRow(
              label: 'Seguro de Préstamo',
              value: 'RD ${(tier.insuranceLoan / 12).toStringAsFixed(2)}',
            ),
            _DetailRow(
              label: 'Seguro de Vida',
              value: 'RD ${(tier.insuranceLife / 12).toStringAsFixed(2)}',
            ),
            _DetailRow(
              label: 'Total Mensual',
              value: 'RD ${monthlyPayment.toStringAsFixed(2)}',
              bold: true,
              highlight: true,
            ),

            const Divider(height: 24, color: Colors.white24),

            const Text(
              'Resumen Total',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.white70,
              ),
            ),
            const SizedBox(height: 8),
            _DetailRow(
              label: 'Total a Pagar',
              value: 'RD ${totalPayment.toStringAsFixed(2)}',
              bold: true,
            ),
            _DetailRow(
              label: 'Total Intereses',
              value: 'RD ${totalInterest.toStringAsFixed(2)}',
            ),
            _DetailRow(
              label: 'Total Seguros',
              value: 'RD ${totalInsurance.toStringAsFixed(2)}',
            ),

            const SizedBox(height: 16),

            // Botón Ver Amortización
            SizedBox(
              width: double.infinity,
              height: 40,
              child: OutlinedButton(
                onPressed: () {
                  // TODO: Implementar tabla de amortización
                },
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFF7ED321), width: 2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Ver Amortización',
                  style: TextStyle(
                    color: Color(0xFF7ED321),
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.label,
    required this.value,
    this.bold = false,
    this.highlight = false,
  });

  final String label;
  final String value;
  final bool bold;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 12,
              fontWeight: bold ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: highlight ? const Color(0xFF7ED321) : Colors.white,
              fontSize: bold ? 14 : 12,
              fontWeight: bold ? FontWeight.bold : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}