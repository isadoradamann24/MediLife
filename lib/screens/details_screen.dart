import 'package:flutter/material.dart';

class DetailsScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: Text('Detalhes'),
        backgroundColor: Colors.purple,
      ),

      body: Center(

        child: Column(

          mainAxisAlignment: MainAxisAlignment.center,

          children: [

            Icon(
              Icons.medication,
              size: 100,
              color: Colors.purple,
            ),

            SizedBox(height: 20),

            Text(
              'Tela de detalhes do remédio',
              style: TextStyle(fontSize: 22),
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
    );
  }
}