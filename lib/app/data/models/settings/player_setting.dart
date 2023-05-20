class PlayerSetting {
  int qualityIndex;
  int volume;

  PlayerSetting({
    this.qualityIndex = 0,
    this.volume = 100,
  });

  factory PlayerSetting.fromJson(Map<String, dynamic> json) {
    return PlayerSetting(
      qualityIndex: json['qualityIndex'],
      volume: json['volume'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'qualityIndex': qualityIndex,
      'volume': volume,
    };
  }
}
