import 'package:get/get.dart';

import '../../../../../data/enums/result.dart';
import '../../../../../data/enums/types.dart';
import '../../../../../data/models/media/media.dart';
import '../../../../../data/services/user_service.dart';
import '../../../../../global_widgets/sliver_refresh/controller.dart';
import 'repository.dart';

class FavoriteMediaPreviewListController
    extends SliverRefreshController<MediaModel> {
  final FavoriteMediaPreviewListRepository repository =
      FavoriteMediaPreviewListRepository();

  final UserService userService = Get.find();
  late MediaType _sourceType;

  void initConfig(MediaType sourceType) {
    _sourceType = sourceType;
  }

  Future<bool> unfavorite(int index) {
    return userService.unfavoriteMedia(data[index].id).then((value) {
      if (value) {
        data.removeAt(index);
        update();
      }

      return value;
    });
  }

  @override
  Future<GroupResult<MediaModel>> getNewData(int currentPage) {
    return repository.getPlaylistMedias(
      type: _sourceType,
      currentPage: currentPage,
    );
  }
}
