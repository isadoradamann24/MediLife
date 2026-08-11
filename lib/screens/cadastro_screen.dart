import 'package:flutter/material.dart';
import '../models/remedio.dart';
import '../database/database.dart';

class CadastroRemedioScreen extends StatefulWidget {
  const CadastroRemedioScreen({super.key});

  @override
  State<CadastroRemedioScreen> createState() =>
      _CadastroRemedioScreenState();
}

class _CadastroRemedioScreenState
    extends State<CadastroRemedioScreen> {
  final TextEditingController nomeController =
      TextEditingController();

  final TextEditingController quantidadeController =
      TextEditingController();

  final TextEditingController horarioController =
      TextEditingController();

  final TextEditingController motivoController =
      TextEditingController();

  final List<String> diasSemana = [
    "Segunda",
    "Terça",
    "Quarta",
    "Quinta",
    "Sexta",
    "Sábado",
    "Domingo",
  ];

  final Set<String> diasSelecionados = {};

  bool tomou = false;

  bool salvando = false;

  @override
  void dispose() {
    nomeController.dispose();
    quantidadeController.dispose();
    horarioController.dispose();
    motivoController.dispose();

    super.dispose();
  }

  // ----------------------------------------------------------
  // SELECIONAR HORÁRIO
  // ----------------------------------------------------------

  Future<void> selecionarHorario() async {
    final TimeOfDay? horarioSelecionado =
        await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (horarioSelecionado != null) {
      setState(() {
        horarioController.text =
            horarioSelecionado.format(context);
      });
    }
  }

  // ----------------------------------------------------------
  // SALVAR REMÉDIO
  // ----------------------------------------------------------

  Future<void> salvarRemedio() async {
    if (salvando) return;

    // Verifica o nome
    if (nomeController.text.trim().isEmpty) {
      mostrarMensagem(
        "Digite o nome do remédio.",
      );
      return;
    }

    // Verifica quantidade
    if (quantidadeController.text.trim().isEmpty) {
      mostrarMensagem(
        "Digite a quantidade.",
      );
      return;
    }

    // Verifica horário
    if (horarioController.text.trim().isEmpty) {
      mostrarMensagem(
        "Selecione o horário.",
      );
      return;
    }

    // Verifica os dias
    if (diasSelecionados.isEmpty) {
      mostrarMensagem(
        "Selecione pelo menos um dia.",
      );
      return;
    }

    final int? quantidade =
        int.tryParse(quantidadeController.text.trim());

    if (quantidade == null || quantidade <= 0) {
      mostrarMensagem(
        "Digite uma quantidade válida.",
      );
      return;
    }

    setState(() {
      salvando = true;
    });

    try {
      // Converte os dias selecionados para texto
      final String dias =
          diasSelecionados.join(", ");

      // Cria o objeto Remedio
      final Remedio remedio = Remedio(
        nome: nomeController.text.trim(),
        quantidade: quantidade,
        horario: horarioController.text.trim(),
        motivo: motivoController.text.trim(),
        dias: dias,
        tomou: tomou,
      );

      // Salva no SQLite
      await DatabaseHelper.instance.inserirRemedio(
        remedio.toMap(),
      );

      if (!mounted) return;

      mostrarMensagem(
        "Remédio cadastrado com sucesso!",
      );

      // Limpa os campos
      limparFormulario();

      // Volta para a tela anterior
      Navigator.pop(context, true);
    } catch (erro) {
      if (!mounted) return;

      mostrarMensagem(
        "Erro ao salvar o remédio.",
      );

      debugPrint(
        "Erro ao cadastrar remédio: $erro",
      );
    } finally {
      if (mounted) {
        setState(() {
          salvando = false;
        });
      }
    }
  }

  // ----------------------------------------------------------
  // LIMPAR FORMULÁRIO
  // ----------------------------------------------------------

  void limparFormulario() {
    nomeController.clear();
    quantidadeController.clear();
    horarioController.clear();
    motivoController.clear();

    setState(() {
      diasSelecionados.clear();
      tomou = false;
    });
  }

  // ----------------------------------------------------------
  // MENSAGEM
  // ----------------------------------------------------------

  void mostrarMensagem(String mensagem) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensagem),
      ),
    );
  }

  // ----------------------------------------------------------
  // INTERFACE
  // ----------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Cadastrar Remédio",
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.stretch,

          children: [

            // ------------------------------------------------
            // NOME
            // ------------------------------------------------

            TextField(
              controller: nomeController,

              decoration: InputDecoration(
                labelText: "Nome do Remédio",
                hintText: "Ex.: Dipirona",
                prefixIcon: const Icon(
                  Icons.medication,
                ),

                border: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 18),

            // ------------------------------------------------
            // QUANTIDADE
            // ------------------------------------------------

            TextField(
              controller: quantidadeController,

              keyboardType:
                  TextInputType.number,

              decoration: InputDecoration(
                labelText: "Quantidade",
                hintText: "Ex.: 2",

                prefixIcon: const Icon(
                  Icons.numbers,
                ),

                border: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 18),

            // ------------------------------------------------
            // HORÁRIO
            // ------------------------------------------------

            TextField(
              controller: horarioController,

              readOnly: true,

              onTap: selecionarHorario,

              decoration: InputDecoration(
                labelText: "Horário",

                hintText: "00:00",

                prefixIcon: const Icon(
                  Icons.access_time,
                ),

                suffixIcon: const Icon(
                  Icons.schedule,
                ),

                border: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 18),

            // ------------------------------------------------
            // MOTIVO
            // ------------------------------------------------

            TextField(
              controller: motivoController,

              maxLines: 3,

              decoration: InputDecoration(
                labelText: "Motivo",

                hintText:
                    "Ex.: Dor de cabeça",

                prefixIcon: const Padding(
                  padding: EdgeInsets.only(
                    bottom: 45,
                  ),
                  child: Icon(
                    Icons.notes,
                  ),
                ),

                border: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 25),

            // ------------------------------------------------
            // DIAS
            // ------------------------------------------------

            const Text(
              "Dias da semana",

              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            ...diasSemana.map(
              (dia) {
                return CheckboxListTile(
                  title: Text(dia),

                  value:
                      diasSelecionados.contains(dia),

                  activeColor:
                      Colors.teal,

                  contentPadding:
                      EdgeInsets.zero,

                  onChanged: (valor) {
                    setState(() {
                      if (valor == true) {
                        diasSelecionados.add(
                          dia,
                        );
                      } else {
                        diasSelecionados.remove(
                          dia,
                        );
                      }
                    });
                  },
                );
              },
            ),

            const SizedBox(height: 10),

            // ------------------------------------------------
            // TOMOU
            // ------------------------------------------------

            SwitchListTile(
              title: const Text(
                "Já tomou este remédio?",
              ),

              value: tomou,

              activeColor:
                  Colors.teal,

              contentPadding:
                  EdgeInsets.zero,

              onChanged: (valor) {
                setState(() {
                  tomou = valor;
                });
              },
            ),

            const SizedBox(height: 25),

            // ------------------------------------------------
            // BOTÃO SALVAR
            // ------------------------------------------------

            SizedBox(
              height: 55,

              child: ElevatedButton(
                onPressed:
                    salvando
                        ? null
                        : salvarRemedio,

                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      Colors.black,

                  foregroundColor:
                      Colors.white,

                  shape:
                      RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(12),
                  ),
                ),

                child: salvando
                    ? const SizedBox(
                        width: 24,
                        height: 24,

                        child:
                            CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text(
                        "SALVAR REMÉDIO",

                        style: TextStyle(
                          fontSize: 16,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}