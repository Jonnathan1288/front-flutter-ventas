import 'dart:convert';
import 'package:api_sales_data/model/almacen.dart';
import 'package:api_sales_data/model/report.dart';
import 'package:api_sales_data/model/venta.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:api_sales_data/environment/environment.dart';

class AlmacenP extends StatefulWidget {
  final Report cReport;
  const AlmacenP({Key? key, required this.cReport}) : super(key: key);

  @override
  State<AlmacenP> createState() => _AlmacenPState();
}

class _AlmacenPState extends State<AlmacenP> {
  late Future<List<Almacen>> listSale;

  Almacen? almacenSelected;
  Report? newReport;

  String cadena = '';

  Future<List<Almacen>> getAlmacenes() async {
    final response = await http
        .get(Uri.parse(apiUri('almacen/${widget.cReport.concecionario}')));

    if (response.statusCode == 200) {
      List<dynamic> jsonData = jsonDecode(response.body);

      List<Almacen> list = jsonData.map((e) => Almacen.fromJson(e)).toList();
      return list;
    } else {
      throw Exception('Failed request');
    }
  }

  Future<void> save(Venta venta) async {
    final url = Uri.parse(apiUri('save'));
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(venta.toJson()),
    );

    if (response.statusCode == 201) {
      print('Save susseful : ${response.body}');
    } else {
      print(response);
      throw Exception('Err: ${response.statusCode}');
    }
  }

  @override
  void initState() {
    super.initState();
    print(widget.cReport.concecionario);

    listSale = getAlmacenes();
    newReport = widget.cReport;

    cadena =
        'CONCECIONARIO: ${newReport!.concecionario} \n ALMACEN: ${almacenSelected?.almacen}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.errorContainer,
        title: const Text("ALMACENES"),
      ),
      body: FutureBuilder(
        future: listSale,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Almacen> data = snapshot.data ?? [];

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
                              almacenSelected = data[index];
                            });

                            _showMyDialog();
                          },
                          title: Text(
                            data[index].almacen.toUpperCase(),
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

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Nueva Venta',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('CONCECIONARIO: ${newReport!.concecionario}'),
                Text('ALMACEN: ${almacenSelected!.almacen}'),
                const Text(
                    'Seleccione  el tipo de venta el cual usted va a realizar de las siguientes opciones en los botones'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Venta'),
              onPressed: () {
                createNewVenta(context, 1);
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Nota de credito'),
              onPressed: () {
                createNewVenta(context, -1);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  createNewVenta(context, int status) {
    String almacen = almacenSelected!.almacen;
    String concecionario = newReport!.concecionario;

    Venta venta = Venta(
        idVenta: 0,
        fecha: DateTime.now(),
        concecionario: concecionario,
        almacen: almacen,
        cantidad: status,
        estadoVenta: 'COMPLETA');

    save(venta);
  }
}
