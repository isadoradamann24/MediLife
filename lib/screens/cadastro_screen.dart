import 'package:flutter/material.dart';

import '../models/remedio.dart';
import '../database/database.dart';


class CadastroScreen extends StatefulWidget {
  const CadastroScreen({super.key});

  @override
  State<CadastroScreen> createState() =>
      _CadastroScreenState();
}


class _CadastroScreenState
    extends State<CadastroScreen> {


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



  // SELECIONAR HORÁRIO

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





  // SALVAR REMÉDIO

  Future<void> salvarRemedio() async {


    if (salvando) return;



    if (nomeController.text.trim().isEmpty) {

      mostrarMensagem(
        "Digite o nome do remédio.",
      );

      return;

    }



    if (quantidadeController.text.trim().isEmpty) {

      mostrarMensagem(
        "Digite a quantidade.",
      );

      return;

    }



    if (horarioController.text.trim().isEmpty) {

      mostrarMensagem(
        "Selecione o horário.",
      );

      return;

    }



    if (diasSelecionados.isEmpty) {

      mostrarMensagem(
        "Selecione pelo menos um dia.",
      );

      return;

    }



    final int? quantidade =

        int.tryParse(
          quantidadeController.text.trim(),
        );



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


      final String dias =

          diasSelecionados.join(", ");



      Remedio remedio = Remedio(

        nome: nomeController.text.trim(),

        quantidade: quantidade,

        horario: horarioController.text.trim(),

        motivo: motivoController.text.trim(),

        dias: dias,

        tomou: tomou ? 1 : 0,

      );



      DatabaseHandler handler =
          DatabaseHandler();



      await handler.inserirRemedio(
        remedio,
      );



      if (!mounted) return;



      mostrarMensagem(
        "Remédio cadastrado com sucesso!",
      );



      limparFormulario();



      Navigator.pop(
        context,
        true,
      );



    } catch (erro) {


      debugPrint(
        "Erro ao salvar remédio: $erro",
      );


      mostrarMensagem(
        "Erro ao salvar o remédio.",
      );


    } finally {


      if (mounted) {

        setState(() {

          salvando = false;

        });

      }

    }


  }






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





  void mostrarMensagem(String mensagem) {


    ScaffoldMessenger.of(context)
        .showSnackBar(

      SnackBar(

        content: Text(mensagem),

      ),

    );


  }







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



            TextField(

              controller: nomeController,


              decoration: InputDecoration(

                labelText:
                    "Nome do Remédio",

                hintText:
                    "Ex.: Dipirona",


                prefixIcon:
                    const Icon(
                      Icons.medication,
                    ),


                border:
                    OutlineInputBorder(

                  borderRadius:
                      BorderRadius.circular(12),

                ),

              ),

            ),



            const SizedBox(height: 18),




            TextField(

              controller:
                  quantidadeController,


              keyboardType:
                  TextInputType.number,


              decoration:
                  InputDecoration(

                labelText:
                    "Quantidade",


                hintText:
                    "Ex.: 2",


                prefixIcon:
                    const Icon(
                      Icons.numbers,
                    ),


                border:
                    OutlineInputBorder(

                  borderRadius:
                      BorderRadius.circular(12),

                ),

              ),

            ),





            const SizedBox(height: 18),




            TextField(

              controller:
                  horarioController,


              readOnly: true,


              onTap:
                  selecionarHorario,


              decoration:
                  InputDecoration(

                labelText:
                    "Horário",


                hintText:
                    "00:00",


                prefixIcon:
                    const Icon(
                      Icons.access_time,
                    ),


                border:
                    OutlineInputBorder(

                  borderRadius:
                      BorderRadius.circular(12),

                ),

              ),

            ),




            const SizedBox(height: 18),




            TextField(

              controller:
                  motivoController,


              maxLines: 3,


              decoration:
                  InputDecoration(

                labelText:
                    "Motivo",


                hintText:
                    "Ex.: Dor de cabeça",


                border:
                    OutlineInputBorder(

                  borderRadius:
                      BorderRadius.circular(12),

                ),

              ),

            ),




            const SizedBox(height: 25),





            const Text(

              "Dias da semana",

              style:
                  TextStyle(

                fontSize: 18,

                fontWeight:
                    FontWeight.bold,

              ),

            ),




            ...diasSemana.map(

              (dia) {


                return CheckboxListTile(

                  title:
                      Text(dia),


                  value:
                      diasSelecionados.contains(dia),



                  onChanged:
                      (valor) {


                    setState(() {


                      if (valor == true) {

                        diasSelecionados.add(dia);


                      } else {

                        diasSelecionados.remove(dia);

                      }


                    });


                  },


                );


              },

            ),





            SwitchListTile(

              title:
                  const Text(
                    "Já tomou este remédio?",
                  ),


              value:
                  tomou,


              onChanged:
                  (valor) {


                setState(() {

                  tomou = valor;

                });


              },


            ),





            const SizedBox(height: 25),




            SizedBox(

              height: 55,


              child:
                  ElevatedButton(


                onPressed:
                    salvando
                        ? null
                        : salvarRemedio,



                style:
                    ElevatedButton.styleFrom(

                  backgroundColor:
                      Colors.black,

                  foregroundColor:
                      Colors.white,


                ),



                child:
                    salvando

                        ? const CircularProgressIndicator(
                            color: Colors.white,
                          )

                        : const Text(
                            "SALVAR REMÉDIO",
                            style:
                                TextStyle(
                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),


              ),

            ),



          ],


        ),


      ),


    );


  }


}