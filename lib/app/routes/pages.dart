import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../modules/account/blocked_tags/binding.dart';
import '../modules/account/blocked_tags/page.dart';
import '../modules/account/downloads/binding.dart';
import '../modules/account/downloads/page.dart';
import '../modules/account/favorites/binding.dart';
import '../modules/account/favorites/page.dart';
import '../modules/account/friends/binding.dart';
import '../modules/account/friends/page.dart';
import '../modules/account/history/binding.dart';
import '../modules/account/history/page.dart';
import '../modules/account/login/binding.dart';
import '../modules/account/login/page.dart';
import '../modules/account/register/binding.dart';
import '../modules/account/register/page.dart';
import '../modules/forum/channel/binding.dart';
import '../modules/forum/channel/page.dart';
import '../modules/forum/create_thread/binding.dart';
import '../modules/forum/create_thread/page.dart';
import '../modules/forum/thread/binding.dart';
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
import '../modules/profile/followers_following/page.dart';
import '../modules/profile/page.dart';
import '../modules/profile/uploaded_media/binding.dart';
import '../modules/profile/uploaded_media/page.dart';
import '../modules/search_result/binding.dart';
import '../modules/search_result/view.dart';
import '../modules/settings/binding.dart';
import '../modules/settings/page.dart';
import '../modules/splash/binding.dart';
import '../modules/splash/page.dart';

part './routes.dart';

abstract class AppPages {
  static final RouteObserver routeObserver = RouteObserver();

  static final pages = [
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashPage(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: AppRoutes.home,
      page: () => const HomePage(),
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
      name: AppRoutes.settings,
      page: () => const SettingsPage(),
      binding: SettingsBinding(),
    ),
    GetPage(
      name: AppRoutes.mediaDetail,
      page: () => const MediaDetailPage(),
      binding: MediaDetailBinding(),
    ),
    GetPage(
      name: AppRoutes.profile,
      page: () => const ProfilePage(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: AppRoutes.followersFollowing,
      page: () => FollowersFollowingPage(),
    ),
    GetPage(
      name: AppRoutes.uploadedMedia,
      page: () => const UploadedMediaPage(),
      binding: UploadedMediaBinding(),
    ),
    GetPage(
      name: AppRoutes.searchResult,
      page: () => const SearchResultPage(),
      binding: SearchResultBinding(),
    ),
    GetPage(
      name: AppRoutes.channel,
      page: () => const ChannelPage(),
      binding: ChannelBinding(),
    ),
    GetPage(
      name: AppRoutes.thread,
      page: () => const ThreadPage(),
      binding: ThreadBinding(),
    ),
    GetPage(
      name: AppRoutes.createThread,
      page: () => const CreateThreadPage(),
      binding: CreateThreadBinding(),
    ),
    GetPage(
      name: AppRoutes.playlistsPreview,
      page: () => const PlaylistsPreviewPage(),
      binding: PlaylistsPreviewBinding(),
    ),
    GetPage(
      name: AppRoutes.playlistDetail,
      page: () => PlaylistDetailPage(),
      binding: PlayListDetailBinding(),
    ),
    GetPage(
      name: AppRoutes.friends,
      page: () => const FriendsPage(),
      binding: FriendsBinding(),
    ),
    GetPage(
      name: AppRoutes.blockedTags,
      page: () => const BlockedTagsPage(),
      binding: BlockedTagsBinding(),
    ),
    GetPage(
      name: AppRoutes.history,
      page: () => const HistoryPage(),
      binding: HistoryBinding(),
    ),
    GetPage(
      name: AppRoutes.downloads,
      page: () => const DownloadsPage(),
      binding: DownloadsBinding(),
    ),
    GetPage(
      name: AppRoutes.favorites,
      page: () => const FavoritesPage(),
      binding: FavoritesBinding(),
    ),
  ];
}
