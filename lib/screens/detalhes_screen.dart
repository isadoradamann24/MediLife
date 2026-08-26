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


  List<Remedio> remedios = [];

  bool carregando = true;




  @override
  void initState() {

    super.initState();

    carregarRemedios();

  }





  Future<void> carregarRemedios() async {


    try {


      DatabaseHandler handler =
          DatabaseHandler();



      final resultado =
          await handler.retrieveRemedios();



      if(!mounted) return;



      setState(() {

        remedios = resultado;

        carregando = false;

      });



    } catch(e){


      debugPrint(
        "Erro ao carregar remédios: $e",
      );


      setState(() {

        carregando = false;

      });


    }


  }







  Future<void> excluirRemedio(int id) async {


    DatabaseHandler handler =
        DatabaseHandler();



    await handler.deleteRemedio(id);



    carregarRemedios();


  }








  @override
  Widget build(BuildContext context) {


    return Scaffold(



      appBar: AppBar(


        title:
            const Text(
              "Meus Remédios",
            ),


        backgroundColor:
            const Color.fromARGB(
              255,
              0,
              90,
              110,
            ),


      ),





      body:


      carregando


      ? const Center(

          child:
              CircularProgressIndicator(),

        )



      : remedios.isEmpty



      ? const Center(

          child:
              Column(

            mainAxisAlignment:
                MainAxisAlignment.center,


            children: [


              Icon(

                Icons.medication_outlined,

                size: 80,

                color: Colors.grey,

              ),



              SizedBox(
                height: 15,
              ),



              Text(

                "Nenhum remédio cadastrado.",

                style:
                    TextStyle(

                  fontSize: 18,

                ),

              ),


            ],


          ),


        )




      : RefreshIndicator(


          onRefresh:
              carregarRemedios,



          child:
              ListView.builder(


            padding:
                const EdgeInsets.all(16),



            itemCount:
                remedios.length,



            itemBuilder:
                (context,index){



              final remedio =
                  remedios[index];





              return Card(


                elevation:
                    5,


                margin:
                    const EdgeInsets.only(
                      bottom: 15,
                    ),



                shape:
                    RoundedRectangleBorder(

                  borderRadius:
                      BorderRadius.circular(15),

                ),





                child:
                    ListTile(



                  leading:
                      CircleAvatar(


                    backgroundColor:
                        Colors.teal,


                    child:
                        const Icon(

                      Icons.medication,

                      color:
                          Colors.white,

                    ),


                  ),





                  title:
                      Text(


                    remedio.nome,


                    style:
                        const TextStyle(

                      fontWeight:
                          FontWeight.bold,

                      fontSize:
                          18,

                    ),


                  ),






                  subtitle:
                      Column(


                    crossAxisAlignment:
                        CrossAxisAlignment.start,


                    children: [



                      const SizedBox(
                        height: 5,
                      ),




                      Text(

                        "Quantidade: ${remedio.quantidade}",

                      ),




                      Text(

                        "Horário: ${remedio.horario}",

                      ),





                      Text(

                        remedio.tomou == 1

                        ? "Status: Tomado ✅"

                        : "Status: Pendente ⏰",

                      ),




                    ],


                  ),






                  trailing:
                      PopupMenuButton(



                    itemBuilder:
                        (context)=>[



                      const PopupMenuItem(

                        value:
                            "detalhes",

                        child:
                            Text(
                              "Detalhes",
                            ),

                      ),




                      const PopupMenuItem(

                        value:
                            "excluir",

                        child:
                            Text(
                              "Excluir",
                            ),

                      ),



                    ],




                    onSelected:
                        (valor){



                      if(valor == "detalhes"){



                        Navigator.pushNamed(

                          context,

                          "/detalhes",

                          arguments:
                              remedio,

                        );



                      }




                      if(valor == "excluir"){



                        if(remedio.id != null){


                          excluirRemedio(
                            remedio.id!,
                          );


                        }


                      }



                    },


                  ),




                  onTap: () async {



                    final resultado =
                        await Navigator.pushNamed(


                      context,

                      "/detalhes",

                      arguments:
                          remedio,


                    );




                    if(resultado == true){


                      carregarRemedios();


                    }



                  },



                ),


              );



            },


          ),


        ),




    );


  }



}