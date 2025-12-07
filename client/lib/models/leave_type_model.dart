class LeaveType {
  final int id;
  final String name;
  final String code;

  LeaveType({
    required this.id,
    required this.name,
    required this.code,
  });

  factory LeaveType.fromJson(Map<String, dynamic> json) {
    return LeaveType(
      id: json['id'],
      name: json['name'],
      code: json['code'] ?? '',
    );
  }
}
