import 'package:flutter/material.dart';

class DetalhesScreen extends StatefulWidget {
  const DetalhesScreen({super.key});

  @override
  State<DetalhesScreen> createState() => _DetalhesScreenState();
}

class _DetalhesScreenState extends State<DetalhesScreen> {
  Map<String, dynamic>? remedio;

  bool tomou = false;

  final List<String> frases = [
    "💚 Ótimo! Você cuidou da sua saúde hoje.",
    "💊 Excelente! Remédio tomado com sucesso.",
    "✨ Mais um dia de cuidado com você mesmo.",
    "❤️ Parabéns! Sua saúde em primeiro lugar."
  ];

  int fraseAtual = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    remedio = ModalRoute.of(context)?.settings.arguments
        as Map<String, dynamic>?;
  }

  void alternarTomado(bool valor) {
    setState(() {
      tomou = valor;

      if (valor) {
        fraseAtual = (fraseAtual + 1) % frases.length;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final dias = remedio?['dias'] ?? List.filled(7, false);

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 235, 245, 245),

      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 0, 90, 110),
        title: const Text("Detalhes do Remédio"),
      ),

      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(25),
          child: Column(
            children: [

              const Icon(Icons.medication, size: 100),

              const SizedBox(height: 20),

              Text(
                remedio?['nome'] ?? 'Sem nome',
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),

              const SizedBox(height: 25),

              Text(
                "Quantidade: ${remedio?['quantidade'] ?? ''}",
                style: const TextStyle(color: Colors.black),
              ),

              Text(
                "Horário: ${remedio?['horario'] ?? ''}",
                style: const TextStyle(color: Colors.black),
              ),

              Text(
                "Motivo: ${remedio?['motivo'] ?? ''}",
                style: const TextStyle(color: Colors.black),
              ),

              const SizedBox(height: 25),

              Column(
                children: List.generate(7, (index) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        dias[index]
                            ? Icons.check_circle
                            : Icons.cancel,
                        color: dias[index] ? Colors.green : Colors.red,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        ["Seg","Ter","Qua","Qui","Sex","Sáb","Dom"][index],
                        style: const TextStyle(color: Colors.black),
                      ),
                    ],
                  );
                }),
              ),

              const SizedBox(height: 25),

              SwitchListTile(
                title: const Text(
                  "Remédio tomado?",
                  style: TextStyle(color: Colors.black),
                ),
                value: tomou,
                activeColor: Colors.green,
                onChanged: alternarTomado,
              ),

              const SizedBox(height: 40),

//animação - AnimatedSwitcher

              AnimatedSwitcher(
                duration: const Duration(milliseconds: 700),
                child: tomou
                    ? Text(
                        frases[fraseAtual],
                        key: ValueKey(frases[fraseAtual]),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 16,
                          fontStyle: FontStyle.italic,
                          color: Colors.teal,
                        ),
                      )
                    : const SizedBox.shrink(),
              ),

              const SizedBox(height: 60), 

              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                ),
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  "Voltar",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}