import 'package:flutter/material.dart';

class DetailsScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    final remedio = ModalRoute.of(context)!
        .settings
        .arguments as Map<String, dynamic>;

    List<String> diasSemana = [

      'Segunda',

      'Terça',

      'Quarta',

      'Quinta',

      'Sexta',

      'Sábado',

      'Domingo',
    ];

    return Scaffold(

      appBar: AppBar(

        title: Text('Detalhes do Remédio'),
      ),

      body: Center(

        child: SingleChildScrollView(

          child: Padding(

            padding: EdgeInsets.all(25),

            child: Column(

              mainAxisAlignment:
                  MainAxisAlignment.center,

              children: [

                Icon(
                  Icons.medication,
                  size: 100,
                  color: Colors.purple,
                ),

                SizedBox(height: 20),

                Text(

                  remedio['nome'],

                  style: TextStyle(

                    fontSize: 30,

                    fontWeight: FontWeight.bold,
                  ),
                ),

                SizedBox(height: 20),

                Card(

                  elevation: 5,

                  child: Padding(

                    padding: EdgeInsets.all(20),

                    child: Column(

                      children: [

                        Text(

                          'Quantidade: ${remedio['quantidade']}',

                          style: TextStyle(fontSize: 20),
                        ),

                        SizedBox(height: 10),

                        Text(

                          'Horário 1: ${remedio['horario1']}',

                          style: TextStyle(fontSize: 20),
                        ),

                        SizedBox(height: 10),

                        remedio['horario2'] != ''

                            ? Text(

                                'Horário 2: ${remedio['horario2']}',

                                style: TextStyle(fontSize: 20),
                              )

                            : Container(),

                        SizedBox(height: 10),

                        remedio['horario3'] != ''

                            ? Text(

                                'Horário 3: ${remedio['horario3']}',

                                style: TextStyle(fontSize: 20),
                              )

                            : Container(),

                        SizedBox(height: 10),

                        remedio['motivo'] != ''

                            ? Text(

                                'Motivo: ${remedio['motivo']}',

                                style: TextStyle(fontSize: 20),
                              )

                            : Container(),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 25),

                Text(

                  'Dias da Semana',

                  style: TextStyle(

                    fontSize: 24,

                    fontWeight: FontWeight.bold,
                  ),
                ),

                SizedBox(height: 15),

                Column(

                  children: List.generate(

                    diasSemana.length,

                    (index) {

                      return Padding(

                        padding:
                            EdgeInsets.only(bottom: 10),

                        child: Row(

                          mainAxisAlignment:
                              MainAxisAlignment.center,

                          children: [

                            Icon(

                              remedio['dias'][index]

                                  ? Icons.check_circle

                                  : Icons.cancel,

                              color:

                                  remedio['dias'][index]

                                      ? Colors.green

                                      : Colors.red,
                            ),

                            SizedBox(width: 10),

                            Text(

                              diasSemana[index],

                              style: TextStyle(
                                fontSize: 20,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),

                SizedBox(height: 30),

                Text(

                  remedio['tomou']

                      ? 'Remédio já tomado'

                      : 'Remédio ainda não tomado',

                  style: TextStyle(

                    fontSize: 22,

                    fontWeight: FontWeight.bold,

                    color:

                        remedio['tomou']

                            ? Colors.green

                            : Colors.red,
                  ),
                ),

                SizedBox(height: 30),

                ElevatedButton(

                  onPressed: () {

                    Navigator.pop(context);
                  },

                  child: Text('Voltar'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}