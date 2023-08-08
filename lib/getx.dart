import 'package:get/get.dart';

import 'app/data/services/account_service.dart';
import 'app/data/services/android_service.dart';
import 'app/data/services/auto_lock_service.dart';
import 'app/data/services/config_service.dart';
import 'app/data/services/download_service.dart';
import 'app/data/services/user_service.dart';
import 'app/global_widgets/comments/comments_list/controller.dart';
import 'app/global_widgets/comments/send_comment_bottom_sheet/controller.dart';
import 'app/global_widgets/dialogs/create_playlis_dialog/controller.dart';
import 'app/global_widgets/dialogs/loading_dialog/controller.dart';
import 'app/modules/account/blocked_tags/widgets/add_tag_dialog/controller.dart';
import 'app/modules/account/messages/conversation_detail/widgets/send_message_bottom_sheet/controller.dart';
import 'app/modules/forum/thread/widgets/send_post_bottom_sheet/controller.dart';
import 'app/modules/media_detail/widgets/add_to_playlist_bottom_sheet/controller.dart';
import 'app/modules/media_detail/widgets/create_video_download_task_dialog/controller.dart';
import 'app/modules/tabs/media_grid_tab/widgets/filter_bottom_sheet/controller.dart';

void initGetx() {
  Get.put(ConfigService());
  Get.put(AutoLockService());
  Get.put(AccountService());
  Get.put(UserService());
  Get.put(DownloadService());

  if (GetPlatform.isAndroid) {
    Get.put(AndroidService());
  }

  Get.create(() => LoadingDialogController());
  Get.create(() => FilterBottomSheetController());
  Get.create(() => CreateVideoDownloadDialogController());
  Get.create(() => CreatePlaylistDialogController());
  Get.create(() => AddToPlaylistBottomSheetController());
  Get.create(() => AddTagDialogController());

  Get.create(() => CommentsListController());
  Get.create(() => SendCommentBottomSheetController());
  Get.create(() => SendPostBottomSheetController());
  Get.create(() => SendMessageBottomSheetController());
}
