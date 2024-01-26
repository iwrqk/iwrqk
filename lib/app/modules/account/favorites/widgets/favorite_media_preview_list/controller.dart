import 'package:get/get.dart';

import '../../../../../components/iwr_refresh/controller.dart';
import '../../../../../data/enums/result.dart';
import '../../../../../data/enums/types.dart';
import '../../../../../data/models/media/media.dart';
import '../../../../../data/services/user_service.dart';
import '../../controller.dart';
import 'repository.dart';

class FavoriteMediaPreviewListController
    extends IwrRefreshController<MediaModel> {
  final FavoriteMediaPreviewListRepository repository =
      FavoriteMediaPreviewListRepository();

  final FavoritesController _parentController = Get.find();

  final UserService userService = Get.find();
  late MediaType _sourceType;

  void initConfig(MediaType sourceType) {
    _sourceType = sourceType;
  }

  void toggleCheckedAll() {
    for (var item in data) {
      _parentController.toggleChecked(item, true);
    }
    update();
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
