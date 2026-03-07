import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart'; // Importamos el paquete de audio
import '../models/calculator_model.dart';

class CalculatorPage extends StatefulWidget {
  const CalculatorPage({super.key});

  @override
  State<CalculatorPage> createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  final Calculator _calculator = Calculator();
  final TextEditingController _numero1Controller = TextEditingController();
  final TextEditingController _numero2Controller = TextEditingController();
  String _resultado = '0';
  
  bool _isDartVaderMode = false; 
  
  // Instancia del reproductor de audio
  final AudioPlayer _audioPlayer = AudioPlayer();

  void _realizarOperacion(String operacion) {
    try {
      double num1 = _numero1Controller.text.isEmpty ? 0 : double.parse(_numero1Controller.text);
      double num2 = _numero2Controller.text.isEmpty ? 0 : double.parse(_numero2Controller.text);
      double resultado;

      switch (operacion) {
        case 'sumar': resultado = _calculator.sumar(num1, num2); break;
        case 'restar': resultado = _calculator.restar(num1, num2); break;
        case 'multiplicar': resultado = _calculator.multiplicar(num1, num2); break;
        case 'dividir': resultado = _calculator.dividir(num1, num2); break;
        case 'exponencial': resultado = _calculator.exponencial(num1, num2); break;
        case 'factorial': resultado = _calculator.factorial(num1); break;
        case 'raiz': resultado = _calculator.raizCuadrada(num1); break;
        default: resultado = 0;
      }

      setState(() {
        _resultado = resultado.toStringAsFixed(2);
      });
    } catch (e) {
      setState(() {
        _resultado = 'Error: ${e.toString().replaceAll('Exception: ', '')}';
      });
    }
  }

  void _limpiar() {
    setState(() {
      _numero1Controller.clear();
      _numero2Controller.clear();
      _resultado = '0';
    });
  }

  // Método para manejar el cambio al Lado Oscuro
  void _toggleDartVaderMode() async {
    setState(() {
      _isDartVaderMode = !_isDartVaderMode;
    });

    if (_isDartVaderMode) {
      // Reproduce la marcha imperial (asegúrate de que el nombre coincida con tu archivo)
      await _audioPlayer.play(AssetSource('marcha.mp3'));
    } else {
      // Detiene la música si regresamos al lado luminoso
      await _audioPlayer.stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color bgColor = _isDartVaderMode ? Colors.black : Theme.of(context).scaffoldBackgroundColor;
    final Color textColor = _isDartVaderMode ? Colors.redAccent : Colors.black87;
    final Color appBarColor = _isDartVaderMode ? const Color(0xFF111111) : Theme.of(context).colorScheme.inversePrimary;
    final Color appBarTextColor = _isDartVaderMode ? Colors.redAccent : Colors.black87;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: Text(
          _isDartVaderMode ? 'Dart Vader Calc' : 'Calculadora',
          style: TextStyle(color: appBarTextColor, fontWeight: FontWeight.bold),
        ),
        backgroundColor: appBarColor,
        iconTheme: IconThemeData(color: appBarTextColor),
        actions: [
          IconButton(
            icon: Icon(_isDartVaderMode ? Icons.light_mode : Icons.dark_mode),
            onPressed: _toggleDartVaderMode,
            tooltip: 'Cambiar lado de la Fuerza',
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _limpiar,
            tooltip: 'Limpiar',
          ),
        ],
      ),
      // Usamos un Stack para poner la imagen de fondo por debajo de todo el contenido
      body: Stack(
        children: [
          // Imagen de fondo (Solo aparece en modo Dart Vader)
          if (_isDartVaderMode)
            Positioned.fill(
              child: Opacity(
                opacity: 0.2, // Baja opacidad para que parezca marca de agua
                child: Image.asset(
                  'assets/vader.png',
                  fit: BoxFit.cover, // Ajusta la imagen a toda la pantalla
                ),
              ),
            ),
            
          // Contenido principal de la calculadora
          SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Theme(
              data: Theme.of(context).copyWith(
                inputDecorationTheme: InputDecorationTheme(
                  labelStyle: TextStyle(color: textColor),
                  enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: textColor.withValues(alpha: 0.5))),
                  focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: textColor, width: 2)),
                  prefixIconColor: textColor,
                ),
                textTheme: TextTheme(bodyLarge: TextStyle(color: textColor)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildTextField(controller: _numero1Controller, label: 'Número 1 (Base / Valor único)', textColor: textColor),
                  const SizedBox(height: 16),
                  _buildTextField(controller: _numero2Controller, label: 'Número 2 (Exponente / Secundario)', textColor: textColor),
                  const SizedBox(height: 32),
                  _buildResultado(textColor),
                  const SizedBox(height: 32),
                  _buildBotonesOperaciones(textColor),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({required TextEditingController controller, required String label, required Color textColor}) {
    return TextField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      style: TextStyle(color: textColor),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: const Icon(Icons.calculate),
      ),
    );
  }

  Widget _buildResultado(Color textColor) {
    return Container(
      padding: const EdgeInsets.all(16),
      width: double.infinity,
      decoration: BoxDecoration(
        color: _isDartVaderMode ? Colors.transparent : Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(12),
        border: _isDartVaderMode ? Border.all(color: Colors.redAccent, width: 2) : null,
      ),
      child: Column(
        children: [
          Text('Resultado', style: Theme.of(context).textTheme.titleMedium?.copyWith(color: textColor)),
          const SizedBox(height: 8),
          Text(
            _resultado,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: textColor, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildBotonesOperaciones(Color textColor) {
    final ButtonStyle btnStyle = _isDartVaderMode 
      ? ElevatedButton.styleFrom(
          backgroundColor: Colors.black.withValues(alpha: 0.7), // Botones un poco transparentes para ver el fondo
          foregroundColor: Colors.redAccent,
          side: const BorderSide(color: Colors.redAccent),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        )
      : ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8));

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildBotonOperacion(icono: Icons.add, label: 'Sumar', onPressed: () => _realizarOperacion('sumar'), style: btnStyle),
            _buildBotonOperacion(icono: Icons.remove, label: 'Restar', onPressed: () => _realizarOperacion('restar'), style: btnStyle),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildBotonOperacion(icono: Icons.close, label: 'Multiplic.', onPressed: () => _realizarOperacion('multiplicar'), style: btnStyle),
            _buildBotonOperacion(icono: Icons.safety_divider, label: 'Dividir', onPressed: () => _realizarOperacion('dividir'), style: btnStyle),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildBotonOperacion(icono: Icons.superscript, label: 'Exponencial', onPressed: () => _realizarOperacion('exponencial'), style: btnStyle),
            _buildBotonOperacion(icono: Icons.priority_high, label: 'Factorial', onPressed: () => _realizarOperacion('factorial'), style: btnStyle),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildBotonOperacion(icono: Icons.square_foot, label: 'Raíz Cuadrada', onPressed: () => _realizarOperacion('raiz'), style: btnStyle),
          ],
        ),
      ],
    );
  }

  Widget _buildBotonOperacion({required IconData icono, required String label, required VoidCallback onPressed, required ButtonStyle style}) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: ElevatedButton.icon(
          onPressed: onPressed,
          icon: Icon(icono, size: 18),
          label: Text(label, style: const TextStyle(fontSize: 12)),
          style: style,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _numero1Controller.dispose();
    _numero2Controller.dispose();
    _audioPlayer.dispose(); // Importante liberar el reproductor
    super.dispose();
  }
}