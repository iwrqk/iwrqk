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

  void showLoading() {
    change({"state": "loading"}, status: RxStatus.success());
  }

  Future<void> unfavoriteAll() {
    showLoading();
    return Future.wait(data.map((e) => userService.unfavoriteMedia(e.id)))
        .then((value) {
      refreshData(showSplash: true);
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
