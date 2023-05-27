import 'package:get/get.dart';
import 'package:iwrqk/app/modules/search/normal_search/page.dart';

import '../modules/account/downloads/binding.dart';
import '../modules/account/downloads/page.dart';
import '../modules/account/favorites/binding.dart';
import '../modules/account/favorites/page.dart';
import '../modules/account/history/binding.dart';
import '../modules/account/history/page.dart';
import '../modules/account/login/binding.dart';
import '../modules/account/login/page.dart';
import '../modules/account/messages/conversations_preview/binding.dart';
import '../modules/account/messages/conversations_preview/page.dart';
import '../modules/account/register/binding.dart';
import '../modules/account/register/page.dart';
import '../modules/auto_lock/binding.dart';
import '../modules/auto_lock/lock/binding.dart';
import '../modules/auto_lock/lock/page.dart';
import '../modules/auto_lock/page.dart';
import '../modules/comment_detail/binding.dart';
import '../modules/comment_detail/page.dart';
import '../modules/forum/channel/page.dart';
import '../modules/forum/thread/page.dart';
import '../modules/home/binding.dart';
import '../modules/home/page.dart';
import '../modules/media_detail/binding.dart';
import '../modules/media_detail/page.dart';
import '../modules/playlists/playlist_detail/binding.dart';
import '../modules/playlists/playlist_detail/page.dart';
import '../modules/playlists/playlists_preview/binding.dart';
import '../modules/playlists/playlists_preview/page.dart';
import '../modules/profile/binding.dart';
import '../modules/profile/page.dart';
import '../modules/profile/followers_following/page.dart';
import '../modules/search/normal_search/binding.dart';
import '../modules/search/normal_search_result/binding.dart';
import '../modules/search/normal_search_result/page.dart';
import '../modules/settings/binding.dart';
import '../modules/settings/page.dart';
import '../modules/splash/binding.dart';
import '../modules/splash/page.dart';

part './routes.dart';

abstract class AppPages {
  static final pages = [
    GetPage(
      name: AppRoutes.root,
      page: () => SplashPage(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: AppRoutes.home,
      page: () => HomePage(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: AppRoutes.login,
      page: () => LoginPage(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: AppRoutes.register,
      page: () => RegisterPage(),
      binding: RegisterBinding(),
    ),
    GetPage(
      name: AppRoutes.profile,
      page: () => ProfilePage(),
      binding: ProfileBinding(),
      preventDuplicates: false,
    ),
    GetPage(
      name: AppRoutes.mediaDetail,
      page: () => MediaDetailPage(),
      binding: MediaDetailBinding(),
      preventDuplicates: false,
    ),
    GetPage(
      name: AppRoutes.commentDetail,
      page: () => CommentDetailPage(),
      binding: CommentDetailBinding(),
      preventDuplicates: false,
    ),
    GetPage(
      name: AppRoutes.playlistsPreview,
      page: () => PlaylistsPreviewPage(),
      binding: PlaylistsPreviewBinding(),
      preventDuplicates: false,
    ),
    GetPage(
      name: AppRoutes.playlistDetail,
      page: () => PlaylistDetailPage(),
      binding: PlayListDetailBinding(),
      preventDuplicates: false,
    ),
    GetPage(
      name: AppRoutes.conversationsPreview,
      page: () => ConversationsPreviewPage(),
      binding: ConversationsPreviewBinding(),
      preventDuplicates: false,
    ),
    GetPage(
      name: AppRoutes.normalSearch,
      page: () => NormalSearchPage(),
      binding: NormalSearchBinding(),
      preventDuplicates: false,
    ),
    GetPage(
      name: AppRoutes.normalSearchResult,
      page: () => NormalSearchResultPage(),
      binding: NormalSearchResultBinding(),
      preventDuplicates: false,
    ),
    GetPage(
      name: AppRoutes.history,
      page: () => HistoryPage(),
      binding: HistoryBinding(),
    ),
    GetPage(
      name: AppRoutes.downloads,
      page: () => DownloadsPage(),
      binding: DownloadsBinding(),
    ),
    GetPage(
      name: AppRoutes.favorites,
      page: () => FavoritesPage(),
      binding: FavoritesBinding(),
    ),
    GetPage(
      name: AppRoutes.settings,
      page: () => SettingsPage(),
      binding: SettingsBinding(),
    ),
    GetPage(
      name: AppRoutes.lock,
      page: () => LockPage(),
      binding: LockBinding(),
      transition: Transition.noTransition,
    ),
    GetPage(
      name: AppRoutes.setPassword,
      page: () => SetPasswordPage(),
      binding: SetPasswordBinding(),
    ),
    GetPage(
      name: AppRoutes.followersFollowing,
      page: () => FollowersFollowingPage(),
      preventDuplicates: false,
    ),
    GetPage(
      name: AppRoutes.channel,
      page: () => ChannelPage(),
    ),
    GetPage(
      name: AppRoutes.thread,
      page: () => ThreadPage(),
      preventDuplicates: false,
    ),
  ];
}
