import 'package:flutter/material.dart';
import 'dart:math';
import '../../config/app_colors.dart';
import '../../domain/models/loan_tier.dart';

class LoanSummaryModal extends StatefulWidget {
  const LoanSummaryModal({
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
  State<LoanSummaryModal> createState() => _LoanSummaryModalState();
}

class _LoanSummaryModalState extends State<LoanSummaryModal>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _closeModal() {
    _animationController.reverse().then((_) {
      Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final monthlyRate = widget.tier.annualRate / 12 / 100;
    final factor = pow(1 + monthlyRate, widget.installments);
    final monthlyPrincipal = widget.amount * (monthlyRate * factor) / (factor - 1);
    final monthlyInsurance = (widget.tier.insuranceLoan + widget.tier.insuranceLife) / 12;
    final totalInterest = (monthlyPrincipal * widget.installments) - widget.amount;
    final totalInsurance = monthlyInsurance * widget.installments;
    final totalPayment = widget.monthlyPayment * widget.installments;

    return SlideTransition(
      position: _slideAnimation,
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Color(0xFFE5E5E5)),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Resumen del Préstamo',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  IconButton(
                    onPressed: _closeModal,
                    icon: const Icon(
                      Icons.close,
                      color: Colors.black,
                      size: 24,
                    ),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
            ),

            // Contenido scrolleable
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Cuota Mensual Destacada
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'CUOTA MENSUAL ESTIMADA',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[600],
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'RD\$ ${widget.monthlyPayment.toStringAsFixed(0)}',
                            style: const TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Tasa de interés de ${widget.tier.annualRate.toStringAsFixed(1)}% fijo ${widget.installments} meses + Seguros. Las cuotas serán debitadas de tu cuenta automáticamente de la cuenta de ahorro COOPHISPANA',
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey[600],
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Información General
                    Text(
                      'Información General',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _InfoRow(
                      label: 'Monto del Préstamo',
                      value: 'RD ${widget.amount.toStringAsFixed(2)}',
                      highlight: true,
                    ),
                    _InfoRow(
                      label: 'Plazo',
                      value: '${widget.installments} meses',
                    ),
                    _InfoRow(
                      label: 'Tasa de Interés Anual',
                      value: '${widget.tier.annualRate.toStringAsFixed(2)}%',
                    ),

                    const SizedBox(height: 20),

                    // Desglose de la Cuota Mensual
                    Text(
                      'Desglose de la Cuota Mensual',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey[200]!),
                      ),
                      child: Column(
                        children: [
                          _DetailRow(
                            label: 'Capital + Interés',
                            value: 'RD ${monthlyPrincipal.toStringAsFixed(2)}',
                          ),
                          _DetailRow(
                            label: 'Seguro de Préstamo',
                            value: 'RD ${(widget.tier.insuranceLoan / 12).toStringAsFixed(2)}',
                          ),
                          _DetailRow(
                            label: 'Seguro de Vida',
                            value: 'RD ${(widget.tier.insuranceLife / 12).toStringAsFixed(2)}',
                          ),
                          const Divider(height: 16, color: Color(0xFFE5E5E5)),
                          _DetailRow(
                            label: 'Total Mensual',
                            value: 'RD ${widget.monthlyPayment.toStringAsFixed(2)}',
                            bold: true,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Resumen de Pago Total
                    Text(
                      'Resumen Total',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey[200]!),
                      ),
                      child: Column(
                        children: [
                          _DetailRow(
                            label: 'Total Intereses',
                            value: 'RD ${totalInterest.toStringAsFixed(2)}',
                          ),
                          _DetailRow(
                            label: 'Total Seguros',
                            value: 'RD ${totalInsurance.toStringAsFixed(2)}',
                          ),
                          const Divider(height: 16, color: Color(0xFFE5E5E5)),
                          _DetailRow(
                            label: 'Total a Pagar',
                            value: 'RD ${totalPayment.toStringAsFixed(2)}',
                            bold: true,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),

            // Botones de acción
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 48,
                      child: OutlinedButton.icon(
                        onPressed: () {
                          // TODO: Descargar tabla
                        },
                        icon: const Icon(Icons.download, size: 18),
                        label: const Text(
                          'Descargar',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(
                            color: AppColors.primary,
                            width: 2,
                          ),
                          foregroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: SizedBox(
                      height: 48,
                      child: OutlinedButton.icon(
                        onPressed: () {
                          // TODO: Compartir
                        },
                        icon: const Icon(Icons.share, size: 18),
                        label: const Text(
                          'Compartir',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(
                            color: AppColors.primary,
                            width: 2,
                          ),
                          foregroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.label,
    required this.value,
    this.highlight = false,
  });

  final String label;
  final String value;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.grey[700],
              fontSize: 13,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: highlight ? AppColors.primary : Colors.black87,
              fontSize: 14,
              fontWeight: highlight ? FontWeight.bold : FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.label,
    required this.value,
    this.bold = false,
  });

  final String label;
  final String value;
  final bool bold;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.grey[700],
              fontSize: 12,
              fontWeight: bold ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: Colors.black87,
              fontSize: bold ? 14 : 12,
              fontWeight: bold ? FontWeight.bold : FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}