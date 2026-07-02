import 'package:flutter/material.dart';
import 'dart:math';

class CalculadoraScreen extends StatefulWidget {
  const CalculadoraScreen({super.key});

  @override
  State<CalculadoraScreen> createState() => _CalculadoraScreenState();
}

class _CalculadoraScreenState extends State<CalculadoraScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController pesoController = TextEditingController();
  final TextEditingController doseController = TextEditingController();
  final TextEditingController concentracaoController =
      TextEditingController();

  double doseTotal = 0;
  double comprimidos = 0;

  bool mostrarResultado = false;

//animação
//AnimationController - Tween

  late AnimationController _controller;
  late Animation<double> _flipAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _flipAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

//calculo
//animação - _controller.forward

  void calcularDose() {
    double peso = double.tryParse(pesoController.text) ?? 0;
    double dose = double.tryParse(doseController.text) ?? 0;
    double concentracao = double.tryParse(concentracaoController.text) ?? 0;

    if (peso <= 0 || dose <= 0 || concentracao <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Preencha todos os campos corretamente."),
        ),
      );
      return;
    }

    setState(() {
      doseTotal = peso * dose;
      comprimidos = doseTotal / concentracao;
      mostrarResultado = true;
    });

    _controller.forward(from: 0);
  }

  Widget campo(
    String titulo,
    IconData icone,
    TextEditingController controller,
    String hint,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          titulo,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icone),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
        ),
        const SizedBox(height: 15),
      ],
    );
  }

  Widget _buildCardResultado() {
    return Container(
      padding: const EdgeInsets.all(18),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.teal.shade50,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.teal),
      ),
      child: Column(
        children: [
          const Text(
            "Resultado",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            "Dose total: ${doseTotal.toStringAsFixed(0)} mg",
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 5),
          Text(
            "Comprimidos: ${comprimidos.toStringAsFixed(2)}",
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }

//animação - flip card
//AnimatedBuilder - Transform - Matrix4

  Widget resultadoFlip() {
    return AnimatedBuilder(
      animation: _flipAnimation,
      builder: (context, child) {
        final angle = _flipAnimation.value * pi;
        final isBack = _flipAnimation.value > 0.5;

        return Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001)
            ..rotateY(angle),
          child: isBack
              ? Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.identity()..rotateY(pi),
                  child: _buildCardResultado(),
                )
              : _buildCardResultado(),
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    pesoController.dispose();
    doseController.dispose();
    concentracaoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
  backgroundColor: const Color.fromARGB(255, 235, 245, 245),

  appBar: AppBar(
    backgroundColor: const Color.fromARGB(255, 0, 90, 110),
    title: const Text("Calculadora de Dosagem"),
  ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            width: 430,
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 10),
        ],
      ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.medication,
                  size: 80,
                  color: Colors.teal,
                ),
                const SizedBox(height: 10),
                const Text(
                  "Calculadora de Dosagem",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),

                campo("Peso (kg)", Icons.monitor_weight, pesoController, "Ex: 60"),
                campo("Dose (mg/kg)", Icons.medical_services, doseController, "Ex: 10"),
                campo("Concentração (mg)", Icons.science, concentracaoController, "Ex: 500"),

                const SizedBox(height: 10),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 0, 90, 110),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                    ),
                    onPressed: calcularDose,
                    child: const Text(
                      "Calcular",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 19,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                if (mostrarResultado) resultadoFlip(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}