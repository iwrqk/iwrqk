import '../../enums/types.dart';

class FilterSettingModel {
  RatingType? ratingType;
  int? year;
  int? month;

  @override
  bool operator ==(other) {
    bool flag = false;
    if (other is FilterSettingModel) {
      if (other.ratingType == null &&
          other.year == null &&
          other.month == null) {
        return true;
      }
      flag = other.ratingType == ratingType &&
          other.year == year &&
          other.month == month;
    }
    return flag;
  }

  bool isEmpty() {
    return ratingType == null && year == null && month == null;
  }

  FilterSettingModel({this.ratingType, this.year, this.month});

  Map<String, dynamic> toJson() {
    return {
      "ratingType": ratingType?.value,
      "year": year,
      "month": month,
    };
  }

  factory FilterSettingModel.fromJson(Map<String, dynamic> json) {
    return FilterSettingModel(
      ratingType: RatingType.fromString(json["ratingType"]),
      year: json["year"],
      month: json["month"],
    );
  }
}
