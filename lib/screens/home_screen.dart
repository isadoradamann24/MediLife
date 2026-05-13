import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  TextEditingController nomeController =
      TextEditingController();

  TextEditingController quantidadeController =
      TextEditingController();

  TextEditingController horario1Controller =
      TextEditingController();

  TextEditingController horario2Controller =
      TextEditingController();

  TextEditingController horario3Controller =
      TextEditingController();

  TextEditingController motivoController =
      TextEditingController();

  List<Map<String, dynamic>> remedios = [];

  bool mostrarHorario2 = false;

  bool mostrarHorario3 = false;

  List<String> diasSemana = [

    'Seg',

    'Ter',

    'Qua',

    'Qui',

    'Sex',

    'Sáb',

    'Dom',
  ];

  List<bool> diasSelecionados = [

    false,
    false,
    false,
    false,
    false,
    false,
    false,
  ];

  void salvarRemedio() {

    if (nomeController.text.isEmpty ||
        quantidadeController.text.isEmpty ||
        horario1Controller.text.isEmpty) {

      return;
    }

    setState(() {

      remedios.add({

        'nome': nomeController.text,

        'quantidade': quantidadeController.text,

        'horario1': horario1Controller.text,

        'horario2': horario2Controller.text,

        'horario3': horario3Controller.text,

        'motivo': motivoController.text,

        'tomou': false,

        'dias': List.from(diasSelecionados),
      });
    });

    nomeController.clear();

    quantidadeController.clear();

    horario1Controller.clear();

    horario2Controller.clear();

    horario3Controller.clear();

    motivoController.clear();

    setState(() {

      mostrarHorario2 = false;

      mostrarHorario3 = false;

      diasSelecionados = [

        false,
        false,
        false,
        false,
        false,
        false,
        false,
      ];
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(

        title: Text('MedLife'),
      ),

      drawer: Drawer(

        child: Column(

          children: [

            SizedBox(height: 50),

            Icon(
              Icons.medication,
              size: 80,
              color: Colors.purple,
            ),

            SizedBox(height: 10),

            Text(

              "MedLife",

              style: TextStyle(

                fontSize: 30,

                fontWeight: FontWeight.bold,
              ),
            ),

            Divider(),

            ListTile(

              title: Text("Início"),

              onTap: () {

                Navigator.pushNamed(
                  context,
                  '/',
                );
              },
            ),

            Divider(),

            Expanded(

              child: ListView.builder(

                itemCount: remedios.length,

                itemBuilder: (context, index) {

                  return ListTile(

                    title: Text(
                      remedios[index]['nome'],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),

      body: Padding(

        padding: EdgeInsets.all(20),

        child: SingleChildScrollView(

          child: Column(

            children: [

              Center(

                child: Column(

                  children: [

                    Icon(
                      Icons.medication,
                      size: 100,
                      color: Colors.purple,
                    ),

                    SizedBox(height: 10),

                    Text(

                      'MedLife',

                      style: TextStyle(

                        fontSize: 35,

                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    Text(
                      'Controle seus remédios',
                    ),
                  ],
                ),
              ),

              SizedBox(height: 20),

              Card(

                elevation: 5,

                child: Padding(

                  padding: EdgeInsets.all(20),

                  child: Column(

                    children: [

                      TextField(

                        controller: nomeController,

                        decoration: InputDecoration(

                          labelText:
                              'Nome do Remédio',
                        ),
                      ),

                      SizedBox(height: 15),

                      TextField(

                        controller:
                            quantidadeController,

                        decoration: InputDecoration(

                          labelText: 'Quantidade',
                        ),
                      ),

                      SizedBox(height: 15),

                      TextField(

                        controller:
                            motivoController,

                        decoration: InputDecoration(

                          labelText:
                              'Motivo do uso',
                        ),
                      ),

                      SizedBox(height: 15),

                      TextField(

                        controller:
                            horario1Controller,

                        decoration: InputDecoration(

                          labelText:
                              'Horário 1 (00:00)',
                        ),
                      ),

                      SizedBox(height: 15),

                      mostrarHorario2

                          ? TextField(

                              controller:
                                  horario2Controller,

                              decoration:
                                  InputDecoration(

                                labelText:
                                    'Horário 2 (00:00)',
                              ),
                            )

                          : Container(),

                      SizedBox(height: 15),

                      mostrarHorario3

                          ? TextField(

                              controller:
                                  horario3Controller,

                              decoration:
                                  InputDecoration(

                                labelText:
                                    'Horário 3 (00:00)',
                              ),
                            )

                          : Container(),

                      SizedBox(height: 15),

                      ElevatedButton(

                        onPressed: () {

                          setState(() {

                            if (!mostrarHorario2) {

                              mostrarHorario2 = true;
                            }

                            else if (!mostrarHorario3) {

                              mostrarHorario3 = true;
                            }
                          });
                        },

                        child: Text(
                          'Adicionar Horário',
                        ),
                      ),

                      SizedBox(height: 20),

                      Text(

                        'Dias da Semana',

                        style: TextStyle(

                          fontSize: 20,

                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),

                      SizedBox(height: 10),

                      Row(

                        mainAxisAlignment:
                            MainAxisAlignment.spaceAround,

                        children: List.generate(

                          diasSemana.length,

                          (index) {

                            return Column(

                              children: [

                                Text(
                                  diasSemana[index],
                                ),

                                Checkbox(

                                  value:
                                      diasSelecionados[index],

                                  onChanged: (value) {

                                    setState(() {

                                      diasSelecionados[index] =
                                          value!;
                                    });
                                  },
                                ),
                              ],
                            );
                          },
                        ),
                      ),

                      SizedBox(height: 20),

                      ElevatedButton(

                        onPressed: salvarRemedio,

                        child: Text(
                          'Salvar Remédio',
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 20),

              ListView.builder(

                shrinkWrap: true,

                physics:
                    NeverScrollableScrollPhysics(),

                itemCount: remedios.length,

                itemBuilder: (context, index) {

                  return Card(

                    child: ListTile(

                      title: Text(
                        remedios[index]['nome'],
                      ),

                      subtitle: Text(

                        'Motivo: ${remedios[index]['motivo']}',
                      ),

                      trailing: Row(

                        mainAxisSize: MainAxisSize.min,

                        children: [

                          Checkbox(

                            value:
                                remedios[index]['tomou'],

                            onChanged: (value) {

                              setState(() {

                                remedios[index]['tomou'] =
                                    value;
                              });
                            },
                          ),

                          TextButton(

                            onPressed: () {

                              Navigator.pushNamed(

                                context,

                                '/details',

                                arguments:
                                    remedios[index],
                              );
                            },

                            child: Text('Ver Mais'),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}