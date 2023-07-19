class ConfigModel {
  final String latestVersion;
  final bool forceUpdate;

  ConfigModel({
    required this.latestVersion,
    required this.forceUpdate,
  });

  factory ConfigModel.fromJson(Map<String, dynamic> json) {
    return ConfigModel(
      latestVersion: json['latestVersion'],
      forceUpdate: json['forceUpdate'],
    );
  }
}