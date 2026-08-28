import 'package:flutter/material.dart';

import '../models/remedio.dart';
import '../database/database.dart';


class CadastroScreen extends StatefulWidget {

  const CadastroScreen({super.key});


  @override
  State<CadastroScreen> createState() =>
      _CadastroScreenState();

}



class _CadastroScreenState extends State<CadastroScreen> {


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
  void dispose(){

    nomeController.dispose();
    quantidadeController.dispose();
    horarioController.dispose();
    motivoController.dispose();

    super.dispose();

  }





  Future<void> selecionarHorario() async {


    TimeOfDay? horario =
        await showTimePicker(

      context: context,

      initialTime:
          TimeOfDay.now(),

    );



    if(horario != null){

      setState((){

        horarioController.text =
            horario.format(context);

      });

    }


  }







  Future<void> salvarRemedio() async {


    if(salvando) return;



    if(nomeController.text.trim().isEmpty){

      mensagem(
        "Digite o nome do remédio",
      );

      return;

    }



    if(quantidadeController.text.trim().isEmpty){

      mensagem(
        "Digite a quantidade",
      );

      return;

    }



    if(horarioController.text.trim().isEmpty){

      mensagem(
        "Selecione o horário",
      );

      return;

    }



    if(diasSelecionados.isEmpty){

      mensagem(
        "Selecione os dias",
      );

      return;

    }





    int? quantidade =
        int.tryParse(
          quantidadeController.text,
        );



    if(quantidade == null){

      mensagem(
        "Quantidade inválida",
      );

      return;

    }





    setState((){

      salvando = true;

    });





    try{


      Remedio remedio = Remedio(

        nome:
            nomeController.text.trim(),


        quantidade:
            quantidade,


        horario:
            horarioController.text,


        motivo:
            motivoController.text,


        dias:
            diasSelecionados.join(", "),


        tomou:
            tomou ? 1 : 0,


      );




      DatabaseHandler banco =
          DatabaseHandler();




      await banco.insertRemedio(
        remedio,
      );





      if(!mounted) return;




      mensagem(
        "Remédio salvo!",
      );



      Navigator.pop(
        context,
        true,
      );




    }catch(e){


      mensagem(
        "Erro ao salvar: $e",
      );


    }finally{


      if(mounted){

        setState((){

          salvando = false;

        });

      }


    }


  }







  void mensagem(String texto){


    ScaffoldMessenger.of(context)
        .showSnackBar(

      SnackBar(

        content:
            Text(texto),

      ),

    );


  }








  @override
  Widget build(BuildContext context) {


    return Scaffold(


      appBar: AppBar(

        title:
            const Text(
              "Cadastrar Remédio",
            ),

      ),



      body:
      SingleChildScrollView(


        padding:
            const EdgeInsets.all(20),



        child:
        Column(


          children: [




            TextField(

              controller:
                  nomeController,


              decoration:
              campo(
                "Nome do Remédio",
                Icons.medication,
              ),

            ),




            const SizedBox(height:20),





            TextField(

              controller:
                  quantidadeController,


              keyboardType:
                  TextInputType.number,


              decoration:
              campo(
                "Quantidade",
                Icons.numbers,
              ),

            ),





            const SizedBox(height:20),




            TextField(

              controller:
                  horarioController,


              readOnly:
                  true,


              onTap:
                  selecionarHorario,


              decoration:
              campo(
                "Horário",
                Icons.access_time,
              ),

            ),





            const SizedBox(height:20),




            TextField(

              controller:
                  motivoController,


              maxLines:
                  3,


              decoration:
              campo(
                "Motivo",
                Icons.note,
              ),

            ),





            const SizedBox(height:20),




            const Text(

              "Dias da semana",

              style:
              TextStyle(
                fontSize:18,
                fontWeight:FontWeight.bold,
              ),

            ),





            ...diasSemana.map(

              (dia)=>CheckboxListTile(

                title:
                    Text(dia),


                value:
                    diasSelecionados.contains(dia),


                onChanged:
                (valor){

                  setState((){

                    if(valor == true){

                      diasSelecionados.add(dia);

                    }else{

                      diasSelecionados.remove(dia);

                    }


                  });


                },


              ),

            ),






            SwitchListTile(

              title:
              const Text(
                "Já tomou?",
              ),


              value:
                  tomou,


              onChanged:
              (valor){

                setState((){

                  tomou = valor;

                });


              },


            ),







            const SizedBox(height:20),





            SizedBox(

              width:
                  double.infinity,


              height:
                  55,


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

                ?
                const CircularProgressIndicator(
                  color: Colors.white,
                )


                :

                const Text(
                  "SALVAR REMÉDIO",
                ),


              ),


            )




          ],


        ),


      ),


    );


  }





  InputDecoration campo(
      String texto,
      IconData icone
      ){

    return InputDecoration(

      labelText:
          texto,

      prefixIcon:
          Icon(icone),

      border:
      OutlineInputBorder(

        borderRadius:
        BorderRadius.circular(12),

      ),

    );

  }


}