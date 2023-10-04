class Venta {
  int idVenta;
  DateTime fecha;
  String concecionario;
  String almacen;
  int cantidad;
  String estadoVenta;

  Venta({
    required this.idVenta,
    required this.fecha,
    required this.concecionario,
    required this.almacen,
    required this.cantidad,
    required this.estadoVenta,
  });

  factory Venta.fromJson(Map<String, dynamic> json) => Venta(
        idVenta: json["idVenta"],
        fecha: DateTime.parse(json["fecha"]),
        concecionario: json["concecionario"],
        almacen: json["almacen"],
        cantidad: json["cantidad"],
        estadoVenta: json["estadoVenta"],
      );

  Map<String, dynamic> toJson() => {
        "idVenta": idVenta,
        "fecha": fecha.toIso8601String(),
        "concecionario": concecionario,
        "almacen": almacen,
        "cantidad": cantidad,
        "estadoVenta": estadoVenta,
      };
}
