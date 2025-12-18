import 'package:flutter/material.dart';
import 'config/app_theme.dart';
import 'presentation/pages/loan_simulator_page.dart';

void main() {
  runApp(const LoanApp());
}

class LoanApp extends StatelessWidget {
  const LoanApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simulador de Préstamo',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const LoanSimulatorPage(),
    );
  }
}
