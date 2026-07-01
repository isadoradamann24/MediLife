import 'package:flutter/material.dart';

class CadastroRemedioScreen extends StatefulWidget {
  const CadastroRemedioScreen({super.key});

  @override
  State<CadastroRemedioScreen> createState() =>
      _CadastroRemedioScreenState();
}

class _CadastroRemedioScreenState
    extends State<CadastroRemedioScreen> {

  final TextEditingController nomeController = TextEditingController();
  final TextEditingController dosagemController = TextEditingController();
  final TextEditingController quantidadeController = TextEditingController();
  final TextEditingController horarioController = TextEditingController();

  List<Map<String, dynamic>> remedios = [];

  void salvarRemedio() {

    if (nomeController.text.isEmpty ||
        dosagemController.text.isEmpty ||
        quantidadeController.text.isEmpty ||
        horarioController.text.isEmpty) {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Preencha todos os campos."),
        ),
      );
      return;
    }

    setState(() {
      remedios.add({
        "nome": nomeController.text,
        "dosagem": dosagemController.text,
        "quantidade": quantidadeController.text,
        "horario": horarioController.text,
      });
    });

    nomeController.clear();
    dosagemController.clear();
    quantidadeController.clear();
    horarioController.clear();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Remédio cadastrado com sucesso!"),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor: const Color.fromARGB(255, 235, 245, 245),

      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 0, 90, 110),
        foregroundColor: Colors.white,
        centerTitle: true,
        title: const Text("Cadastro de Remédios"),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(

          children: [

            TextField(
              controller: nomeController,
              decoration: const InputDecoration(
                labelText: "Nome do remédio",
                prefixIcon: Icon(Icons.medication),
              ),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: dosagemController,
              decoration: const InputDecoration(
                labelText: "Dosagem (Ex: 500 mg)",
                prefixIcon: Icon(Icons.medical_services),
              ),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: quantidadeController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Quantidade",
                prefixIcon: Icon(Icons.numbers),
              ),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: horarioController,
              decoration: const InputDecoration(
                labelText: "Horário (Ex: 08:00)",
                prefixIcon: Icon(Icons.access_time),
              ),
            ),

            const SizedBox(height: 25),

            SizedBox(
              width: double.infinity,

              child: ElevatedButton(

                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding: const EdgeInsets.all(15),
                ),

                onPressed: salvarRemedio,

                child: const Text(
                  "Cadastrar Remédio",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 25),

            const Text(
              "Remédios cadastrados",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            Expanded(
              child: ListView.builder(
                itemCount: remedios.length,

                itemBuilder: (context, index) {

                  final remedio = remedios[index];

                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 6),

                    child: ListTile(

                      leading: const Icon(
                        Icons.medication,
                        color: Color.fromARGB(255, 0, 90, 110),
                      ),

                      title: Text(remedio["nome"]),

                      subtitle: Text(
                        "Dosagem: ${remedio["dosagem"]}\n"
                        "Quantidade: ${remedio["quantidade"]}\n"
                        "Horário: ${remedio["horario"]}",
                      ),

                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}