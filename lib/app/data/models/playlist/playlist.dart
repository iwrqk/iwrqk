class PlaylistModel {
  String id;
  String title;
  int numVideos;

  PlaylistModel({
    required this.id,
    required this.title,
    required this.numVideos,
  });

  factory PlaylistModel.fromJson(Map<String, dynamic> json) {
    return PlaylistModel(
      id: json['id'],
      title: json['title'],
      numVideos: json['numVideos'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'numVideos': numVideos,
    };
  }
}
