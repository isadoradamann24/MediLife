import 'package:flutter/material.dart';

class InicioScreen extends StatefulWidget {
  const InicioScreen({super.key});

  @override
  State<InicioScreen> createState() => _InicioScreenState();
}

class _InicioScreenState extends State<InicioScreen> {
  TextEditingController nomeController = TextEditingController();
  TextEditingController quantidadeController = TextEditingController();
  TextEditingController horarioController = TextEditingController();
  TextEditingController motivoController = TextEditingController();

  List<Map<String, dynamic>> remedios = [];

  List<String> diasSemana = ['Seg', 'Ter', 'Qua', 'Qui', 'Sex', 'Sáb', 'Dom'];

  List<bool> diasSelecionados = List.filled(7, false);

  bool aumentarBotao = false;

  int fraseAtual = 0;

  final List<String> frases = [
    "💙 Cuidar da saúde é cuidar da vida.",
    "💊 Não esqueça seu medicamento de hoje.",
    "😊 Pequenos cuidados fazem grande diferença.",
    "❤️ Sua saúde merece atenção todos os dias."
  ];

  @override
  void initState() {
    super.initState();

    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 4));

      if (!mounted) return false;

      setState(() {
        fraseAtual = (fraseAtual + 1) % frases.length;
      });

      return true;
    });
  }

  void salvarRemedio() async {
    if (nomeController.text.isEmpty ||
        quantidadeController.text.isEmpty ||
        horarioController.text.isEmpty ||
        motivoController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Preencha todos os campos")),
      );
      return;
    }

    if (!diasSelecionados.contains(true)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Selecione pelo menos um dia")),
      );
      return;
    }

    setState(() {
      aumentarBotao = true;
    });

    await Future.delayed(const Duration(milliseconds: 180));

    setState(() {
      aumentarBotao = false;
    });

    Map<String, dynamic> remedio = {
      'nome': nomeController.text,
      'quantidade': quantidadeController.text,
      'horario': horarioController.text,
      'motivo': motivoController.text,
      'dias': List<bool>.from(diasSelecionados),
      'tomou': false,
    };

    setState(() {
      remedios.add(remedio);
    });

    nomeController.clear();
    quantidadeController.clear();
    horarioController.clear();
    motivoController.clear();
    diasSelecionados = List.filled(7, false);

    Navigator.pushNamed(
      context,
      '/detalhes',
      arguments: remedio,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 235, 245, 245),

      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 0, 90, 110),
        title: const Text("MedLife"),
      ),

      drawer: Drawer(
        child: Column(
          children: [
            const SizedBox(height: 50),
            const Icon(Icons.medication, size: 85, color: Colors.teal),

            const SizedBox(height: 15),

            ListTile(
              leading: const Icon(Icons.home),
              title: const Text("Início"),
              onTap: () {
                Navigator.pushReplacementNamed(context, '/');
              },
            ),

            const Divider(),

            ListTile(
              leading: const Icon(Icons.login),
              title: const Text("Login"),
              onTap: () {
                Navigator.pushReplacementNamed(context, '/login');
              },
            ),

            const Divider(),

            ListTile(
              leading: const Icon(Icons.analytics),
              title: const Text("Estatísticas"),
              onTap: () {
                Navigator.pushNamed(
                  context,
                  '/estatisticas',
                  arguments: remedios,
                );
              },
            ),

            const Divider(),

            // 💊 NOVO ITEM - CALCULADORA
            ListTile(
              leading: const Icon(Icons.calculate, color: Color.fromARGB(255, 41, 40, 40)),
              title: const Text("Calculadora de Dosagem"),
              onTap: () {
                Navigator.pushNamed(context, '/calculadora');
              },
            ),
          ],
        ),
      ),

      body: Center(
        child: SingleChildScrollView(
          child: Container(
            width: 430,
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [
                BoxShadow(color: Colors.black12, blurRadius: 8),
              ],
            ),
            child: Column(
              children: [
                const Icon(Icons.medication, size: 85, color: Colors.teal),

                const SizedBox(height: 10),

                const Text(
                  "MedLife",
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 15),

                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 800),
                  child: Text(
                    frases[fraseAtual],
                    key: ValueKey(frases[fraseAtual]),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                      fontStyle: FontStyle.italic,
                      color: Colors.teal,
                    ),
                  ),
                ),

                const SizedBox(height: 25),

                TextField(
                  controller: nomeController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    labelText: 'Nome do Remédio',
                  ),
                ),

                const SizedBox(height: 14),

                TextField(
                  controller: quantidadeController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    labelText: 'Quantidade',
                  ),
                ),

                const SizedBox(height: 14),

                TextField(
                  controller: horarioController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    labelText: 'Horário (00:00)',
                  ),
                ),

                const SizedBox(height: 14),

                TextField(
                  controller: motivoController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    labelText: 'Motivo do uso',
                  ),
                ),

                const SizedBox(height: 18),

                const Text(
                  'Dias da Semana',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                ),

                Wrap(
                  spacing: 8,
                  children: List.generate(
                    diasSemana.length,
                    (index) {
                      return Column(
                        children: [
                          Text(diasSemana[index]),
                          Checkbox(
                            value: diasSelecionados[index],
                            onChanged: (value) {
                              setState(() {
                                diasSelecionados[index] = value!;
                              });
                            },
                          ),
                        ],
                      );
                    },
                  ),
                ),

                const SizedBox(height: 25),

                AnimatedScale(
                  scale: aumentarBotao ? 1.08 : 1.0,
                  duration: const Duration(milliseconds: 200),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                      ),
                      onPressed: salvarRemedio,
                      child: const Text(
                        "Salvar Remédio",
                        style: TextStyle(color: Colors.white, fontSize: 17),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 15),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          const Color.fromARGB(255, 0, 90, 110),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                    ),
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        '/estatisticas',
                        arguments: remedios,
                      );
                    },
                    icon: const Icon(Icons.analytics, color: Colors.white),
                    label: const Text(
                      "Ver Estatísticas",
                      style: TextStyle(color: Colors.white, fontSize: 17),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}