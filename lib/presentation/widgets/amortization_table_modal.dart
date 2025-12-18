import 'package:flutter/material.dart';
import 'dart:math';
import '../../config/app_colors.dart';
import '../../domain/models/loan_tier.dart';

class AmortizationTableModal extends StatefulWidget {
  const AmortizationTableModal({
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
  State<AmortizationTableModal> createState() => _AmortizationTableModalState();
}

class _AmortizationTableModalState extends State<AmortizationTableModal>
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

  List<AmortizationRow> _generateAmortizationSchedule() {
    final monthlyRate = widget.tier.annualRate / 12 / 100;
    final factor = pow(1 + monthlyRate, widget.installments);
    final monthlyPrincipal = widget.amount *
        (monthlyRate * factor) / (factor - 1);
    final monthlyInsurance =
        (widget.tier.insuranceLoan + widget.tier.insuranceLife) / 12;

    List<AmortizationRow> schedule = [];
    double remainingBalance = widget.amount;
    DateTime currentDate = DateTime.now();

    for (int i = 1; i <= widget.installments; i++) {
      final interest = remainingBalance * monthlyRate;
      final principal = monthlyPrincipal - interest;
      final payment = principal + interest + monthlyInsurance;
      remainingBalance -= principal;

      if (remainingBalance < 0) remainingBalance = 0;

      schedule.add(
        AmortizationRow(
          paymentNumber: i,
          date: currentDate,
          payment: payment,
          interest: interest,
          principal: principal,
          insurance: monthlyInsurance,
          balance: remainingBalance,
          isPaid: false,
        ),
      );

      currentDate = currentDate.add(const Duration(days: 30));
    }

    return schedule;
  }

  @override
  Widget build(BuildContext context) {
    final schedule = _generateAmortizationSchedule();

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
                    'Tabla de Amortización',
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

            // Subtítulo
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Historial de pagos',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[700],
                  ),
                ),
              ),
            ),

            // Tabla scrolleable
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    // Header de la tabla
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 35,
                            child: Text(
                              '',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey[600],
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(
                              'Fecha',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey[600],
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(
                              'Cuota',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey[600],
                              ),
                              textAlign: TextAlign.right,
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(
                              'Interés',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey[600],
                              ),
                              textAlign: TextAlign.right,
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(
                              'Saldo',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey[600],
                              ),
                              textAlign: TextAlign.right,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Filas de la tabla
                    ...schedule.map((row) => _AmortizationTableRow(row)),
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

class _AmortizationTableRow extends StatelessWidget {
  const _AmortizationTableRow(this.row);

  final AmortizationRow row;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 35,
              child: Container(
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Icon(
                    row.isPaid ? Icons.check : Icons.circle,
                    color: Colors.white,
                    size: 10,
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                '${row.date.day.toString().padLeft(2, '0')}/${row.date.month.toString().padLeft(2, '0')}/${row.date.year}',
                style: const TextStyle(
                  fontSize: 11,
                  color: Colors.black87,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                'RD ${row.payment.toStringAsFixed(0)}',
                style: const TextStyle(
                  fontSize: 11,
                  color: Colors.black87,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.right,
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                'RD ${row.interest.toStringAsFixed(0)}',
                style: const TextStyle(
                  fontSize: 11,
                  color: Colors.black87,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.right,
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                'RD ${row.balance.toStringAsFixed(0)}',
                style: const TextStyle(
                  fontSize: 11,
                  color: Colors.black87,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.right,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AmortizationRow {
  final int paymentNumber;
  final DateTime date;
  final double payment;
  final double interest;
  final double principal;
  final double insurance;
  final double balance;
  final bool isPaid;

  AmortizationRow({
    required this.paymentNumber,
    required this.date,
    required this.payment,
    required this.interest,
    required this.principal,
    required this.insurance,
    required this.balance,
    required this.isPaid,
  });
}