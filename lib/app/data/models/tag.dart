class TagModel {
  String id;
  String type;

  TagModel(this.id, this.type);

  factory TagModel.fromJson(Map<String, dynamic> json) {
    return TagModel(
      json['id'],
      json['type'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
    };
  }
}
