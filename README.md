# Simulador de Préstamos — Coop Hispana
<img width="430" height="768" alt="image" src="https://github.com/user-attachments/assets/c0a5b796-09f5-43d3-bcb6-d398498422b9" />
<img width="432" height="768" alt="image" src="https://github.com/user-attachments/assets/61f41387-50ed-4226-99b5-1811af723fa3" />
<img width="432" height="768" alt="image" src="https://github.com/user-attachments/assets/2df16433-9f78-46f8-8b6d-a371168fbe04" />
<img width="427" height="752" alt="image" src="https://github.com/user-attachments/assets/20f8a016-1d01-4b44-afb0-3c0e2f6ed7dd" />


Aplicación Flutter para simular préstamos de manera clara y reactiva, incorporando reglas de negocio de tasas dinámicas, restricciones de plazo por monto y cálculo automático de la cuota mensual con seguros.

## Objetivo
- Permitir que un socio simule un préstamo ingresando monto y plazo.
- Traducir reglas de negocio a una interfaz funcional, validada y amigable.
- Actualizar cálculos en tiempo real y comunicar restricciones con claridad.

## Características
- Entrada de `Monto` con validaciones y filtrado numérico.
- Control de `Plazo (cuotas)` con tope dinámico según el monto.
- Tasa anual y seguros derivados automáticamente del rango del monto.
- Cálculo de `Cuota mensual` incluyendo capital, interés y seguros.
- Modales de resumen y tabla de amortización.
- Interacciones deshabilitadas cuando hay errores o datos inválidos.

## Reglas de Negocio
Las reglas se implementan como tramos (tiers) que determinan tasa anual, máximo de cuotas y seguros asociados, en función del monto ingresado.

| Rango de Monto (RD)            | Máx. Cuotas | Tasa Anual | Seguro Préstamo (anual) | Seguro de Vida (anual) |
|--------------------------------|-------------|------------|--------------------------|------------------------|
| > 499 y ≤ 100,000              | 24          | 18%        | 500.00                   | 200.00                 |
| > 100,000 y ≤ 500,000          | 48          | 12%        | 645.00                   | 800.00                 |
| > 500,000 y ≤ 1,000,000        | 72          | 10%        | 1,000.00                 | 1,000.00               |
| > 1,000,000 y ≤ 1,500,000      | 96          | 9%         | 300.00                   | 600.00                 |
| > 1,500,000 y ≤ 3,000,000      | 120         | 6%         | 1,200.00                 | 1,200.00               |

- Selección de plazo: el usuario no puede elegir un plazo mayor al `Máx. Cuotas` del tramo correspondiente.
- Monto máximo permitido: RD 3,000,000.00.

Implementación:
- Definición de tramos: `lib/domain/services/loan_calculator.dart:5`
- Selección de tramo para un monto: `lib/domain/services/loan_calculator.dart:48`
- Validación de monto máximo: `lib/domain/services/loan_calculator.dart:78`
- Tope dinámico de cuotas en UI: `lib/presentation/pages/loan_simulator_page.dart:34-37`
- Mensaje de límite bajo el slider: `lib/presentation/widgets/loan_input_card.dart:106-117`

## Fórmula de Cálculo
La cuota mensual se calcula combinando:
- Capital + interés bajo la fórmula de amortización estándar (tasa mensual efectiva)
- Seguros prorrateados de forma mensual

Definiciones:
- `rate_mensual = tasa_anual / 12 / 100`
- Para `installments` cuotas, si la tasa mensual es cero: `principal = amount / installments`
- Si la tasa mensual es mayor a cero: `principal = amount × (rate_mensual × (1 + rate_mensual)^installments) / ((1 + rate_mensual)^installments − 1)`
- Seguros mensuales: `(seguro_prestamo_anual + seguro_vida_anual) / 12`
- `cuota_mensual = principal + seguros_mensuales`

Implementación del cálculo:
- `lib/domain/services/loan_calculator.dart:57-76`

Nota: El interés porcentual se convierte a decimal para el cálculo. Los seguros se presentan prorrateados de forma mensual y también se muestran desglosados en el modal de resumen.

## Validaciones y UX
- Filtrado de entrada: solo dígitos (`TextInputFormatter`) para evitar caracteres inválidos (`lib/presentation/widgets/loan_input_card.dart:50-52`).
- No negativos: el filtro no admite el signo `-`; montos no numéricos se tratan como `0`.
- Monto máximo: error mostrado en el campo de monto (`lib/presentation/widgets/loan_input_card.dart:41-43`) cuando supera RD 3,000,000.00.
- Reactividad: los cálculos y restricciones se actualizan al cambiar el monto o el plazo (`lib/presentation/pages/loan_simulator_page.dart:28-45`).
- Acciones deshabilitadas: botones de `Calcular` y `Ver Amortización` se inhabilitan si hay errores o tramo inválido (`lib/presentation/pages/loan_simulator_page.dart:185-187`, `200-205`).
- Comunicación de límites: texto bajo el slider indica el máximo permitido para el monto actual.

## Arquitectura
- `lib/main.dart`: arranque y configuración del `MaterialApp` (`lib/main.dart:12-20`).
- `lib/presentation/pages/loan_simulator_page.dart`: pantalla principal con estado y acciones.
- `lib/presentation/widgets/*`: componentes UI reutilizables (`LoanInputCard`, `LoanSummaryModal`, `AmortizationTableModal`).
- `lib/domain/models/loan_tier.dart`: modelo para reglas por tramo (`lib/domain/models/loan_tier.dart:1-19`).
- `lib/domain/services/loan_calculator.dart`: lógica de negocio para selección de tramo, validación y cálculo.
- `lib/config/*`: colores y tema (`AppTheme`, `AppColors`).

## Requisitos Técnicos
- Flutter SDK `>= 3.0.0` (ver `pubspec.yaml`).
- Dart estable y toolchain de Flutter para su plataforma (Android/iOS/Web/Windows/macOS/Linux).

## Instalación y Ejecución
1. Instalar Flutter 3.x: https://docs.flutter.dev/get-started/install
2. Clonar el repositorio.
3. Desde la raíz del proyecto:
   - `flutter pub get`
   - `flutter run`
4. Opcional:
   - `flutter analyze` para análisis estático.
   - `flutter test` para ejecutar pruebas.

## Uso
- Ingresar el `Monto` en RD.
- Ajustar el `Plazo (cuotas)` con el slider (se limita automáticamente según el monto).
- Presionar `Calcular Préstamo` para ver el resumen con desglose de intereses y seguros.
- Presionar `Ver Amortización` para una tabla detallada por mes.

## Notas y Alcances
- Los montos y tasas se basan en tramos predeterminados del negocio.
- La entrada se valida para evitar caracteres inválidos y montos fuera de rango.
- La interfaz muestra de manera explícita las restricciones para mejorar la experiencia del usuario.

## Licencia
Proyecto con fines demostrativos para simulación de reglas de préstamo de Coop Hispana.
