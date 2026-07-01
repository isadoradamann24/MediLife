import 'package:flutter/material.dart';

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

  double opacidade = 0;

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
      opacidade = 0;
    });

    // animação de entrada (fade)
    Future.delayed(const Duration(milliseconds: 100), () {
      setState(() {
        opacidade = 1;
      });
    });
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

  Widget resultadoAnimado() {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 800),
      opacity: opacidade,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.all(18),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.teal.shade50,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color.fromARGB(255, 41, 48, 47)),
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

            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: doseTotal),
              duration: const Duration(milliseconds: 900),
              builder: (context, value, child) {
                return Text(
                  "Dose total: ${value.toStringAsFixed(0)} mg",
                  style: const TextStyle(fontSize: 16),
                );
              },
            ),

            const SizedBox(height: 5),

            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: comprimidos),
              duration: const Duration(milliseconds: 900),
              builder: (context, value, child) {
                return Text(
                  "Comprimidos: ${value.toStringAsFixed(2)}",
                  style: const TextStyle(fontSize: 16),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 0, 90, 110),
        title: const Text("Calculadora de Dosagem"),
      ),

      body: SingleChildScrollView(
        child: Center(
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
              children: [
                const Hero(
                  tag: "remedio",
                  child: Icon(
                    Icons.medication,
                    size: 80,
                    color: Colors.teal,
                  ),
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

                campo(
                  "Peso (kg)",
                  Icons.monitor_weight,
                  pesoController,
                  "Ex: 60",
                ),

                campo(
                  "Dose (mg/kg)",
                  Icons.medical_services,
                  doseController,
                  "Ex: 10",
                ),

                campo(
                  "Concentração (mg)",
                  Icons.science,
                  concentracaoController,
                  "Ex: 500",
                ),

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
                      color: Color.fromARGB(255, 255, 255, 255), 
                      fontSize: 17,
                  )),
                    

                  ),
                ),

                const SizedBox(height: 20),

                if (mostrarResultado) resultadoAnimado(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}