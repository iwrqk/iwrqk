import '../../../enums/types.dart';

class FilterSettingModel {
  RatingType? ratingType;
  int? year;
  int? month;
  List<String>? tags;

  bool isEmpty() {
    return ratingType == null && year == null && month == null;
  }

  FilterSettingModel({this.ratingType, this.year, this.month, this.tags});

  Map<String, dynamic> toJson() {
    return {
      "ratingType": ratingType?.value,
      "year": year,
      "month": month,
      "tags": tags,
    };
  }

  factory FilterSettingModel.fromJson(Map<String, dynamic> json) {
    return FilterSettingModel(
      ratingType: RatingType.fromString(json["ratingType"]),
      year: json["year"],
      month: json["month"],
      tags: json["tags"] != null ? List<String>.from(json["tags"]) : null,
    );
  }
}
