import 'package:flutter/material.dart';

class DetalhesScreen extends StatefulWidget {
  const DetalhesScreen({super.key});

  @override
  State<DetalhesScreen> createState() => _DetalhesScreenState();
}

class _DetalhesScreenState extends State<DetalhesScreen> {
  late Map<String, dynamic> remedio;

  final List<String> diasSemana = ['Segunda','Terça','Quarta','Quinta','Sexta','Sábado','Domingo',
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    remedio = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 235, 245, 245),

      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 0, 90, 110),
        title: const Text("Detalhes do Remédio"),
      ),

      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(25),

            child: Column(
              children: [
                const Icon(
                  Icons.medication,
                  size: 100,
                  color: Color.fromARGB(255, 0, 100, 120),
                ),

                const SizedBox(height: 20),

                Text(
                  remedio['nome'],
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 0, 90, 110),
                  ),
                ),

                const SizedBox(height: 25),

                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(25),
                    child: Column(
                      children: [
                        Text(
                          "Quantidade: ${remedio['quantidade']}",
                          style: const TextStyle(fontSize: 18),
                        ),

                        const SizedBox(height: 12),

                        Text(
                          "Horário: ${remedio['horario']}",
                          style: const TextStyle(fontSize: 18),
                        ),

                        const SizedBox(height: 12),

                        Text(
                          "Motivo: ${remedio['motivo']}",
                          style: const TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                const Text(
                  "Dias da Semana",
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 15),

                Column(
                  children: List.generate(
                    diasSemana.length,
                    (index) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            remedio['dias'][index]
                                ? Icons.check_circle
                                : Icons.cancel,
                            color: remedio['dias'][index]
                                ? Colors.green
                                : Colors.red,
                          ),

                          const SizedBox(width: 10),

                          Text(
                            diasSemana[index],
                            style: const TextStyle(fontSize: 17),
                          ),
                        ],
                      );
                    },
                  ),
                ),

                const SizedBox(height: 30),

                SwitchListTile(
                  title: const Text(
                    "Remédio tomado?",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  subtitle: Text(
                    remedio['tomou']
                        ? "Sim, já tomei."
                        : "Ainda não tomei.",
                  ),

                  value: remedio['tomou'],

                  activeColor: Colors.green,

                  onChanged: (valor) {
                    setState(() {
                      remedio['tomou'] = valor;
                    });
                  },
                ),

                const SizedBox(height: 20),

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),

                  decoration: BoxDecoration(
                    color: remedio['tomou']
                        ? Colors.green.shade100
                        : Colors.red.shade100,
                    borderRadius: BorderRadius.circular(18),
                  ),

                  child: Text(
                    remedio['tomou']
                        ? "✅ Remédio já tomado"
                        : "❌ Remédio ainda não tomado",

                    textAlign: TextAlign.center,

                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: remedio['tomou']
                          ? Colors.green
                          : Colors.red,
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                SizedBox(
                  width: 220,

                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                    ),

                    onPressed: () {
                      Navigator.pop(context);
                    },

                    child: const Text(
                      "Voltar",
                      style: TextStyle(color: Colors.white),
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