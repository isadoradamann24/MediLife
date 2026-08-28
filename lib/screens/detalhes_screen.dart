import 'package:flutter/material.dart';

import '../database/database.dart';
import '../models/remedio.dart';

class DetalhesScreen extends StatefulWidget {
  const DetalhesScreen({super.key});

  @override
  State<DetalhesScreen> createState() => _DetalhesScreenState();
}

class _DetalhesScreenState extends State<DetalhesScreen> {
  List<Remedio> remedios = [];

  bool carregando = true;

  @override
  void initState() {
    super.initState();

    carregarRemedios();
  }

  Future<void> carregarRemedios() async {
    DatabaseHandler banco = DatabaseHandler();

    final lista = await banco.retrieveRemedios();

    if (!mounted) return;

    setState(() {
      remedios = lista;

      carregando = false;
    });
  }

  Future<void> excluir(int id) async {
    DatabaseHandler banco = DatabaseHandler();

    await banco.deleteRemedio(id);

    carregarRemedios();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Meus Remédios")),

      body: carregando
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: remedios.length,

              itemBuilder: (context, index) {
                final remedio = remedios[index];

                return Card(
                  child: ListTile(
                    title: Text(remedio.nome),

                    subtitle: Text(
                      "Quantidade: ${remedio.quantidade}\n"
                      "Horário: ${remedio.horario}\n"
                      "${remedio.tomou == 1 ? "Tomado" : "Pendente"}",
                    ),

                    onTap: () {
                      Navigator.pushNamed(
                        context,

                        "/detalhesRemedio",

                        arguments: remedio,
                      );
                    },

                    trailing: IconButton(
                      icon: const Icon(Icons.delete),

                      onPressed: () {
                        if (remedio.id != null) {
                          excluir(remedio.id!);
                        }
                      },
                    ),
                  ),
                );
              },
            ),
    );
  }
}
