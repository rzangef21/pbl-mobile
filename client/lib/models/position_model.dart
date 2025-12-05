class PositionModel {
  final int id;
  final String name;

  PositionModel({required this.id, required this.name});

  factory PositionModel.fromJson(Map<String, dynamic> json) {
    return PositionModel(id: json["id"], name: json["name"]);
  }
}
