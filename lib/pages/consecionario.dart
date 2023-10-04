import 'dart:convert';
import 'package:api_sales_data/model/report.dart';
import 'package:api_sales_data/pages/almacen_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:api_sales_data/environment/environment.dart';

class Consecionario extends StatefulWidget {
  const Consecionario({super.key});

  @override
  State<Consecionario> createState() => _ConsecionarioState();
}

class _ConsecionarioState extends State<Consecionario> {
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
        title: const Text("CONCESIONARIOS"),
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

                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AlmacenP(
                                          cReport: selectedReport!,
                                        )));
                          },
                          title: Text(
                            data[index].concecionario.toUpperCase(),
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
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
}
