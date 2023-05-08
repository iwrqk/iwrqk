class ResolutionSourceModel {
  final String view;
  final String download;

  ResolutionSourceModel({
    required this.view,
    required this.download,
  });

  String get viewUrl => "https:$view";

  String get downloadUrl => "https:$download";

  factory ResolutionSourceModel.fromJson(Map<String, dynamic> json) {
    return ResolutionSourceModel(
      view: json['view'],
      download: json['download'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'view': view,
      'download': download,
    };
  }
}

class ResolutionModel {
  final String name;
  final ResolutionSourceModel src;

  ResolutionModel({
    required this.name,
    required this.src,
  });

  factory ResolutionModel.fromJson(Map<String, dynamic> json) {
    return ResolutionModel(
      name: json['name'],
      src: ResolutionSourceModel.fromJson(json['src']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'src': src.toJson(),
    };
  }
}
