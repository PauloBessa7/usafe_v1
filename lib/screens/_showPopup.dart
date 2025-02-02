import 'package:flutter/material.dart';

import 'barcode_scanner_simple.dart';

Future<void> showPopup(BuildContext context, String barcodeValue) async {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return FutureBuilder<Map<String, dynamic>>(
        future: getProductAPI(barcodeValue),
        builder: (context, snapshot) {
          // Define a cor de fundo dinamicamente
          Color? backgroundColor = Colors.grey[200]; // Cor padrão
          if (snapshot.hasData) {
            List ingredients = snapshot.data!['ingredients'];
            if (ingredients.contains('Leite')) {
              backgroundColor = Colors.red[100]!; // Muda para vermelho claro se "Leite" estiver presente
            } else {
              backgroundColor = Colors.blue[100]!; // Outra cor se não tiver "Leite"
            }
          }
          return AlertDialog(
            backgroundColor: backgroundColor, // Cor dinâmica
            title: Text("Scanned Barcode"),
            content: SizedBox(
              height: 300,
              width: 200,
              child: snapshot.connectionState == ConnectionState.waiting
                  ? Center(child: CircularProgressIndicator())
                  : snapshot.hasError
                  ? Center(child: Text('Erro: ${snapshot.error}'))
                  : snapshot.hasData
                  ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Product: ${snapshot.data!['name']}'),
                  Text('Country: ${snapshot.data!['country']}'),
                  Text('Business: ${snapshot.data!['business']}'),
                  Text('ingredients: '),
                  ...snapshot.data!['ingredients'].map<Widget>(
                        (i) => Text(' - $i', style: TextStyle(
                        color: i == 'Leite' ? Colors.pink : Colors.black,
                      ),
                    ),
                  ).toList(),
                  Image.network(snapshot.data!['image'], width: 100, height: 100),
                ],
              )
                  : Center(child: Text('Nenhum dado encontrado.')),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("Close"),
              ),
            ],
          );
        },
      );
    },
  );
}