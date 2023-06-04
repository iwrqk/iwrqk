
import '../../../enums/types.dart';

class MediaSortSettingModel {
  final OrderType? orderType;
  final String? userId;
  final String? keyword;
  final bool subscribed;

  MediaSortSettingModel({
    this.orderType,
    this.userId,
    this.keyword,
    this.subscribed = false,
  });
}
