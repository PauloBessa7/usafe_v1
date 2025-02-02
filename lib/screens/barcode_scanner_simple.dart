import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:http/http.dart' as http;

import '_showPopup.dart';

class BarcodeScannerSimple extends StatefulWidget {
  const BarcodeScannerSimple({super.key});

  @override
  State<BarcodeScannerSimple> createState() => _BarcodeScannerSimpleState();
}

class _BarcodeScannerSimpleState extends State<BarcodeScannerSimple> {
  Barcode? _barcode;
  bool _isProcessing = false; // Variável para evitar leituras múltiplas

  void _handleBarcode(BarcodeCapture barcodes) {
    if (_isProcessing || barcodes.barcodes.isEmpty) return;

    setState(() {
      _barcode = barcodes.barcodes.firstOrNull;
      _isProcessing = true; // Impede leituras consecutivas
    });

    String? displayBarCode = barcodes.barcodes.firstOrNull?.displayValue;

    if (displayBarCode != null) {
      showPopup(context, displayBarCode).then((_) {
        Future.delayed(Duration(seconds: 2), () {
          setState(() {
            _isProcessing = false; // Libera para nova leitura após 2 segundos
          });
        });
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Simple scanner')),
      body: Stack(
        children: [
          MobileScanner(
            onDetect: _handleBarcode,
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              height: 100,
              child: Center(
                  child: Column(
                children: [
                  Text(
                    _barcode?.displayValue ?? 'Scan something',
                    style: TextStyle(color: Colors.white),
                  ),
                  // ElevatedButton(
                  //     onPressed: () {
                  //       // Criação do BarcodeCapture antes da chamada da função
                  //       BarcodeCapture fakeBarcodeCapture = BarcodeCapture(
                  //         barcodes: [Barcode()],
                  //         raw: "raw-data",
                  //         size: Size(300, 300), // Dimensões fictícias
                  //       );
                  //       _showPopup(context, '7891234567895');
                  //     },
                  //     child: Text('Open Popup')
                  // )
                ],
              )),
            ),
          ),
        ],
      ),
    );
  }
}


Future<Map<String, dynamic>> getProductAPI(String? value) async {
  await Future.delayed(const Duration(seconds: 3));
  final url = 'http://192.168.0.153:3000/products/$value'; // Ajuste para buscar o produto pelo ID
  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    final data = json.decode(response.body);

    // Verifique se a resposta é um mapa (objeto JSON)
    if (data is Map<String, dynamic>) {
      return data; // Retorna o objeto de dados
    } else {
      throw Exception('A resposta não é um objeto válido.');
    }
  } else {
    throw Exception('Erro ao carregar os produtos: ${response.statusCode}');
  }
}



