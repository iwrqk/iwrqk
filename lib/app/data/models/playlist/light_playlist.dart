class LightPlaylistModel {
  String id;
  String title;
  int numVideos;
  bool added;

  LightPlaylistModel({
    required this.id,
    required this.title,
    required this.numVideos,
    required this.added,
  });

  factory LightPlaylistModel.fromJson(Map<String, dynamic> json) {
    return LightPlaylistModel(
      id: json['id'],
      title: json['title'],
      numVideos: json['numVideos'],
      added: json['added'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'numVideos': numVideos,
      'added': added,
    };
  }
}
