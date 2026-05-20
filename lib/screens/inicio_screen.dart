import 'package:flutter/material.dart';

class InicioScreen extends StatefulWidget {

  @override
  State<InicioScreen> createState() => _InicioScreenState();
}

class _InicioScreenState extends State<InicioScreen> {

  TextEditingController nomeController = TextEditingController();

  TextEditingController quantidadeController = TextEditingController();
  TextEditingController horarioController =  TextEditingController();
  TextEditingController motivoController = TextEditingController();
  List<String> diasSemana = ['Seg','Ter','Qua','Qui','Sex', 'Sáb','Dom',];
  List<bool> diasSelecionados = [false, false, false, false, false, false, false, ];

  void salvarRemedio() {
    Map<String, dynamic> remedio = {

      'nome': nomeController.text,
      'quantidade': quantidadeController.text,
      'horario': horarioController.text,
      'motivo': motivoController.text,
      'dias': List.from(diasSelecionados),
      'tomou': false,
    };

//navegação
    Navigator.pushNamed(context, '/detalhes', arguments: remedio,
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor:Color.fromARGB(255, 235, 245, 245),

      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 0, 90, 110),
        title: Text('MedLife'),
      ),

      drawer: Drawer(

        child: Column(children: [

            SizedBox(height: 50),
            Icon(Icons.medication,
              size: 85,
              color: Colors.teal,
            ),

            SizedBox(height: 15),

            ListTile(
              leading: Icon(Icons.home),
              title: Text('Início'),

              onTap: () {Navigator.pushNamed(context, '/');
              },
            ),

            Divider(),

            ListTile(

              leading: Icon(Icons.login),

              title: Text('Login'),

              onTap: () {Navigator.pushNamed(context,'/login');
              },
            ),
          ],
        ),
      ),
//layout
      body: Center(

        child: Container(

          width: 430,
          padding: EdgeInsets.all(22),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius:
              BorderRadius.circular(20),
            boxShadow: [BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              ),
            ],
          ),

          child: Column(

            mainAxisSize: MainAxisSize.min,

            children: [Icon(Icons.medication,

                size: 85,
                color:Color.fromARGB(255, 0, 110, 100),
              ),

              SizedBox(height: 10),

              Text('MedLife',

                style: TextStyle(
                  fontSize: 32,
                  fontWeight:FontWeight.bold,
                ),
              ),

              SizedBox(height: 22),
//input
              TextField(controller: nomeController,

                decoration:InputDecoration(
                  border:OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),

                  labelText:'Nome do Remédio',
                ),
              ),

              SizedBox(height: 14),
//input
              TextField(controller : quantidadeController,

                decoration:InputDecoration(
                  border:OutlineInputBorder(
                    borderRadius:BorderRadius.circular(15),
                  ),

                  labelText:'Quantidade',
                ),
              ),

              SizedBox(height: 14),
//input
              TextField(

                controller:horarioController,

                decoration:InputDecoration(

                border:OutlineInputBorder(
                  borderRadius:BorderRadius.circular(15),
                  ),

                  labelText:'Horário (00:00)',
                ),
              ),

              SizedBox(height: 14),
//input
              TextField(

                controller:motivoController,

                decoration:InputDecoration(
                  border:OutlineInputBorder(
                    borderRadius:BorderRadius.circular(15),
                  ),

                  labelText:'Motivo do uso',
                ),
              ),
//layout
              SizedBox(height: 18),

              Text('Dias da Semana',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight:FontWeight.bold,
                ),
              ),
//layout
              Wrap(spacing: 8,

                children: List.generate( diasSemana.length,(index) {

                    return Column(

                      children: [

                        Text(diasSemana[index]),

                        Checkbox(value:diasSelecionados[index],

                          onChanged:(value) {setState(() {
                              diasSelecionados[index] = value!;
                            });
                          },
                        ),
                      ],
                    );
                  },
                ),
              ),
//layout
              SizedBox(height: 20),

              SizedBox(

                width: double.infinity,

                child: ElevatedButton(

                  style:ElevatedButton.styleFrom(
                    backgroundColor:Colors.black,
                  ),

                  onPressed:salvarRemedio,

                  child: Text('Salvar Remédio',

                    style: TextStyle(
                        color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}