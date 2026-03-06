import 'package:flutter/material.dart';
import '../models/calculator_model.dart';

/// Página principal de la calculadora
class CalculatorPage extends StatefulWidget {
  const CalculatorPage({super.key});

  @override
  State<CalculatorPage> createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  // Instancia del modelo de calculadora
  final Calculator _calculator = Calculator();

  // Controladores para los campos de texto
  final TextEditingController _numero1Controller = TextEditingController();
  final TextEditingController _numero2Controller = TextEditingController();

  // Variable para almacenar el resultado
  String _resultado = '0';

  /// Realiza la operación seleccionada
  void _realizarOperacion(String operacion) {
    try {
      // Parsear los números. Si el campo está vacío, lo tomamos como 0 para evitar errores.
      double num1 = _numero1Controller.text.isEmpty ? 0 : double.parse(_numero1Controller.text);
      double num2 = _numero2Controller.text.isEmpty ? 0 : double.parse(_numero2Controller.text);
      double resultado;

      // Ejecutar la operación correspondiente
      switch (operacion) {
        case 'sumar':
          resultado = _calculator.sumar(num1, num2);
          break;
        case 'restar':
          resultado = _calculator.restar(num1, num2);
          break;
        case 'multiplicar':
          resultado = _calculator.multiplicar(num1, num2);
          break;
        case 'dividir':
          resultado = _calculator.dividir(num1, num2);
          break;
        case 'exponencial':
          resultado = _calculator.exponencial(num1, num2); // num1 = base, num2 = exponente
          break;
        case 'factorial':
          resultado = _calculator.factorial(num1); // Solo usa el Número 1
          break;
        case 'raiz':
          resultado = _calculator.raizCuadrada(num1); // Solo usa el Número 1
          break;
        default:
          resultado = 0;
      }

      // Actualizar el estado con el resultado
      setState(() {
        _resultado = resultado.toStringAsFixed(2);
      });
    } catch (e) {
      // Manejar errores
      setState(() {
        _resultado = 'Error: ${e.toString().replaceAll('Exception: ', '')}';
      });
    }
  }

  /// Limpia los campos y el resultado
  void _limpiar() {
    setState(() {
      _numero1Controller.clear();
      _numero2Controller.clear();
      _resultado = '0';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculadora'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _limpiar,
            tooltip: 'Limpiar',
          ),
        ],
      ),
      body: SingleChildScrollView( // Agregado para que no se corte la pantalla con más botones
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildTextField(controller: _numero1Controller, label: 'Número 1 (Base / Valor único)'),
            const SizedBox(height: 16),
            _buildTextField(controller: _numero2Controller, label: 'Número 2 (Exponente / Secundario)'),
            const SizedBox(height: 32),
            _buildResultado(),
            const SizedBox(height: 32),
            _buildBotonesOperaciones(),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
  }) {
    return TextField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        prefixIcon: const Icon(Icons.calculate),
      ),
    );
  }

  Widget _buildResultado() {
    return Container(
      padding: const EdgeInsets.all(16),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            'Resultado',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Theme.of(context).colorScheme.onPrimaryContainer,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _resultado,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith( // Ajustado para textos largos
              color: Theme.of(context).colorScheme.onPrimaryContainer,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBotonesOperaciones() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildBotonOperacion(icono: Icons.add, label: 'Sumar', onPressed: () => _realizarOperacion('sumar')),
            _buildBotonOperacion(icono: Icons.remove, label: 'Restar', onPressed: () => _realizarOperacion('restar')),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildBotonOperacion(icono: Icons.close, label: 'Multiplic.', onPressed: () => _realizarOperacion('multiplicar')),
            _buildBotonOperacion(icono: Icons.safety_divider, label: 'Dividir', onPressed: () => _realizarOperacion('dividir')),
          ],
        ),
        const SizedBox(height: 12),
        // Fila para las nuevas operaciones
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildBotonOperacion(icono: Icons.superscript, label: 'Exponencial', onPressed: () => _realizarOperacion('exponencial')),
            _buildBotonOperacion(icono: Icons.priority_high, label: 'Factorial', onPressed: () => _realizarOperacion('factorial')),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildBotonOperacion(icono: Icons.square_foot, label: 'Raíz Cuadrada', onPressed: () => _realizarOperacion('raiz')),
          ],
        ),
      ],
    );
  }

  Widget _buildBotonOperacion({
    required IconData icono,
    required String label,
    required VoidCallback onPressed,
  }) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: ElevatedButton.icon(
          onPressed: onPressed,
          icon: Icon(icono, size: 18),
          label: Text(label, style: const TextStyle(fontSize: 12)),
          style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8)),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _numero1Controller.dispose();
    _numero2Controller.dispose();
    super.dispose();
  }
}