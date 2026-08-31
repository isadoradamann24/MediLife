/**import 'package:flutter/material.dart';

class InicioScreen extends StatefulWidget {
  const InicioScreen({super.key});

  @override
  State<InicioScreen> createState() => _InicioScreenState();
}

class _InicioScreenState extends State<InicioScreen> {
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

    // animação da frase
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 4));

      if (!mounted) return false;

      setState(() {
        fraseAtual = (fraseAtual + 1) % frases.length;
      });

      return true;
    });
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
                Navigator.pushNamed(context, '/estatisticas');
              },
            ),

            const Divider(),

            ListTile(
              leading: const Icon(Icons.calculate,
                  color: Color.fromARGB(255, 41, 40, 40)),
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

                // animação
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

                const SizedBox(height: 30),

                // Cadastrar Remédio
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 0, 90, 110),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, '/cadastro');
                    },
                    icon: const Icon(Icons.medication, color: Colors.white),
                    label: const Text(
                      "Cadastrar Remédio",
                      style: TextStyle(color: Colors.white, fontSize: 17),
                    ),
                  ),
                ),

                const SizedBox(height: 15),

                // Ver Estatísticas
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 0, 90, 110),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, '/estatisticas');
                    },
                    icon: const Icon(Icons.analytics, color: Colors.white),
                    label: const Text(
                      "Ver Estatísticas",
                      style: TextStyle(color: Colors.white, fontSize: 17),
                    ),
                  ),
                ),

                const SizedBox(height: 15),

                // Calculadora de Dosagem
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 0, 90, 110),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, '/calculadora');
                    },
                    icon: const Icon(Icons.calculate, color: Colors.white),
                    label: const Text(
                      "Calculadora de Dosagem",
                      style: TextStyle(color: Colors.white, fontSize: 17),
                    ),
                  ),
                ),

                const SizedBox(height: 15),

                // Meus Remédios
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 0, 90, 110),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, '/detalhes');
                    },
                    icon: const Icon(Icons.medication, color: Colors.white),
                    label: const Text(
                      "Meus Remédios",
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

==TELA INATIVADA DO SISTEMA==

**/