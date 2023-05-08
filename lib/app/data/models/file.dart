class FileModel {
  String id;
  String? path;
  String? name;
  int? duration;
  int? numThumbnails;
  String? createdAt;
  String? updatedAt;

  FileModel({
    required this.id,
    this.path,
    this.name,
    this.duration,
    this.numThumbnails,
    this.createdAt,
    this.updatedAt,
  });

  factory FileModel.fromJson(Map<String, dynamic> json) {
    return FileModel(
      id: json['id'],
      path: json['path'],
      name: json['name'],
      duration: json['duration'],
      numThumbnails: json['numThumbnails'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'path': path,
      'name': name,
      'duration': duration,
      'numThumbnails': numThumbnails,
      'createdAt': createdAt,
      'updatedAt': updatedAt
    };
  }
}
