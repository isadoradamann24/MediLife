import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  TextEditingController nomeController = TextEditingController();

  TextEditingController quantidadeController = TextEditingController();

  TextEditingController horarioController = TextEditingController();

  List<Map<String, dynamic>> remedios = [];

  void salvarRemedio() {

    if (nomeController.text.isEmpty ||
        quantidadeController.text.isEmpty ||
        horarioController.text.isEmpty) {

      return;
    }

    setState(() {

      remedios.add({

        'nome': nomeController.text,

        'quantidade': quantidadeController.text,

        'horario': horarioController.text,

        'tomou': false,
      });
    });

    nomeController.clear();
    quantidadeController.clear();
    horarioController.clear();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: Color(0xfff5f5f5),

      appBar: AppBar(

        title: Text(
          'MedLife',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 28,
          ),
        ),

        centerTitle: true,

        backgroundColor: Colors.purple,

        elevation: 0,
      ),

      body: Padding(

        padding: EdgeInsets.all(20),

        child: Column(

          children: [

            Container(

              padding: EdgeInsets.all(20),

              decoration: BoxDecoration(

                color: Colors.white,

                borderRadius: BorderRadius.circular(20),

                boxShadow: [

                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                  ),
                ],
              ),

              child: Column(

                children: [

                  TextField(

                    controller: nomeController,

                    decoration: InputDecoration(

                      labelText: 'Nome do Remédio',

                      prefixIcon: Icon(Icons.medication),

                      border: OutlineInputBorder(

                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),

                  SizedBox(height: 15),

                  Row(

                    children: [

                      Expanded(

                        child: TextField(

                          controller: quantidadeController,

                          decoration: InputDecoration(

                            labelText: 'Quantidade',

                            prefixIcon: Icon(Icons.numbers),

                            border: OutlineInputBorder(

                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                        ),
                      ),

                      SizedBox(width: 10),

                      Expanded(

                        child: TextField(

                          controller: horarioController,

                          decoration: InputDecoration(

                            labelText: 'Horário',

                            prefixIcon: Icon(Icons.access_time),

                            border: OutlineInputBorder(

                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 20),

                  SizedBox(

                    width: double.infinity,

                    height: 50,

                    child: ElevatedButton(

                      onPressed: salvarRemedio,

                      style: ElevatedButton.styleFrom(

                        backgroundColor: Colors.purple,

                        shape: RoundedRectangleBorder(

                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),

                      child: Text(

                        'Salvar Remédio',

                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 20),

            Align(

              alignment: Alignment.centerLeft,

              child: Text(

                'Meus Remédios',

                style: TextStyle(

                  fontSize: 24,

                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            SizedBox(height: 10),

            Expanded(

              child: remedios.isEmpty

                  ? Center(

                      child: Text(

                        'Nenhum remédio cadastrado',

                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey,
                        ),
                      ),
                    )

                  : ListView.builder(

                      itemCount: remedios.length,

                      itemBuilder: (context, index) {

                        return Container(

                          margin: EdgeInsets.only(bottom: 15),

                          decoration: BoxDecoration(

                            color: Colors.white,

                            borderRadius: BorderRadius.circular(20),

                            boxShadow: [

                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 5,
                              ),
                            ],
                          ),

                          child: ListTile(

                            contentPadding: EdgeInsets.all(15),

                            leading: CircleAvatar(

                              backgroundColor: Colors.purple,

                              child: Icon(
                                Icons.medication,
                                color: Colors.white,
                              ),
                            ),

                            title: Text(

                              remedios[index]['nome'],

                              style: TextStyle(

                                fontSize: 20,

                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            subtitle: Padding(

                              padding: EdgeInsets.only(top: 8),

                              child: Column(

                                crossAxisAlignment:
                                    CrossAxisAlignment.start,

                                children: [

                                  Text(
                                    'Quantidade: ${remedios[index]['quantidade']}',
                                  ),

                                  Text(
                                    'Horário: ${remedios[index]['horario']}',
                                  ),
                                ],
                              ),
                            ),

                            trailing: Checkbox(

                              value: remedios[index]['tomou'],

                              activeColor: Colors.green,

                              onChanged: (value) {

                                setState(() {

                                  remedios[index]['tomou'] = value;
                                });
                              },
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