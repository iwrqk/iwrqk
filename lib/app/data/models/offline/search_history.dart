import '../../enums/types.dart';

class SearchHistoryModel {
  final String keyword;
  final SearchSource source;

  SearchHistoryModel({required this.keyword, required this.source});

  Map<String, dynamic> toJson() {
    return {
      'keyword': keyword,
      'source': source.index,
    };
  }

  factory SearchHistoryModel.fromJson(Map<String, dynamic> json) {
    return SearchHistoryModel(
      keyword: json['keyword'],
      source: SearchSource.values[json['source']],
    );
  }
}
