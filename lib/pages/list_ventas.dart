import 'dart:convert';

import 'package:api_sales_data/environment/environment.dart';
import 'package:api_sales_data/model/report.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

class ListVentas extends StatefulWidget {
  const ListVentas({super.key});

  @override
  State<ListVentas> createState() => _ListVentasState();
}

class _ListVentasState extends State<ListVentas> {
  late Future<List<Report>> listSale;

  Report? selectedReport;

  Future<List<Report>> getSales() async {
    final response = await http.get(Uri.parse(apiUri('reuest/chart')));

    if (response.statusCode == 200) {
      List<dynamic> jsonData = jsonDecode(response.body);

      List<Report> list = jsonData.map((e) => Report.fromJson(e)).toList();
      return list;
    } else {
      throw Exception('Failed request');
    }
  }

  @override
  void initState() {
    super.initState();

    listSale = getSales();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.errorContainer,
        title: const Text("REPORTE VENTAS"),
      ),
      body: FutureBuilder(
        future: listSale,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Report> data = snapshot.data ?? [];
            return ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        child: ListTile(
                          onTap: () {
                            setState(() {
                              selectedReport = data[index];
                            });
                            _showMyDialog();
                          },
                          title: Text(
                            data[index].concecionario.toUpperCase(),
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(data[index].total),
                          trailing: const Icon(Icons.arrow_forward_ios),
                        ),
                      ),
                    ),
                    const Divider(height: 0),
                  ],
                );
              },
            );
          } else if (snapshot.hasError) {
            return const Text('Err');
          }

          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Información',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('CONCESIONARIO: ${selectedReport?.concecionario ?? ''}'),
                Text('Total: ${selectedReport?.total ?? ''}'),
                Text('COMPLETO: ${selectedReport?.completo ?? ''}'),
                Text('INCOMPLETO: ${selectedReport?.incompleto ?? ''}')
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Aceptar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
