import '../../../enums/types.dart';

class MediaSortSettingModel {
  final OrderType? orderType;
  final String? userId;
  final bool subscribed;

  MediaSortSettingModel({
    this.orderType,
    this.userId,
    this.subscribed = false,
  });
}
