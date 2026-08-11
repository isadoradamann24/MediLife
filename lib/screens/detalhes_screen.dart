import 'package:flutter/material.dart';

import '../database/database.dart';
import '../models/remedio.dart';

class DetalhesScreen extends StatefulWidget {
  const DetalhesScreen({super.key});

  @override
  State<DetalhesScreen> createState() =>
      _DetalhesScreenState();
}

class _DetalhesScreenState
    extends State<DetalhesScreen> {

  Remedio? remedio;

  bool tomou = false;

  bool carregando = true;

  final List<String> frases = [
    "💚 Ótimo! Você cuidou da sua saúde hoje.",
    "💊 Excelente! Remédio tomado com sucesso.",
    "✨ Mais um dia de cuidado com você mesmo.",
    "❤️ Parabéns! Sua saúde em primeiro lugar.",
  ];

  int fraseAtual = 0;

  // ----------------------------------------------------------
  // RECEBER O REMÉDIO
  // ----------------------------------------------------------

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (remedio != null) {
      return;
    }

    final argumento =
        ModalRoute.of(context)?.settings.arguments;

    if (argumento is Remedio) {
      remedio = argumento;

      tomou = argumento.tomou;

      carregando = false;
    }
  }

  // ----------------------------------------------------------
  // ALTERAR STATUS "TOMOU"
  // ----------------------------------------------------------

  Future<void> alternarTomado(bool valor) async {

    if (remedio == null ||
        remedio!.id == null) {
      return;
    }

    try {

      await DatabaseHelper.instance
          .atualizarRemedio(
        remedio!.id!,
        {
          "tomou": valor ? 1 : 0,
        },
      );

      if (!mounted) return;

      setState(() {
        tomou = valor;

        if (valor) {
          fraseAtual =
              (fraseAtual + 1) %
                  frases.length;
        }
      });

    } catch (erro) {

      debugPrint(
        "Erro ao atualizar status: $erro",
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            "Não foi possível atualizar o status.",
          ),
        ),
      );
    }
  }

  // ----------------------------------------------------------
  // VERIFICAR SE O DIA ESTÁ SELECIONADO
  // ----------------------------------------------------------

  bool diaSelecionado(
    String dias,
    String dia,
  ) {

    final lista = dias
        .split(",")
        .map(
          (item) => item.trim().toLowerCase(),
        )
        .toList();

    return lista.contains(
      dia.toLowerCase(),
    );
  }

  // ----------------------------------------------------------
  // TELA
  // ----------------------------------------------------------

  @override
  Widget build(BuildContext context) {

    if (carregando || remedio == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    final remedioAtual = remedio!;

    return Scaffold(

      backgroundColor:
          const Color.fromARGB(
        255,
        235,
        245,
        245,
      ),

      // ------------------------------------------------------
      // APP BAR
      // ------------------------------------------------------

      appBar: AppBar(
        backgroundColor:
            const Color.fromARGB(
          255,
          0,
          90,
          110,
        ),

        title: const Text(
          "Detalhes do Remédio",
        ),
      ),

      // ------------------------------------------------------
      // BODY
      // ------------------------------------------------------

      body: Center(
        child: SingleChildScrollView(

          padding:
              const EdgeInsets.all(25),

          child: Column(
            children: [

              // ------------------------------------------------
              // ÍCONE
              // ------------------------------------------------

              const Icon(
                Icons.medication,
                size: 100,
              ),

              const SizedBox(
                height: 20,
              ),

              // ------------------------------------------------
              // NOME
              // ------------------------------------------------

              Text(
                remedioAtual.nome,

                textAlign:
                    TextAlign.center,

                style: const TextStyle(
                  fontSize: 28,
                  fontWeight:
                      FontWeight.bold,
                  color: Colors.black,
                ),
              ),

              const SizedBox(
                height: 25,
              ),

              // ------------------------------------------------
              // QUANTIDADE
              // ------------------------------------------------

              Text(
                "Quantidade: "
                "${remedioAtual.quantidade}",

                style:
                    const TextStyle(
                  color: Colors.black,
                ),
              ),

              const SizedBox(
                height: 8,
              ),

              // ------------------------------------------------
              // HORÁRIO
              // ------------------------------------------------

              Text(
                "Horário: "
                "${remedioAtual.horario}",

                style:
                    const TextStyle(
                  color: Colors.black,
                ),
              ),

              const SizedBox(
                height: 8,
              ),

              // ------------------------------------------------
              // MOTIVO
              // ------------------------------------------------

              Text(
                "Motivo: "
                "${remedioAtual.motivo.isEmpty ? "Não informado" : remedioAtual.motivo}",

                textAlign:
                    TextAlign.center,

                style:
                    const TextStyle(
                  color: Colors.black,
                ),
              ),

              const SizedBox(
                height: 25,
              ),

              // ------------------------------------------------
              // DIAS DA SEMANA
              // ------------------------------------------------

              const Text(
                "Dias de uso",

                style: TextStyle(
                  fontSize: 18,
                  fontWeight:
                      FontWeight.bold,
                  color: Colors.black,
                ),
              ),

              const SizedBox(
                height: 12,
              ),

              construirDia(
                "Seg",
                "Segunda",
                remedioAtual.dias,
              ),

              construirDia(
                "Ter",
                "Terça",
                remedioAtual.dias,
              ),

              construirDia(
                "Qua",
                "Quarta",
                remedioAtual.dias,
              ),

              construirDia(
                "Qui",
                "Quinta",
                remedioAtual.dias,
              ),

              construirDia(
                "Sex",
                "Sexta",
                remedioAtual.dias,
              ),

              construirDia(
                "Sáb",
                "Sábado",
                remedioAtual.dias,
              ),

              construirDia(
                "Dom",
                "Domingo",
                remedioAtual.dias,
              ),

              const SizedBox(
                height: 25,
              ),

              // ------------------------------------------------
              // SWITCH
              // ------------------------------------------------

              SwitchListTile(
                title: const Text(
                  "Remédio tomado?",

                  style: TextStyle(
                    color: Colors.black,
                    fontWeight:
                        FontWeight.w600,
                  ),
                ),

                value: tomou,

                activeColor:
                    Colors.green,

                onChanged:
                    alternarTomado,
              ),

              const SizedBox(
                height: 40,
              ),

              // ------------------------------------------------
              // ANIMAÇÃO
              // ------------------------------------------------

              AnimatedSwitcher(

                duration:
                    const Duration(
                  milliseconds: 700,
                ),

                transitionBuilder:
                    (child, animation) {

                  return FadeTransition(
                    opacity: animation,

                    child: ScaleTransition(
                      scale: animation,
                      child: child,
                    ),
                  );
                },

                child: tomou
                    ? Text(
                        frases[
                            fraseAtual],

                        key: ValueKey(
                          frases[
                              fraseAtual],
                        ),

                        textAlign:
                            TextAlign.center,

                        style:
                            const TextStyle(
                          fontSize: 16,
                          fontStyle:
                              FontStyle.italic,
                          color: Colors.teal,
                        ),
                      )
                    : const SizedBox.shrink(),
              ),

              const SizedBox(
                height: 60,
              ),

              // ------------------------------------------------
              // VOLTAR
              // ------------------------------------------------

              ElevatedButton(

                style:
                    ElevatedButton.styleFrom(
                  backgroundColor:
                      Colors.black,
                  foregroundColor:
                      Colors.white,
                ),

                onPressed: () {
                  Navigator.pop(
                    context,
                    true,
                  );
                },

                child: const Text(
                  "Voltar",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ----------------------------------------------------------
  // WIDGET DOS DIAS
  // ----------------------------------------------------------

  Widget construirDia(
    String abreviacao,
    String diaCompleto,
    String dias,
  ) {

    final selecionado =
        diaSelecionado(
      dias,
      diaCompleto,
    );

    return Row(
      mainAxisAlignment:
          MainAxisAlignment.center,

      children: [

        Icon(
          selecionado
              ? Icons.check_circle
              : Icons.cancel,

          color: selecionado
              ? Colors.green
              : Colors.red,
        ),

        const SizedBox(
          width: 10,
        ),

        SizedBox(
          width: 45,

          child: Text(
            abreviacao,

            style:
                const TextStyle(
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
  }
}