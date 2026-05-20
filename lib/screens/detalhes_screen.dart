import 'package:flutter/material.dart';

class DetalhesScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    final remedio = ModalRoute.of(context)!
        .settings
        .arguments
        as Map<String, dynamic>;

    List<String> diasSemana = ['Segunda', 'Terça', 'Quarta', 'Quinta', 'Sexta', 'Sábado', 'Domingo', ];

    return Scaffold(
      backgroundColor:Color.fromARGB(255, 235, 245, 245),

      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 0, 90, 110),
        title: Text('Detalhes do Remédio'),
      ),
//layout
      body: Center(child: Padding(
        padding: EdgeInsets.all(25),
//layout
          child: Column(mainAxisAlignment:MainAxisAlignment.center,

            children: [Icon(Icons.medication,
              size: 100,
              color:Color.fromARGB(255, 0, 100, 120),
              ),
//layout
              SizedBox(height: 20),

              Text(remedio['nome'],

                style: TextStyle(
                  fontSize: 32,
                  fontWeight:FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),

              Text('Quantidade: ${remedio['quantidade']}'),
              SizedBox(height: 10),

              Text('Horário: ${remedio['horario']}'),
              SizedBox(height: 10),

              Text('Motivo: ${remedio['motivo']}'),
              SizedBox(height: 20),

              Column(children: List.generate(diasSemana.length,(index) {
//layout
                    return Row(mainAxisAlignment:MainAxisAlignment.center,

                      children: [Icon(remedio['dias'][index] ? Icons.check_circle : Icons.cancel,

                          color: remedio['dias'] [index] ? Colors.green : Colors.red,
                        ),

                        SizedBox(width: 10),

                        Text(diasSemana[index]),
                      ],
                    );
                  },
                ),
              ),

              SizedBox(height: 20),
//input
              ElevatedButton(

                style:ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                ),

                onPressed: () {Navigator.pop(context);
                },

                child: Text('Voltar',

                  style: TextStyle(
                      color:Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}