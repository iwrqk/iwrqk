part of './pages.dart';

abstract class AppRoutes {
  static const splash = '/splash';

  static const home = '/home';
  static const subscription = '/subscription';
  static const videos = '/videos';
  static const images = '/images';
  static const forum = '/forum';

  static const login = '/login';
  static const register = '/register';

  static const profile = '/profile';

  static const mediaDetail = '/mediaDetail';
  static const downloadedVideoDetail = '/downloadedVideoDetail';

  static const playlistsPreview = '/playlistsPreview';
  static const playlistDetail = '/playlistDetail';

  static const conversationsPreview = '/conversationsPreview';
  static const conversationDetail = '/conversationDetail';

  static const searchResult = '/searchResult';

  static const friends = '/friends';
  static const blockedTags = '/blockedTags';
  static const history = '/history';
  static const downloads = '/downloads';
  static const favorites = '/favorite';

  static const settings = '/settings';

  static const followersFollowing = '/followersFollowing';
  static const uploadedMedia = '/uploadedMedia';

  static const channel = '/channel';
  static const thread = '/thread';
  static const createThread = '/createThread';
}
