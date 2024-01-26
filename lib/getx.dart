import 'package:get/get.dart';

import 'app/components/comments_list/controller.dart';
import 'app/components/dialogs/create_playlis_dialog/controller.dart';
import 'app/components/dialogs/loading_dialog/controller.dart';
import 'app/components/send_comment_bottom_sheet/controller.dart';
import 'app/data/services/account_service.dart';
import 'app/data/services/config_service.dart';
import 'app/data/services/download_service.dart';
import 'app/data/services/user_service.dart';
import 'app/modules/forum/thread/widgets/send_post_bottom_sheet/controller.dart';
import 'app/modules/media_detail/widgets/add_to_playlist/controller.dart';
import 'app/modules/media_detail/widgets/create_video_download_task/controller.dart';
import 'app/modules/tabs/media_grid_tab/widgets/filter_page/controller.dart';

void initGetx() {
  Get.put(ConfigService());
  Get.put(AccountService());
  Get.put(DownloadService());
  Get.put(UserService());

  Get.create(() => LoadingDialogController());
  Get.create(() => FilterController());
  Get.create(() => CreateVideoDownloadDialogController());
  Get.create(() => CreatePlaylistDialogController());
  Get.create(() => AddToPlaylistBottomSheetController());

  Get.create(() => CommentsListController());
  Get.create(() => SendCommentBottomSheetController());
  Get.create(() => SendPostBottomSheetController());
}
