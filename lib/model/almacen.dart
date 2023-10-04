class Almacen {
  String idVenta;
  String almacen;

  Almacen({
    required this.idVenta,
    required this.almacen,
  });

  factory Almacen.fromJson(Map<String, dynamic> json) => Almacen(
        idVenta: json["idVenta"],
        almacen: json["almacen"],
      );

  Map<String, dynamic> toJson() => {
        "idVenta": idVenta,
        "almacen": almacen,
      };
}
