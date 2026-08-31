import 'package:flutter/material.dart';

class EstatisticasScreen extends StatefulWidget {
  const EstatisticasScreen({super.key});

  @override
  State<EstatisticasScreen> createState() => _EstatisticasScreenState();
}

class _EstatisticasScreenState extends State<EstatisticasScreen>
    with SingleTickerProviderStateMixin {

//animação

  late AnimationController _controller;
  late Animation<double> _fade;
  late Animation<double> _scale;
  
  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _fade = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );

    _scale = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments;

    final List<Map<String, dynamic>> dados =
        args is List ? List<Map<String, dynamic>>.from(args) : [];

    int total = dados.length;
    int diasTotal = 0;
    String maisUsado = "-";
    int maiorUso = 0;

//calculo

    for (var r in dados) {
      int cont = 0;
      List<bool> dias = List<bool>.from(r["dias"] ?? []);

      for (var d in dias) {
        if (d) {
          cont++;
          diasTotal++;
        }
      }

      if (cont > maiorUso) {
        maiorUso = cont;
        maisUsado = r["nome"] ?? "-";
      }
    }

    double media = total == 0 ? 0 : diasTotal / total;
    double aproveitamento =
        total == 0 ? 0 : (diasTotal / (total * 7)) * 100;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 235, 245, 245),

      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 0, 90, 110),
        title: const Text(
          "Estatísticas",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),

      body: Center(
        child: ScaleTransition(
          scale: _scale,
          child: FadeTransition(
            opacity: _fade,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [

                    const Icon(
                      Icons.analytics,
                      size: 90,
                      color: Color.fromARGB(255, 0, 90, 110),
                    ),

                    const SizedBox(height: 20),

                    const Text(
                      "Resumo Geral",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 25),

                    _card("💊 Total de Remédios", "$total"),
                    _card("📅 Total de Dias Marcados", "$diasTotal"),
                    _card("📊 Média por Remédio", media.toStringAsFixed(1)),
                    _card("🏆 Mais Utilizado", maisUsado),
                    _card("📈 Aproveitamento", "${aproveitamento.toStringAsFixed(1)}%"),

                    const SizedBox(height: 25),

                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 40,
                          vertical: 14,
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        "Voltar",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _card(String titulo, String valor) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 3),
          )
        ],
      ),
      child: Column(
        children: [
          Text(
            titulo,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            valor,
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 0, 90, 110),
            ),
          ),
        ],
      ),
    );
  }
}