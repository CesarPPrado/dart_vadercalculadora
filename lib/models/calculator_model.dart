import 'dart:math';

/// Modelo que contiene las operaciones básicas de una calculadora
class Calculator {
  /// Suma dos números
  double sumar(double a, double b) {
    return a + b;
  }

  /// Resta dos números
  double restar(double a, double b) {
    return a - b;
  }

  /// Multiplica dos números
  double multiplicar(double a, double b) {
    return a * b;
  }

  /// Divide dos números
  /// Lanza una excepción si el divisor es cero
  double dividir(double a, double b) {
    if (b == 0) {
      throw Exception('No se puede dividir entre cero');
    }
    return a / b;
  }

  /// Calcula el exponencial (base ^ exponente)
  double exponencial(double base, double exponente) {
    return pow(base, exponente).toDouble();
  }

  /// Calcula el factorial de un número
  double factorial(double n) {
    if (n < 0) {
      throw Exception('No existe factorial de números negativos');
    }
    int num = n.toInt();
    int fact = 1;
    for (int i = 1; i <= num; i++) {
      fact *= i;
    }
    return fact.toDouble();
  }

  /// Calcula la raíz cuadrada de un número
  double raizCuadrada(double a) {
    if (a < 0) {
      throw Exception('Raíz cuadrada de un número negativo no es real');
    }
    return sqrt(a);
  }
}