class Report {
  String total;
  String completo;
  String incompleto;
  String concecionario;

  Report({
    required this.total,
    required this.completo,
    required this.incompleto,
    required this.concecionario,
  });

  factory Report.fromJson(Map<String, dynamic> json) => Report(
        total: json["total"],
        completo: json["completo"],
        incompleto: json["incompleto"],
        concecionario: json["concecionario"],
      );

  Map<String, dynamic> toJson() => {
        "total": total,
        "completo": completo,
        "incompleto": incompleto,
        "concecionario": concecionario,
      };
}
