part of './pages.dart';

abstract class AppRoutes {
  static const root = '/';

  static const setup = '/setup';

  static const home = '/home';
  static const subscription = '/subscription';
  static const videos = '/videos';
  static const images = '/images';
  static const forum = '/forum';

  static const login = '/login';
  static const register = '/register';

  static const profile = '/profile';

  static const mediaDetail = '/mediaDetail';

  static const commentDetail = '/commentDetail';

  static const playlistsPreview = '/playlistsPreview';
  static const playlistDetail = '/playlistDetail';

  static const conversationsPreview = '/conversationsPreview';
  static const conversationDetail = '/conversationDetail';

  static const normalSearch = '/normalSearch';
  static const normalSearchResult = '/normalSearchResult';

  static const friends = '/friends';
  static const history = '/history';
  static const downloads = '/downloads';
  static const favorites = '/favorite';

  static const settings = '/settings';
  static const lock = '/lock';
  static const setPassword = '/setPassword';

  static const followersFollowing = '/followersFollowing';

  static const channel = '/channel';
  static const thread = '/thread';
}
