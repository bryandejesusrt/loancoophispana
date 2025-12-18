import 'package:flutter/material.dart';
import '../../config/app_colors.dart';
import '../../domain/services/loan_calculator.dart';
import '../../domain/models/loan_tier.dart';
import '../widgets/loan_input_card.dart';
import '../widgets/loan_summary_modal.dart';
import '../widgets/amortization_table_modal.dart';

class LoanSimulatorPage extends StatefulWidget {
  const LoanSimulatorPage({super.key});

  @override
  State<LoanSimulatorPage> createState() => _LoanSimulatorPageState();
}

class _LoanSimulatorPageState extends State<LoanSimulatorPage> {
  double _amount = 0;
  int _installments = 12;
  String? _error;

  LoanTier? get _currentTier => LoanCalculator.tierFor(_amount);
  
  double? get _monthlyPayment => LoanCalculator.monthlyPayment(
        amount: _amount,
        installments: _installments,
      );

  void _onAmountChanged(String value) {
    final parsed = double.tryParse(value.replaceAll(',', ''));
    setState(() {
      _amount = parsed ?? 0;
      _error = LoanCalculator.validateAmount(_amount);
      
      final tier = _currentTier;
      if (tier != null && _installments > tier.maxInstallments) {
        _installments = tier.maxInstallments;
      }
    });
  }

  void _onInstallmentsChanged(double value) {
    setState(() {
      _installments = value.round();
    });
  }

  void _calculateLoan() {
    final tier = _currentTier;
    final monthlyPayment = _monthlyPayment;
    
    if (tier != null && monthlyPayment != null) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => LoanSummaryModal(
          tier: tier,
          amount: _amount,
          installments: _installments,
          monthlyPayment: monthlyPayment,
        ),
      );
    }
  }

  void _showAmortizationTable() {
    final tier = _currentTier;
    final monthlyPayment = _monthlyPayment;
    
    if (tier != null && monthlyPayment != null) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => AmortizationTableModal(
          tier: tier,
          amount: _amount,
          installments: _installments,
          monthlyPayment: monthlyPayment,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final tier = _currentTier;
    final maxInstallments = tier?.maxInstallments ?? 120;
    final sliderDisabled = tier == null || _error != null;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, size: 18),
          onPressed: () {},
        ),
        title: const Text(
          'Solicitud De Prestamos',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, size: 18),
            onPressed: () {},
          ),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Logo
                Image.asset(
                  'assets/images/logoCoopHispana.png',
                  width: 55,
                  height: 55,
                  alignment: Alignment.centerLeft,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 55,
                      height: 55,
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.eco,
                        color: AppColors.primary,
                        size: 28,
                      ),
                    );
                  },
                ),
                const SizedBox(height: 4),
                
                // Título
                const Text(
                  'Solicitud de Prestamo',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 4),
                
                // Subtítulo
                Text(
                  'Completa los datos a continuación para\ncalcular las cuotas de tu préstamo de forma',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textTertiary,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 16),

                // Input Card
                Expanded(
                  child: SingleChildScrollView(
                    child: LoanInputCard(
                      amount: _amount,
                      installments: _installments,
                      minInstallments: 6,
                      maxInstallments: maxInstallments,
                      onAmountChanged: _onAmountChanged,
                      onInstallmentsChanged: _onInstallmentsChanged,
                      sliderDisabled: sliderDisabled,
                      tier: tier,
                      errorText: _error,
                    ),
                  ),
                ),
                
                const SizedBox(height: 8),

                // Botón Calcular
                SizedBox(
                  width: double.infinity,
                  height: 42,
                  child: ElevatedButton(
                    onPressed: (tier != null && _error == null) ? _calculateLoan : null,
                    child: const Text(
                      'Calcular Prestamo',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                // Botón Ver Amortización
                SizedBox(
                  width: double.infinity,
                  height: 42,
                  child: OutlinedButton(
                    onPressed: (tier != null && _error == null) ? _showAmortizationTable : null,
                    child: const Text(
                      'Ver Amortización',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}