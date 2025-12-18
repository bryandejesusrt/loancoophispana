import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../domain/models/loan_tier.dart';

class LoanInputCard extends StatelessWidget {
  const LoanInputCard({
    super.key,
    required this.amount,
    required this.installments,
    required this.minInstallments,
    required this.maxInstallments,
    required this.onAmountChanged,
    required this.onInstallmentsChanged,
    required this.tier,
    this.sliderDisabled = false,
    this.errorText,
  });

  final double amount;
  final int installments;
  final int minInstallments;
  final int maxInstallments;
  final bool sliderDisabled;
  final void Function(String value) onAmountChanged;
  final void Function(double value) onInstallmentsChanged;
  final LoanTier? tier;
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          decoration: InputDecoration(
            hintText: '50,000',
            hintStyle: TextStyle(
              color: Colors.white.withOpacity(0.5),
              fontSize: 16,
            ),
            errorText: errorText,
            errorStyle: const TextStyle(color: Colors.red),
          ),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
          ],
          onChanged: onAmountChanged,
        ),
        
        const SizedBox(height: 32),

        // Título y valor del plazo
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Plazo (cuotas)',
              style: TextStyle(
                color: Colors.white.withOpacity(0.7),
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              '$installments meses',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 10),

        // Slider de cuotas
        SliderTheme(
          data: SliderThemeData(
            trackHeight: 6,
            activeTrackColor: const Color(0xFF7ED321),
            inactiveTrackColor: Colors.white.withOpacity(0.2),
            thumbColor: const Color(0xFF7ED321),
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12),
            overlayColor: const Color(0xFF7ED321).withOpacity(0.2),
            overlayShape: const RoundSliderOverlayShape(overlayRadius: 24),
          ),
          child: Slider(
            value: installments.toDouble().clamp(
              minInstallments.toDouble(),
              maxInstallments.toDouble(),
            ),
            min: minInstallments.toDouble(),
            max: maxInstallments.toDouble(),
            divisions: maxInstallments - minInstallments,
            onChanged: sliderDisabled ? null : onInstallmentsChanged,
          ),
        ),

        // Texto informativo debajo del slider
        if (tier != null)
          Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Text(
              'Máximo permitido para este monto: ${tier!.maxInstallments} cuotas',
              style: TextStyle(
                color: Colors.white.withOpacity(0.5),
                fontSize: 12,
              ),
            ),
          )
        else
          Padding(
            padding: const EdgeInsets.only(top: 1),
            child: Text(
              'Ingrese un monto válido para continuar',
              style: TextStyle(
                color: Colors.white.withOpacity(0.5),
                fontSize: 12,
              ),
            ),
          ),

        const SizedBox(height: 24),

        // Información de tasa y detalles legales
        Row(
          children: [
            Expanded(
              child: _InfoBox(
                label: tier != null ? '${tier!.annualRate.toStringAsFixed(0)}%' : '--',
                sublabel: 'Tasa de interés anual',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _InfoBox(
                label: tier != null 
                    ? 'RD ${((tier!.insuranceLoan + tier!.insuranceLife) / 12).toStringAsFixed(0)}'
                    : '--',
                sublabel: 'Seg. mensual',
                tooltip: tier != null
                    ? 'Seguro Préstamo: RD ${tier!.insuranceLoan.toStringAsFixed(2)}/año\nSeguro Vida: RD ${tier!.insuranceLife.toStringAsFixed(2)}/año'
                    : null,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _InfoBox extends StatelessWidget {
  const _InfoBox({
    required this.label,
    required this.sublabel,
    this.tooltip,
  });

  final String label;
  final String sublabel;
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    Widget content = Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            sublabel,
            style: TextStyle(
              color: Colors.white.withOpacity(0.5),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );

    if (tooltip != null) {
      return Tooltip(
        message: tooltip!,
        child: content,
      );
    }

    return content;
  }
}
