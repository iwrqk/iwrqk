class RuleModel {
  final String id;
  final int weight;
  final Map<String, String> title;
  final Map<String, String> body;
  final DateTime createdAt;
  final DateTime updatedAt;

  RuleModel({
    required this.id,
    required this.weight,
    required this.title,
    required this.body,
    required this.createdAt,
    required this.updatedAt,
  });

  factory RuleModel.fromJson(Map<String, dynamic> json) {
    return RuleModel(
      id: json['id'],
      weight: json['weight'],
      title: Map<String, String>.from(json['title']),
      body: Map<String, String>.from(json['body']),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'weight': weight,
      'title': title,
      'body': body,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
