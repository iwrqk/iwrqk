/// Generated file. Do not edit.
///
/// Original: lib/i18n
/// To regenerate, run: `dart run slang`
///
/// Locales: 4
/// Strings: 1088 (272 per locale)
///
/// Built on 2024-02-23 at 10:35 UTC

// coverage:ignore-file
// ignore_for_file: type=lint

import 'package:flutter/widgets.dart';
import 'package:slang/builder/model/node.dart';
import 'package:slang_flutter/slang_flutter.dart';
export 'package:slang_flutter/slang_flutter.dart';

const AppLocale _baseLocale = AppLocale.en;

/// Supported locales, see extension methods below.
///
/// Usage:
/// - LocaleSettings.setLocale(AppLocale.en) // set locale
/// - Locale locale = AppLocale.en.flutterLocale // get flutter locale from enum
/// - if (LocaleSettings.currentLocale == AppLocale.en) // locale check
enum AppLocale with BaseAppLocale<AppLocale, Translations> {
	en(languageCode: 'en', build: Translations.build),
	ja(languageCode: 'ja', build: _StringsJa.build),
	zhCn(languageCode: 'zh', countryCode: 'CN', build: _StringsZhCn.build),
	zhTw(languageCode: 'zh', countryCode: 'TW', build: _StringsZhTw.build);

	const AppLocale({required this.languageCode, this.scriptCode, this.countryCode, required this.build}); // ignore: unused_element

	@override final String languageCode;
	@override final String? scriptCode;
	@override final String? countryCode;
	@override final TranslationBuilder<AppLocale, Translations> build;

	/// Gets current instance managed by [LocaleSettings].
	Translations get translations => LocaleSettings.instance.translationMap[this]!;
}

/// Method A: Simple
///
/// No rebuild after locale change.
/// Translation happens during initialization of the widget (call of t).
/// Configurable via 'translate_var'.
///
/// Usage:
/// String a = t.someKey.anotherKey;
/// String b = t['someKey.anotherKey']; // Only for edge cases!
Translations get t => LocaleSettings.instance.currentTranslations;

/// Method B: Advanced
///
/// All widgets using this method will trigger a rebuild when locale changes.
/// Use this if you have e.g. a settings page where the user can select the locale during runtime.
///
/// Step 1:
/// wrap your App with
/// TranslationProvider(
/// 	child: MyApp()
/// );
///
/// Step 2:
/// final t = Translations.of(context); // Get t variable.
/// String a = t.someKey.anotherKey; // Use t variable.
/// String b = t['someKey.anotherKey']; // Only for edge cases!
class TranslationProvider extends BaseTranslationProvider<AppLocale, Translations> {
	TranslationProvider({required super.child}) : super(settings: LocaleSettings.instance);

	static InheritedLocaleData<AppLocale, Translations> of(BuildContext context) => InheritedLocaleData.of<AppLocale, Translations>(context);
}

/// Method B shorthand via [BuildContext] extension method.
/// Configurable via 'translate_var'.
///
/// Usage (e.g. in a widget's build method):
/// context.t.someKey.anotherKey
extension BuildContextTranslationsExtension on BuildContext {
	Translations get t => TranslationProvider.of(this).translations;
}

/// Manages all translation instances and the current locale
class LocaleSettings extends BaseFlutterLocaleSettings<AppLocale, Translations> {
	LocaleSettings._() : super(utils: AppLocaleUtils.instance);

	static final instance = LocaleSettings._();

	// static aliases (checkout base methods for documentation)
	static AppLocale get currentLocale => instance.currentLocale;
	static Stream<AppLocale> getLocaleStream() => instance.getLocaleStream();
	static AppLocale setLocale(AppLocale locale, {bool? listenToDeviceLocale = false}) => instance.setLocale(locale, listenToDeviceLocale: listenToDeviceLocale);
	static AppLocale setLocaleRaw(String rawLocale, {bool? listenToDeviceLocale = false}) => instance.setLocaleRaw(rawLocale, listenToDeviceLocale: listenToDeviceLocale);
	static AppLocale useDeviceLocale() => instance.useDeviceLocale();
	@Deprecated('Use [AppLocaleUtils.supportedLocales]') static List<Locale> get supportedLocales => instance.supportedLocales;
	@Deprecated('Use [AppLocaleUtils.supportedLocalesRaw]') static List<String> get supportedLocalesRaw => instance.supportedLocalesRaw;
	static void setPluralResolver({String? language, AppLocale? locale, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver}) => instance.setPluralResolver(
		language: language,
		locale: locale,
		cardinalResolver: cardinalResolver,
		ordinalResolver: ordinalResolver,
	);
}

/// Provides utility functions without any side effects.
class AppLocaleUtils extends BaseAppLocaleUtils<AppLocale, Translations> {
	AppLocaleUtils._() : super(baseLocale: _baseLocale, locales: AppLocale.values);

	static final instance = AppLocaleUtils._();

	// static aliases (checkout base methods for documentation)
	static AppLocale parse(String rawLocale) => instance.parse(rawLocale);
	static AppLocale parseLocaleParts({required String languageCode, String? scriptCode, String? countryCode}) => instance.parseLocaleParts(languageCode: languageCode, scriptCode: scriptCode, countryCode: countryCode);
	static AppLocale findDeviceLocale() => instance.findDeviceLocale();
	static List<Locale> get supportedLocales => instance.supportedLocales;
	static List<String> get supportedLocalesRaw => instance.supportedLocalesRaw;
}

// translations

// Path: <root>
class Translations implements BaseTranslations<AppLocale, Translations> {
	/// Returns the current translations of the given [context].
	///
	/// Usage:
	/// final t = Translations.of(context);
	static Translations of(BuildContext context) => InheritedLocaleData.of<AppLocale, Translations>(context).translations;

	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	Translations.build({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  $meta = TranslationMetadata(
		    locale: AppLocale.en,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ) {
		$meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <en>.
	@override final TranslationMetadata<AppLocale, Translations> $meta;

	/// Access flat map
	dynamic operator[](String key) => $meta.getTranslation(key);

	late final Translations _root = this; // ignore: unused_field

	// Translations
	Map<String, String> get locales => {
		'en': 'English',
		'ja': '日本語',
		'zh-CN': '简体中文',
		'zh-TW': '繁體中文',
	};
	late final _StringsRulesEn rules = _StringsRulesEn._(_root);
	late final _StringsNavEn nav = _StringsNavEn._(_root);
	late final _StringsCommonEn common = _StringsCommonEn._(_root);
	late final _StringsRefreshEn refresh = _StringsRefreshEn._(_root);
	late final _StringsRecordsEn records = _StringsRecordsEn._(_root);
	late final _StringsAccountEn account = _StringsAccountEn._(_root);
	late final _StringsProfileEn profile = _StringsProfileEn._(_root);
	late final _StringsSortEn sort = _StringsSortEn._(_root);
	late final _StringsFilterEn filter = _StringsFilterEn._(_root);
	late final _StringsSearchEn search = _StringsSearchEn._(_root);
	late final _StringsTimeEn time = _StringsTimeEn._(_root);
	late final _StringsMediaEn media = _StringsMediaEn._(_root);
	late final _StringsPlayerEn player = _StringsPlayerEn._(_root);
	late final _StringsCommentEn comment = _StringsCommentEn._(_root);
	late final _StringsUserEn user = _StringsUserEn._(_root);
	late final _StringsFriendEn friend = _StringsFriendEn._(_root);
	late final _StringsBlockedTagsEn blocked_tags = _StringsBlockedTagsEn._(_root);
	late final _StringsDownloadEn download = _StringsDownloadEn._(_root);
	late final _StringsPlaylistEn playlist = _StringsPlaylistEn._(_root);
	late final _StringsChannelEn channel = _StringsChannelEn._(_root);
	late final _StringsCreateThreadEn create_thread = _StringsCreateThreadEn._(_root);
	late final _StringsNotificationsEn notifications = _StringsNotificationsEn._(_root);
	late final _StringsSettingsEn settings = _StringsSettingsEn._(_root);
	late final _StringsThemeEn theme = _StringsThemeEn._(_root);
	late final _StringsColorsEn colors = _StringsColorsEn._(_root);
	late final _StringsDisplayModeEn display_mode = _StringsDisplayModeEn._(_root);
	late final _StringsProxyEn proxy = _StringsProxyEn._(_root);
	late final _StringsMessageEn message = _StringsMessageEn._(_root);
	late final _StringsErrorEn error = _StringsErrorEn._(_root);
}

// Path: rules
class _StringsRulesEn {
	_StringsRulesEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => 'Rules';
	String get accept => 'I accept the rules';
	String get accept_desc => 'I agree to have read the rules and will stay up to date with any future rule changes.';
}

// Path: nav
class _StringsNavEn {
	_StringsNavEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get subscriptions => 'Subscriptions';
	String get videos => 'Videos';
	String get images => 'Images';
	String get forum => 'Forum';
	String get search => 'Search';
}

// Path: common
class _StringsCommonEn {
	_StringsCommonEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get video => 'Video';
	String get image => 'Image';
	String get collapse => 'Collapse';
	String get expand => 'Expand';
	String get translate => 'Translate';
	String get open => 'Open';
}

// Path: refresh
class _StringsRefreshEn {
	_StringsRefreshEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get empty => 'Nothing here';
	String get drag_to_load => 'Pull to load';
	String get release_to_load => 'Release to load';
	String get success => 'Succeeded';
	String get failed => 'Failed';
	String get no_more => 'No more';
	String get last_load => 'Last updated at %T';
}

// Path: records
class _StringsRecordsEn {
	_StringsRecordsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get select_all => 'Select all';
	String get select_inverse => 'Select inverse';
	String selected_num({required Object num}) => '${num} selected';
	String get multiple_selection_mode => 'Multiple selection mode';
	String get delete => 'Delete';
	String get delete_all => 'Delete all';
}

// Path: account
class _StringsAccountEn {
	_StringsAccountEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get captcha => 'Captcha';
	String get login => 'Login';
	String get logout => 'Logout';
	String get register => 'Register';
	String get email => 'Email';
	String get email_or_username => 'Email or username';
	String get password => 'Password';
	String get forgot_password => 'Forgot password?';
	String get require_login => 'You must be logged in to do that.';
}

// Path: profile
class _StringsProfileEn {
	_StringsProfileEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get profile => 'Profile';
	String get follow => 'Follow';
	String get followers => 'Followers';
	String get following => 'Following';
	String get nickname => 'Nickname';
	String get username => 'Username';
	String get user_id => 'User ID';
	String get description => 'Description';
	String get no_description => 'This user prefers to keep an air of mystery around them.';
	String get join_date => 'Join date';
	String get last_active_time => 'Last active time';
	String get online => 'Online';
	String get message => 'Message';
	String get guestbook => 'Guestbook';
	String get view_more => 'View more';
}

// Path: sort
class _StringsSortEn {
	_StringsSortEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get latest => 'Latest';
	String get trending => 'Trending';
	String get popularity => 'Popularity';
	String get most_views => 'Most views';
	String get most_likes => 'Most likes';
}

// Path: filter
class _StringsFilterEn {
	_StringsFilterEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get all => 'All';
	String get filter => 'Filter';
	String get rating => 'Rating';
	String get tag => 'Tag';
	String get tags => 'Tags';
	String get date => 'Date';
	String get general => 'General';
	String get ecchi => 'Ecchi';
	String get select_rating => 'Select rating';
	String get select_year => 'Select year';
	String get select_month => 'Select month';
}

// Path: search
class _StringsSearchEn {
	_StringsSearchEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get users => 'Users';
	String get search => 'Search';
	late final _StringsSearchHistoryEn history = _StringsSearchHistoryEn._(_root);
}

// Path: time
class _StringsTimeEn {
	_StringsTimeEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String seconds_ago({required Object time}) => '${time} seconds ago';
	String minutes_ago({required Object time}) => '${time} minutes ago';
	String hours_ago({required Object time}) => '${time} hours ago';
	String days_ago({required Object time}) => '${time} days ago';
}

// Path: media
class _StringsMediaEn {
	_StringsMediaEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get private => 'Private';
	String get add_to_playlist => 'Add to playlist';
	String get external_video => 'External video';
	String get share => 'Share';
	String get download => 'Download';
	String more_from({required Object username}) => 'More from ${username}';
	String get more_like_this => 'More like this';
	String updated_at({required Object time}) => 'Updated at ${time}';
}

// Path: player
class _StringsPlayerEn {
	_StringsPlayerEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String current_item({required Object item}) => 'Current: ${item}';
	String get quality => 'Quality';
	String get select_quality => 'Select quality';
	String get playback_speed => 'Playback speed';
	String get select_playback_speed => 'Select playback speed';
	String get aspect_ratio => 'Aspect ratio';
	String get select_aspect_ratio => 'Select aspect ratio';
	late final _StringsPlayerAspectRatiosEn aspect_ratios = _StringsPlayerAspectRatiosEn._(_root);
	String seconds({required Object value}) => '${value}s';
	String get double_speed => '2x';
}

// Path: comment
class _StringsCommentEn {
	_StringsCommentEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get comment => 'Comment';
	String get comments => 'Comments';
	String get comment_detail => 'Comment detail';
	String get edit_comment => 'Edit comment';
	String get delete_comment => 'Delete comment';
	String get reply => 'Reply';
	String replies_in_total({required Object numReply}) => '${numReply} replies in total';
	String show_all_replies({required Object numReply}) => 'Show all ${numReply} replies';
}

// Path: user
class _StringsUserEn {
	_StringsUserEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get following => 'Following';
	String get history => 'History';
	String get blocked_tags => 'Blocked Tags';
	String get friends => 'Friends';
	String get downloads => 'Downloads';
	String get favorites => 'Favorites';
	String get playlists => 'Playlists';
	String get settings => 'Settings';
	String get about => 'About';
}

// Path: friend
class _StringsFriendEn {
	_StringsFriendEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get friend_requests => 'Friend Requests';
	String get add_friend => 'Add friend';
	String get pending => 'Pending';
	String get unfriend => 'Unfriend';
	String get accept => 'Accept';
	String get reject => 'Reject';
}

// Path: blocked_tags
class _StringsBlockedTagsEn {
	_StringsBlockedTagsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get add_blocked_tag => 'Add blocked tag';
	String get blocked_tag => 'Blocked tag';
}

// Path: download
class _StringsDownloadEn {
	_StringsDownloadEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get create_download_task => 'Create download task';
	String get unknown => 'Unknown';
	String get enqueued => 'Enqueued';
	String get downloading => 'Downloading';
	String get paused => 'Paused';
	String get finished => 'Finished';
	String get failed => 'Failed';
	String get retry => 'Retry';
	String get delete => 'Delete';
	String get pause => 'Pause';
	String get resume => 'Resume';
	String get open_with => 'Open with';
	String get jump_to_detail => 'Jump to detail page';
}

// Path: playlist
class _StringsPlaylistEn {
	_StringsPlaylistEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => 'Playlist title';
	String get create => 'Create playlist';
	String get select => 'Select playlist';
	String get edit_title => 'Edit title';
	String videos_count({required Object numVideo}) => '${numVideo} video';
	String videos_count_plural({required Object numVideo}) => '${numVideo} videos';
}

// Path: channel
class _StringsChannelEn {
	_StringsChannelEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get administration => 'Administration';
	String get announcements => 'Announcements';
	String get feedback => 'Feedback';
	String get support => 'Support';
	String get global => 'Global';
	String get general => 'General';
	String get guides => 'Guides';
	String get questions => 'Questions';
	String get requests => 'Requests';
	String get sharing => 'Sharing';
	String label({required Object numThread, required Object numPosts}) => '${numThread} Threads ${numPosts} Posts';
}

// Path: create_thread
class _StringsCreateThreadEn {
	_StringsCreateThreadEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get create_thread => 'Create thread';
	String get title => 'Title';
	String get content => 'Content';
}

// Path: notifications
class _StringsNotificationsEn {
	_StringsNotificationsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get ok => 'OK';
	String get success => 'Success';
	String get error => 'Error';
	String get loading => 'Loading...';
	String get cancel => 'Cancel';
	String get confirm => 'Confirm';
	String get apply => 'Apply';
}

// Path: settings
class _StringsSettingsEn {
	_StringsSettingsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get appearance => 'Appearance';
	String get theme => 'Theme';
	String get theme_desc => 'Change the theme of the App';
	String get dynamic_color => 'Dynamic Color';
	String get dynamic_color_desc => 'Change the color of the App according to the content';
	String get custom_color => 'Custom Color';
	String get custom_color_desc => 'Customize the color of the App';
	String get language => 'Language';
	String get language_desc => 'Change the language of the App';
	String get display_mode => 'Display Mode';
	String get display_mode_desc => 'Change the display mode of the App';
	String get work_mode => 'Work Mode';
	String get work_mode_desc => 'Hide all covers of NSFW content';
	String get network => 'Network';
	String get enable_proxy => 'Enable Proxy';
	String get enable_proxy_desc => 'Enable proxy for the App';
	String get proxy => 'Proxy';
	String get proxy_desc => 'Set the host and port of the proxy';
	String get player => 'Player';
	String get autoplay => 'Autoplay';
	String get autoplay_desc => 'Autoplay video when opening a video page';
	String get background_play => 'Background Play';
	String get background_play_desc => 'Allow the App to play video in the background';
	String get download => 'Download';
	String get download_path => 'Download Path';
	String get allow_media_scan => 'Allow Media Scan';
	String get allow_media_scan_desc => 'Allow media scanner to read downloaded media files';
	String get logging => 'Logging';
	String get enable_logging => 'Enable Logging';
	String get enable_logging_desc => 'Enable logging for the App';
	String get clear_log => 'Clear Log';
	String clear_log_desc({required Object size}) => 'Current log size: ${size}';
	String get enable_verbose_logging => 'Enable Verbose Logging';
	String get enable_verbose_logging_desc => 'Record more detailed logs';
	String get about => 'About';
	String get check_update => 'Check Update';
	String get check_update_desc => 'Check if there is a new version available';
	String get third_party_license => 'Third Party License';
	String get third_party_license_desc => 'View the license of third party libraries';
}

// Path: theme
class _StringsThemeEn {
	_StringsThemeEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get system => 'System';
	String get light => 'Light';
	String get dark => 'Dark';
}

// Path: colors
class _StringsColorsEn {
	_StringsColorsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get pink => 'Pink';
	String get red => 'Red';
	String get orange => 'Orange';
	String get amber => 'Amber';
	String get yellow => 'Yellow';
	String get lime => 'Lime';
	String get lightGreen => 'Light Green';
	String get green => 'Green';
	String get teal => 'Teal';
	String get cyan => 'Cyan';
	String get lightBlue => 'Light Blue';
	String get blue => 'Blue';
	String get indigo => 'Indigo';
	String get purple => 'Purple';
	String get deepPurple => 'Deep Purple';
	String get blueGrey => 'Blue Grey';
	String get brown => 'Brown';
	String get grey => 'Grey';
}

// Path: display_mode
class _StringsDisplayModeEn {
	_StringsDisplayModeEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get no_available => 'No available display mode';
	String get auto => 'Auto';
	String get system => 'System';
}

// Path: proxy
class _StringsProxyEn {
	_StringsProxyEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get host => 'Host';
	String get port => 'Port';
}

// Path: message
class _StringsMessageEn {
	_StringsMessageEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get exit_app => 'Press again to exit the App';
	String get are_you_sure_to_do_that => 'Are you sure to do that?';
	String get restart_required => 'Restart the App to apply the changes.';
	String get please_type_host => 'Please type the host';
	String get please_type_port => 'Please type the port';
	late final _StringsMessageAccountEn account = _StringsMessageAccountEn._(_root);
	late final _StringsMessageCommentEn comment = _StringsMessageCommentEn._(_root);
	late final _StringsMessageCreateThreadEn create_thread = _StringsMessageCreateThreadEn._(_root);
	late final _StringsMessageBlockedTagsEn blocked_tags = _StringsMessageBlockedTagsEn._(_root);
	late final _StringsMessagePlaylistEn playlist = _StringsMessagePlaylistEn._(_root);
	late final _StringsMessageDownloadEn download = _StringsMessageDownloadEn._(_root);
	late final _StringsMessageUpdateEn update = _StringsMessageUpdateEn._(_root);
}

// Path: error
class _StringsErrorEn {
	_StringsErrorEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get retry => 'Load failed, click to retry.';
	String get fetch_failed => 'Failed to fetch video links.';
	String get fetch_user_info_failed => 'Failed to fetch user info.';
	String get invalid_path => 'Invalid path.';
	late final _StringsErrorAccountEn account = _StringsErrorAccountEn._(_root);
}

// Path: search.history
class _StringsSearchHistoryEn {
	_StringsSearchHistoryEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get delete => 'Delete All';
}

// Path: player.aspect_ratios
class _StringsPlayerAspectRatiosEn {
	_StringsPlayerAspectRatiosEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get contain => 'Contain';
	String get cover => 'Cover';
	String get fill => 'Fill';
	String get fit_height => 'Fit height';
	String get fit_width => 'Fit width';
	String get scale_down => 'Scale down';
}

// Path: message.account
class _StringsMessageAccountEn {
	_StringsMessageAccountEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get login_success => 'Login success.';
	String get register_success => 'Register success, further instructions have been sent to your email.';
	String get login_password_longer_than_6 => 'Password must be longer than 6 characters';
	String get please_type_email => 'Please type your email';
	String get please_type_email_or_username => 'Please type your email or username';
	String get please_type_valid_email => 'Please type a valid email';
	String get please_type_password => 'Please type your password';
	String get please_type_captcha => 'Please type the captcha';
}

// Path: message.comment
class _StringsMessageCommentEn {
	_StringsMessageCommentEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get content_empty => 'Content can not be empty.';
	String get content_too_long => 'Content can not be longer than 1000 characters.';
	String get sent => 'Reply sent.';
}

// Path: message.create_thread
class _StringsMessageCreateThreadEn {
	_StringsMessageCreateThreadEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title_empty => 'Title can not be empty.';
	String get title_too_long => 'Title is too long.';
	String get content_empty => 'Content can not be empty.';
	String get content_too_long => 'Content can not be longer than 20000 characters.';
	String get created => 'Thread Created.';
}

// Path: message.blocked_tags
class _StringsMessageBlockedTagsEn {
	_StringsMessageBlockedTagsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get save_confirm => 'Are you sure to save the blocked tags?';
	String get saved => 'Blocked tags saved.';
	String get reached_limit => 'Blocked tags reached limit.';
}

// Path: message.playlist
class _StringsMessagePlaylistEn {
	_StringsMessagePlaylistEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get empty_playlist_title => 'Playlist title can not be empty.';
	String get playlist_created => 'Playlist created.';
	String get playlist_title_edited => 'Playlist title edited.';
}

// Path: message.download
class _StringsMessageDownloadEn {
	_StringsMessageDownloadEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get no_provide_storage_permission => 'No storage permission provided.';
	String get task_already_exists => 'Download task already exists.';
	String get task_created => 'Download task created.';
	String get maximum_simultaneous_download_reached => 'Maximum simultaneous download reached.';
}

// Path: message.update
class _StringsMessageUpdateEn {
	_StringsMessageUpdateEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get check_update_failed => 'Failed to check update.';
	String get update_available => 'Update available';
	String get already_latest_version => 'Already the latest version';
	String current_version({required Object version}) => 'Current version: ${version}';
	String latest_version({required Object version}) => 'Latest version: ${version}';
	String get view_update => 'View update';
}

// Path: error.account
class _StringsErrorAccountEn {
	_StringsErrorAccountEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get invalid_login => 'Invalid email or password.';
	String get invalid_host => 'Invalid host.';
	String get invalid_captcha => 'Invalid captcha.';
}

// Path: <root>
class _StringsJa extends Translations {
	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	_StringsJa.build({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  $meta = TranslationMetadata(
		    locale: AppLocale.ja,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ),
		  super.build(cardinalResolver: cardinalResolver, ordinalResolver: ordinalResolver) {
		super.$meta.setFlatMapFunction($meta.getTranslation); // copy base translations to super.$meta
		$meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <ja>.
	@override final TranslationMetadata<AppLocale, Translations> $meta;

	/// Access flat map
	@override dynamic operator[](String key) => $meta.getTranslation(key) ?? super.$meta.getTranslation(key);

	@override late final _StringsJa _root = this; // ignore: unused_field

	// Translations
	@override late final _StringsNavJa nav = _StringsNavJa._(_root);
	@override late final _StringsRulesJa rules = _StringsRulesJa._(_root);
	@override late final _StringsCommonJa common = _StringsCommonJa._(_root);
	@override late final _StringsRefreshJa refresh = _StringsRefreshJa._(_root);
	@override late final _StringsRecordsJa records = _StringsRecordsJa._(_root);
	@override late final _StringsAccountJa account = _StringsAccountJa._(_root);
	@override late final _StringsProfileJa profile = _StringsProfileJa._(_root);
	@override late final _StringsSortJa sort = _StringsSortJa._(_root);
	@override late final _StringsFilterJa filter = _StringsFilterJa._(_root);
	@override late final _StringsSearchJa search = _StringsSearchJa._(_root);
	@override late final _StringsTimeJa time = _StringsTimeJa._(_root);
	@override late final _StringsMediaJa media = _StringsMediaJa._(_root);
	@override late final _StringsPlayerJa player = _StringsPlayerJa._(_root);
	@override late final _StringsCommentJa comment = _StringsCommentJa._(_root);
	@override late final _StringsUserJa user = _StringsUserJa._(_root);
	@override late final _StringsFriendJa friend = _StringsFriendJa._(_root);
	@override late final _StringsBlockedTagsJa blocked_tags = _StringsBlockedTagsJa._(_root);
	@override late final _StringsDownloadJa download = _StringsDownloadJa._(_root);
	@override late final _StringsPlaylistJa playlist = _StringsPlaylistJa._(_root);
	@override late final _StringsChannelJa channel = _StringsChannelJa._(_root);
	@override late final _StringsCreateThreadJa create_thread = _StringsCreateThreadJa._(_root);
	@override late final _StringsNotificationsJa notifications = _StringsNotificationsJa._(_root);
	@override late final _StringsSettingsJa settings = _StringsSettingsJa._(_root);
	@override late final _StringsThemeJa theme = _StringsThemeJa._(_root);
	@override late final _StringsColorsJa colors = _StringsColorsJa._(_root);
	@override late final _StringsDisplayModeJa display_mode = _StringsDisplayModeJa._(_root);
	@override late final _StringsProxyJa proxy = _StringsProxyJa._(_root);
	@override late final _StringsMessageJa message = _StringsMessageJa._(_root);
	@override late final _StringsErrorJa error = _StringsErrorJa._(_root);
}

// Path: nav
class _StringsNavJa extends _StringsNavEn {
	_StringsNavJa._(_StringsJa root) : this._root = root, super._(root);

	@override final _StringsJa _root; // ignore: unused_field

	// Translations
	@override String get subscriptions => 'サブスク';
	@override String get videos => '動画';
	@override String get images => '画像';
	@override String get forum => 'フォーラム';
	@override String get search => '検索';
}

// Path: rules
class _StringsRulesJa extends _StringsRulesEn {
	_StringsRulesJa._(_StringsJa root) : this._root = root, super._(root);

	@override final _StringsJa _root; // ignore: unused_field

	// Translations
	@override String get title => 'ルール';
	@override String get accept => '同意する';
	@override String get accept_desc => '私はルールを読み、これに同意し、今後のルール変更についても、最新の情報を確認することに同意します。';
}

// Path: common
class _StringsCommonJa extends _StringsCommonEn {
	_StringsCommonJa._(_StringsJa root) : this._root = root, super._(root);

	@override final _StringsJa _root; // ignore: unused_field

	// Translations
	@override String get video => '動画';
	@override String get image => '画像';
	@override String get collapse => '折りたたむ';
	@override String get expand => '展開';
	@override String get translate => '翻訳';
	@override String get open => '開く';
}

// Path: refresh
class _StringsRefreshJa extends _StringsRefreshEn {
	_StringsRefreshJa._(_StringsJa root) : this._root = root, super._(root);

	@override final _StringsJa _root; // ignore: unused_field

	// Translations
	@override String get empty => '何もありません';
	@override String get drag_to_load => '引っ張って読み込む';
	@override String get release_to_load => 'リリースして読み込む';
	@override String get success => '読み込み成功';
	@override String get failed => '読み込み失敗';
	@override String get no_more => 'これ以上なし';
	@override String get last_load => '前回の読み込み： %T';
}

// Path: records
class _StringsRecordsJa extends _StringsRecordsEn {
	_StringsRecordsJa._(_StringsJa root) : this._root = root, super._(root);

	@override final _StringsJa _root; // ignore: unused_field

	// Translations
	@override String get select_all => 'すべて選択';
	@override String get select_inverse => '逆選択';
	@override String selected_num({required Object num}) => '選択済み ${num} 項目';
	@override String get multiple_selection_mode => '複数選択モード';
	@override String get delete => '削除';
	@override String get delete_all => 'すべて削除';
}

// Path: account
class _StringsAccountJa extends _StringsAccountEn {
	_StringsAccountJa._(_StringsJa root) : this._root = root, super._(root);

	@override final _StringsJa _root; // ignore: unused_field

	// Translations
	@override String get captcha => 'キャプチャ';
	@override String get login => 'ログイン';
	@override String get logout => 'ログアウト';
	@override String get register => '登録';
	@override String get email => 'メール';
	@override String get email_or_username => 'メールまたはユーザー名';
	@override String get password => 'パスワード';
	@override String get forgot_password => 'パスワードを忘れた';
	@override String get require_login => 'ログインしてください';
}

// Path: profile
class _StringsProfileJa extends _StringsProfileEn {
	_StringsProfileJa._(_StringsJa root) : this._root = root, super._(root);

	@override final _StringsJa _root; // ignore: unused_field

	// Translations
	@override String get profile => 'プロフィール';
	@override String get follow => 'フォロー';
	@override String get followers => 'フォロワー';
	@override String get following => 'フォロー中';
	@override String get nickname => 'ニックネーム';
	@override String get username => 'ユーザー名';
	@override String get user_id => 'ユーザーID';
	@override String get description => '自己紹介';
	@override String get no_description => '自分の周りに謎の空気を漂わせるのが好きです。';
	@override String get join_date => '参加日';
	@override String get last_active_time => '最終アクティブ時間';
	@override String get online => 'オンライン';
	@override String get message => 'メッセージ';
	@override String get guestbook => 'ゲストブック';
	@override String get view_more => 'もっと見る';
}

// Path: sort
class _StringsSortJa extends _StringsSortEn {
	_StringsSortJa._(_StringsJa root) : this._root = root, super._(root);

	@override final _StringsJa _root; // ignore: unused_field

	// Translations
	@override String get latest => '最新';
	@override String get trending => 'トレンド';
	@override String get popularity => '人気順';
	@override String get most_views => '閲覧数';
	@override String get most_likes => 'お気に入り数';
}

// Path: filter
class _StringsFilterJa extends _StringsFilterEn {
	_StringsFilterJa._(_StringsJa root) : this._root = root, super._(root);

	@override final _StringsJa _root; // ignore: unused_field

	// Translations
	@override String get all => 'すべて';
	@override String get filter => 'フィルター';
	@override String get rating => 'レーティング';
	@override String get tag => 'タグ';
	@override String get tags => 'タグ';
	@override String get date => '日付';
	@override String get general => '一般';
	@override String get ecchi => 'エッチ';
	@override String get select_rating => 'レーティングを選択';
	@override String get select_year => '年を選択';
	@override String get select_month => '月を選択';
}

// Path: search
class _StringsSearchJa extends _StringsSearchEn {
	_StringsSearchJa._(_StringsJa root) : this._root = root, super._(root);

	@override final _StringsJa _root; // ignore: unused_field

	// Translations
	@override String get users => 'ユーザー';
	@override String get search => '検索';
	@override late final _StringsSearchHistoryJa history = _StringsSearchHistoryJa._(_root);
}

// Path: time
class _StringsTimeJa extends _StringsTimeEn {
	_StringsTimeJa._(_StringsJa root) : this._root = root, super._(root);

	@override final _StringsJa _root; // ignore: unused_field

	// Translations
	@override String seconds_ago({required Object time}) => '${time} 秒前';
	@override String minutes_ago({required Object time}) => '${time} 分前';
	@override String hours_ago({required Object time}) => '${time} 時間前';
	@override String days_ago({required Object time}) => '${time} 日前';
}

// Path: media
class _StringsMediaJa extends _StringsMediaEn {
	_StringsMediaJa._(_StringsJa root) : this._root = root, super._(root);

	@override final _StringsJa _root; // ignore: unused_field

	// Translations
	@override String get private => 'プライベート';
	@override String get add_to_playlist => 'プレイリストに追加';
	@override String get external_video => '外部動画';
	@override String get share => '共有';
	@override String get download => 'ダウンロード';
	@override String more_from({required Object username}) => '${username} からのその他';
	@override String get more_like_this => '同様の作品';
	@override String updated_at({required Object time}) => '${time} に更新';
}

// Path: player
class _StringsPlayerJa extends _StringsPlayerEn {
	_StringsPlayerJa._(_StringsJa root) : this._root = root, super._(root);

	@override final _StringsJa _root; // ignore: unused_field

	// Translations
	@override String current_item({required Object item}) => '現在：${item}';
	@override String get quality => '画質';
	@override String get select_quality => '画質を選択';
	@override String get playback_speed => '再生速度';
	@override String get select_playback_speed => '再生速度を選択';
	@override String get aspect_ratio => 'アスペクト比';
	@override String get select_aspect_ratio => 'アスペクト比を選択';
	@override late final _StringsPlayerAspectRatiosJa aspect_ratios = _StringsPlayerAspectRatiosJa._(_root);
	@override String seconds({required Object value}) => '${value} 秒';
	@override String get double_speed => '2 倍';
}

// Path: comment
class _StringsCommentJa extends _StringsCommentEn {
	_StringsCommentJa._(_StringsJa root) : this._root = root, super._(root);

	@override final _StringsJa _root; // ignore: unused_field

	// Translations
	@override String get comment => 'コメント';
	@override String get comments => 'コメント';
	@override String get comment_detail => 'コメントの詳細';
	@override String get edit_comment => 'コメントの編集';
	@override String get delete_comment => 'コメントの削除';
	@override String get reply => '返信';
	@override String replies_in_total({required Object numReply}) => '合計 ${numReply} 件の返信';
	@override String show_all_replies({required Object numReply}) => 'すべての ${numReply} 件の返信を表示';
}

// Path: user
class _StringsUserJa extends _StringsUserEn {
	_StringsUserJa._(_StringsJa root) : this._root = root, super._(root);

	@override final _StringsJa _root; // ignore: unused_field

	// Translations
	@override String get following => 'フォロー中';
	@override String get history => '履歴';
	@override String get blocked_tags => 'ブロックされたタグ';
	@override String get friends => '友達';
	@override String get downloads => 'ダウンロード';
	@override String get favorites => 'お気に入り';
	@override String get playlists => 'プレイリスト';
	@override String get settings => '設定';
	@override String get about => 'について';
}

// Path: friend
class _StringsFriendJa extends _StringsFriendEn {
	_StringsFriendJa._(_StringsJa root) : this._root = root, super._(root);

	@override final _StringsJa _root; // ignore: unused_field

	// Translations
	@override String get friend_requests => '友達リクエスト';
	@override String get add_friend => '友達に追加';
	@override String get pending => '保留中';
	@override String get unfriend => '友達解除';
	@override String get accept => '承認';
	@override String get reject => '拒否';
}

// Path: blocked_tags
class _StringsBlockedTagsJa extends _StringsBlockedTagsEn {
	_StringsBlockedTagsJa._(_StringsJa root) : this._root = root, super._(root);

	@override final _StringsJa _root; // ignore: unused_field

	// Translations
	@override String get add_blocked_tag => 'ブロックされたタグを追加';
	@override String get blocked_tag => 'ブロックされたタグ';
}

// Path: download
class _StringsDownloadJa extends _StringsDownloadEn {
	_StringsDownloadJa._(_StringsJa root) : this._root = root, super._(root);

	@override final _StringsJa _root; // ignore: unused_field

	// Translations
	@override String get create_download_task => 'ダウンロードタスクの作成';
	@override String get unknown => '不明';
	@override String get enqueued => '待機中';
	@override String get downloading => 'ダウンロード中';
	@override String get paused => '一時停止済み';
	@override String get finished => '完了';
	@override String get failed => 'ダウンロード失敗';
	@override String get retry => '再試行';
	@override String get delete => '削除';
	@override String get pause => '一時停止';
	@override String get resume => '再開';
	@override String get open_with => '開く';
	@override String get jump_to_detail => '詳細ページに移動';
}

// Path: playlist
class _StringsPlaylistJa extends _StringsPlaylistEn {
	_StringsPlaylistJa._(_StringsJa root) : this._root = root, super._(root);

	@override final _StringsJa _root; // ignore: unused_field

	// Translations
	@override String get title => 'プレイリストのタイトル';
	@override String get create => 'プレイリストの作成';
	@override String get select => 'プレイリストの選択';
	@override String get edit_title => 'タイトルを編集';
	@override String videos_count({required Object numVideo}) => '${numVideo} 本のビデオ';
	@override String videos_count_plural({required Object numVideo}) => '${numVideo} 本のビデオ';
}

// Path: channel
class _StringsChannelJa extends _StringsChannelEn {
	_StringsChannelJa._(_StringsJa root) : this._root = root, super._(root);

	@override final _StringsJa _root; // ignore: unused_field

	// Translations
	@override String get administration => '管理者';
	@override String get announcements => 'お知らせ';
	@override String get feedback => 'フィードバック';
	@override String get support => 'サポート';
	@override String get global => '一般';
	@override String get general => '一般';
	@override String get guides => 'ガイド';
	@override String get questions => 'ヘルプ/質問';
	@override String get requests => 'リクエスト';
	@override String get sharing => '共有';
	@override String label({required Object numThread, required Object numPosts}) => '${numThread} 本のスレッド ${numPosts} 本の返信';
}

// Path: create_thread
class _StringsCreateThreadJa extends _StringsCreateThreadEn {
	_StringsCreateThreadJa._(_StringsJa root) : this._root = root, super._(root);

	@override final _StringsJa _root; // ignore: unused_field

	// Translations
	@override String get create_thread => 'スレッドの作成';
	@override String get title => 'タイトル';
	@override String get content => '内容';
}

// Path: notifications
class _StringsNotificationsJa extends _StringsNotificationsEn {
	_StringsNotificationsJa._(_StringsJa root) : this._root = root, super._(root);

	@override final _StringsJa _root; // ignore: unused_field

	// Translations
	@override String get ok => 'OK';
	@override String get success => '成功';
	@override String get error => 'エラー';
	@override String get loading => '読み込み中...';
	@override String get cancel => 'キャンセル';
	@override String get confirm => '確認';
	@override String get apply => '適用';
}

// Path: settings
class _StringsSettingsJa extends _StringsSettingsEn {
	_StringsSettingsJa._(_StringsJa root) : this._root = root, super._(root);

	@override final _StringsJa _root; // ignore: unused_field

	// Translations
	@override String get appearance => '外観設定';
	@override String get theme => 'テーマ';
	@override String get theme_desc => 'アプリのテーマを設定します';
	@override String get dynamic_color => 'ダイナミックカラー';
	@override String get dynamic_color_desc => 'コンテンツに応じてアプリの色を変更します';
	@override String get custom_color => 'カスタムカラー';
	@override String get custom_color_desc => 'アプリのテーマカラーをカスタマイズします';
	@override String get language => '言語';
	@override String get language_desc => 'アプリの言語を設定します';
	@override String get display_mode => '表示モード';
	@override String get display_mode_desc => 'アプリの表示モードを設定します';
	@override String get work_mode => '作業モード';
	@override String get work_mode_desc => 'NSFW コンテンツのカバーを非表示にします';
	@override String get network => 'ネットワーク設定';
	@override String get enable_proxy => 'プロキシを有効にする';
	@override String get enable_proxy_desc => 'プロキシサービスを有効にします';
	@override String get proxy => 'プロキシ設定';
	@override String get proxy_desc => 'プロキシサーバーを設定します';
	@override String get player => 'プレイヤー設定';
	@override String get autoplay => '自動再生';
	@override String get autoplay_desc => 'ビデオページを開くときに自動でビデオを再生します';
	@override String get background_play => 'バックグラウンド再生';
	@override String get background_play_desc => 'アプリをバックグラウンドでビデオを再生することを許可します';
	@override String get download => 'ダウンロード設定';
	@override String get download_path => 'ダウンロードパス';
	@override String get allow_media_scan => 'メディアスキャンを許可';
	@override String get allow_media_scan_desc => 'ダウンロードしたメディアファイルをメディアスキャンアプリに読み取らせることを許可します';
	@override String get logging => 'ログ';
	@override String get enable_logging => 'ログを有効にする';
	@override String get enable_logging_desc => 'アプリのログを有効にします';
	@override String get clear_log => 'ログをクリア';
	@override String clear_log_desc({required Object size}) => '現在のログサイズ：${size}';
	@override String get enable_verbose_logging => '詳細なログを有効にする';
	@override String get enable_verbose_logging_desc => 'より詳細なログを記録します';
	@override String get about => '情報';
	@override String get check_update => '更新を確認';
	@override String get check_update_desc => '新しいバージョンが利用可能かどうかを確認します';
	@override String get third_party_license => 'サードパーティのライセンス';
	@override String get third_party_license_desc => 'サードパーティのライブラリのライセンスを確認します';
}

// Path: theme
class _StringsThemeJa extends _StringsThemeEn {
	_StringsThemeJa._(_StringsJa root) : this._root = root, super._(root);

	@override final _StringsJa _root; // ignore: unused_field

	// Translations
	@override String get system => 'システムに従う';
	@override String get light => 'ライト';
	@override String get dark => 'ダーク';
}

// Path: colors
class _StringsColorsJa extends _StringsColorsEn {
	_StringsColorsJa._(_StringsJa root) : this._root = root, super._(root);

	@override final _StringsJa _root; // ignore: unused_field

	// Translations
	@override String get pink => 'ピンク';
	@override String get red => '赤';
	@override String get orange => 'オレンジ';
	@override String get amber => 'アンバー';
	@override String get yellow => '黄';
	@override String get lime => 'ライム';
	@override String get lightGreen => 'ライトグリーン';
	@override String get green => '緑';
	@override String get teal => 'ティール';
	@override String get cyan => 'シアン';
	@override String get lightBlue => 'ライトブルー';
	@override String get blue => '青';
	@override String get indigo => 'インディゴ';
	@override String get purple => '紫';
	@override String get deepPurple => 'ディープパープル';
	@override String get blueGrey => 'ブルーグレー';
	@override String get brown => '茶色';
	@override String get grey => 'グレー';
}

// Path: display_mode
class _StringsDisplayModeJa extends _StringsDisplayModeEn {
	_StringsDisplayModeJa._(_StringsJa root) : this._root = root, super._(root);

	@override final _StringsJa _root; // ignore: unused_field

	// Translations
	@override String get no_available => '利用可能な表示モードはありません';
	@override String get auto => '自動';
	@override String get system => 'システム';
}

// Path: proxy
class _StringsProxyJa extends _StringsProxyEn {
	_StringsProxyJa._(_StringsJa root) : this._root = root, super._(root);

	@override final _StringsJa _root; // ignore: unused_field

	// Translations
	@override String get host => 'ホスト名';
	@override String get port => 'ポート';
}

// Path: message
class _StringsMessageJa extends _StringsMessageEn {
	_StringsMessageJa._(_StringsJa root) : this._root = root, super._(root);

	@override final _StringsJa _root; // ignore: unused_field

	// Translations
	@override String get exit_app => 'アプリを終了するにはもう一度押してください';
	@override String get are_you_sure_to_do_that => 'それを行うことを確認していますか？';
	@override String get restart_required => '再起動後に有効';
	@override String get please_type_host => 'ホスト名を入力してください';
	@override String get please_type_port => 'ポートを入力してください';
	@override late final _StringsMessageAccountJa account = _StringsMessageAccountJa._(_root);
	@override late final _StringsMessageCommentJa comment = _StringsMessageCommentJa._(_root);
	@override late final _StringsMessageCreateThreadJa create_thread = _StringsMessageCreateThreadJa._(_root);
	@override late final _StringsMessageBlockedTagsJa blocked_tags = _StringsMessageBlockedTagsJa._(_root);
	@override late final _StringsMessagePlaylistJa playlist = _StringsMessagePlaylistJa._(_root);
	@override late final _StringsMessageDownloadJa download = _StringsMessageDownloadJa._(_root);
	@override late final _StringsMessageUpdateJa update = _StringsMessageUpdateJa._(_root);
}

// Path: error
class _StringsErrorJa extends _StringsErrorEn {
	_StringsErrorJa._(_StringsJa root) : this._root = root, super._(root);

	@override final _StringsJa _root; // ignore: unused_field

	// Translations
	@override String get retry => '読み込みに失敗しました。再試行する';
	@override String get fetch_failed => 'ビデオリンクを取得できません';
	@override String get fetch_user_info_failed => 'ユーザー情報を取得できません';
	@override String get invalid_path => '無効なパス';
	@override late final _StringsErrorAccountJa account = _StringsErrorAccountJa._(_root);
}

// Path: search.history
class _StringsSearchHistoryJa extends _StringsSearchHistoryEn {
	_StringsSearchHistoryJa._(_StringsJa root) : this._root = root, super._(root);

	@override final _StringsJa _root; // ignore: unused_field

	// Translations
	@override String get delete => 'すべての記録を削除';
}

// Path: player.aspect_ratios
class _StringsPlayerAspectRatiosJa extends _StringsPlayerAspectRatiosEn {
	_StringsPlayerAspectRatiosJa._(_StringsJa root) : this._root = root, super._(root);

	@override final _StringsJa _root; // ignore: unused_field

	// Translations
	@override String get contain => '含む';
	@override String get cover => 'カバー';
	@override String get fill => 'フィル';
	@override String get fit_height => '高さに合わせる';
	@override String get fit_width => '幅に合わせる';
	@override String get scale_down => '縮小';
}

// Path: message.account
class _StringsMessageAccountJa extends _StringsMessageAccountEn {
	_StringsMessageAccountJa._(_StringsJa root) : this._root = root, super._(root);

	@override final _StringsJa _root; // ignore: unused_field

	// Translations
	@override String get login_success => 'ログイン成功！';
	@override String get register_success => '登録が成功しました。メールでアカウントを有効にしてください。';
	@override String get login_password_longer_than_6 => 'パスワードは少なくとも6文字である必要があります';
	@override String get please_type_email => 'メールアドレスを入力してください';
	@override String get please_type_email_or_username => 'メールアドレスまたはユーザー名を入力してください';
	@override String get please_type_valid_email => '正しいメールアドレスを入力してください';
	@override String get please_type_password => 'パスワードを入力してください';
	@override String get please_type_captcha => 'キャプチャを入力してください';
}

// Path: message.comment
class _StringsMessageCommentJa extends _StringsMessageCommentEn {
	_StringsMessageCommentJa._(_StringsJa root) : this._root = root, super._(root);

	@override final _StringsJa _root; // ignore: unused_field

	// Translations
	@override String get content_empty => '内容は空であってはいけません。';
	@override String get content_too_long => '内容は1000文字を超えてはいけません。';
	@override String get sent => '返信が送信されました。';
}

// Path: message.create_thread
class _StringsMessageCreateThreadJa extends _StringsMessageCreateThreadEn {
	_StringsMessageCreateThreadJa._(_StringsJa root) : this._root = root, super._(root);

	@override final _StringsJa _root; // ignore: unused_field

	// Translations
	@override String get title_empty => 'タイトルは空であってはいけません。';
	@override String get title_too_long => 'タイトルは長すぎてはいけません。';
	@override String get content_empty => '内容は空であってはいけません。';
	@override String get content_too_long => '内容は20000文字を超えてはいけません。';
	@override String get created => 'スレッドが送信されました。';
}

// Path: message.blocked_tags
class _StringsMessageBlockedTagsJa extends _StringsMessageBlockedTagsEn {
	_StringsMessageBlockedTagsJa._(_StringsJa root) : this._root = root, super._(root);

	@override final _StringsJa _root; // ignore: unused_field

	// Translations
	@override String get save_confirm => 'タグのブロックを保存しますか？';
	@override String get saved => 'ブロックされたタグが保存されました。';
	@override String get reached_limit => 'ブロックされたタグの数が上限に達しました。';
}

// Path: message.playlist
class _StringsMessagePlaylistJa extends _StringsMessagePlaylistEn {
	_StringsMessagePlaylistJa._(_StringsJa root) : this._root = root, super._(root);

	@override final _StringsJa _root; // ignore: unused_field

	// Translations
	@override String get empty_playlist_title => 'プレイリストのタイトルは空であってはいけません。';
	@override String get playlist_created => 'プレイリストが作成されました。';
	@override String get playlist_title_edited => 'プレイリストのタイトルが編集されました。';
}

// Path: message.download
class _StringsMessageDownloadJa extends _StringsMessageDownloadEn {
	_StringsMessageDownloadJa._(_StringsJa root) : this._root = root, super._(root);

	@override final _StringsJa _root; // ignore: unused_field

	// Translations
	@override String get no_provide_storage_permission => 'ストレージの許可がありません。';
	@override String get task_already_exists => 'ダウンロードタスクはすでに存在します。';
	@override String get task_created => 'ダウンロードタスクが作成されました。';
	@override String get maximum_simultaneous_download_reached => '最大同時ダウンロード数に達しました。';
}

// Path: message.update
class _StringsMessageUpdateJa extends _StringsMessageUpdateEn {
	_StringsMessageUpdateJa._(_StringsJa root) : this._root = root, super._(root);

	@override final _StringsJa _root; // ignore: unused_field

	// Translations
	@override String get check_update_failed => '更新の確認に失敗しました';
	@override String get update_available => '新しいバージョンが利用可能です';
	@override String get already_latest_version => 'すでに最新バージョンです';
	@override String current_version({required Object version}) => '現在のバージョン：${version}';
	@override String latest_version({required Object version}) => '最新バージョン：${version}';
	@override String get view_update => '更新を表示';
}

// Path: error.account
class _StringsErrorAccountJa extends _StringsErrorAccountEn {
	_StringsErrorAccountJa._(_StringsJa root) : this._root = root, super._(root);

	@override final _StringsJa _root; // ignore: unused_field

	// Translations
	@override String get invalid_login => '無効なメールアドレスまたはパスワード';
	@override String get invalid_host => '無効なホスト名';
	@override String get invalid_captcha => '無効なキャプチャ';
}

// Path: <root>
class _StringsZhCn extends Translations {
	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	_StringsZhCn.build({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  $meta = TranslationMetadata(
		    locale: AppLocale.zhCn,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ),
		  super.build(cardinalResolver: cardinalResolver, ordinalResolver: ordinalResolver) {
		super.$meta.setFlatMapFunction($meta.getTranslation); // copy base translations to super.$meta
		$meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <zh-CN>.
	@override final TranslationMetadata<AppLocale, Translations> $meta;

	/// Access flat map
	@override dynamic operator[](String key) => $meta.getTranslation(key) ?? super.$meta.getTranslation(key);

	@override late final _StringsZhCn _root = this; // ignore: unused_field

	// Translations
	@override late final _StringsNavZhCn nav = _StringsNavZhCn._(_root);
	@override late final _StringsRulesZhCn rules = _StringsRulesZhCn._(_root);
	@override late final _StringsCommonZhCn common = _StringsCommonZhCn._(_root);
	@override late final _StringsRefreshZhCn refresh = _StringsRefreshZhCn._(_root);
	@override late final _StringsRecordsZhCn records = _StringsRecordsZhCn._(_root);
	@override late final _StringsAccountZhCn account = _StringsAccountZhCn._(_root);
	@override late final _StringsProfileZhCn profile = _StringsProfileZhCn._(_root);
	@override late final _StringsSortZhCn sort = _StringsSortZhCn._(_root);
	@override late final _StringsFilterZhCn filter = _StringsFilterZhCn._(_root);
	@override late final _StringsSearchZhCn search = _StringsSearchZhCn._(_root);
	@override late final _StringsTimeZhCn time = _StringsTimeZhCn._(_root);
	@override late final _StringsMediaZhCn media = _StringsMediaZhCn._(_root);
	@override late final _StringsPlayerZhCn player = _StringsPlayerZhCn._(_root);
	@override late final _StringsCommentZhCn comment = _StringsCommentZhCn._(_root);
	@override late final _StringsUserZhCn user = _StringsUserZhCn._(_root);
	@override late final _StringsFriendZhCn friend = _StringsFriendZhCn._(_root);
	@override late final _StringsBlockedTagsZhCn blocked_tags = _StringsBlockedTagsZhCn._(_root);
	@override late final _StringsDownloadZhCn download = _StringsDownloadZhCn._(_root);
	@override late final _StringsPlaylistZhCn playlist = _StringsPlaylistZhCn._(_root);
	@override late final _StringsChannelZhCn channel = _StringsChannelZhCn._(_root);
	@override late final _StringsCreateThreadZhCn create_thread = _StringsCreateThreadZhCn._(_root);
	@override late final _StringsNotificationsZhCn notifications = _StringsNotificationsZhCn._(_root);
	@override late final _StringsSettingsZhCn settings = _StringsSettingsZhCn._(_root);
	@override late final _StringsThemeZhCn theme = _StringsThemeZhCn._(_root);
	@override late final _StringsColorsZhCn colors = _StringsColorsZhCn._(_root);
	@override late final _StringsDisplayModeZhCn display_mode = _StringsDisplayModeZhCn._(_root);
	@override late final _StringsProxyZhCn proxy = _StringsProxyZhCn._(_root);
	@override late final _StringsMessageZhCn message = _StringsMessageZhCn._(_root);
	@override late final _StringsErrorZhCn error = _StringsErrorZhCn._(_root);
}

// Path: nav
class _StringsNavZhCn extends _StringsNavEn {
	_StringsNavZhCn._(_StringsZhCn root) : this._root = root, super._(root);

	@override final _StringsZhCn _root; // ignore: unused_field

	// Translations
	@override String get subscriptions => '订阅';
	@override String get videos => '视频';
	@override String get images => '图片';
	@override String get forum => '论坛';
	@override String get search => '搜索';
}

// Path: rules
class _StringsRulesZhCn extends _StringsRulesEn {
	_StringsRulesZhCn._(_StringsZhCn root) : this._root = root, super._(root);

	@override final _StringsZhCn _root; // ignore: unused_field

	// Translations
	@override String get title => '规则';
	@override String get accept => '接受';
	@override String get accept_desc => '我同意：已阅读规则并且会随时留意未来的规则变更。';
}

// Path: common
class _StringsCommonZhCn extends _StringsCommonEn {
	_StringsCommonZhCn._(_StringsZhCn root) : this._root = root, super._(root);

	@override final _StringsZhCn _root; // ignore: unused_field

	// Translations
	@override String get video => '视频';
	@override String get image => '图片';
	@override String get collapse => '收起';
	@override String get expand => '展开';
	@override String get translate => '翻译';
	@override String get open => '打开';
}

// Path: refresh
class _StringsRefreshZhCn extends _StringsRefreshEn {
	_StringsRefreshZhCn._(_StringsZhCn root) : this._root = root, super._(root);

	@override final _StringsZhCn _root; // ignore: unused_field

	// Translations
	@override String get empty => '空空如也';
	@override String get drag_to_load => '下拉加载';
	@override String get release_to_load => '释放加载';
	@override String get success => '加载成功';
	@override String get failed => '加载失败';
	@override String get no_more => '没有更多了';
	@override String get last_load => '上次加载于 %T';
}

// Path: records
class _StringsRecordsZhCn extends _StringsRecordsEn {
	_StringsRecordsZhCn._(_StringsZhCn root) : this._root = root, super._(root);

	@override final _StringsZhCn _root; // ignore: unused_field

	// Translations
	@override String get select_all => '全选';
	@override String get select_inverse => '反选';
	@override String selected_num({required Object num}) => '已选 ${num} 项';
	@override String get multiple_selection_mode => '多选模式';
	@override String get delete => '删除';
	@override String get delete_all => '删除所有';
}

// Path: account
class _StringsAccountZhCn extends _StringsAccountEn {
	_StringsAccountZhCn._(_StringsZhCn root) : this._root = root, super._(root);

	@override final _StringsZhCn _root; // ignore: unused_field

	// Translations
	@override String get captcha => '验证码';
	@override String get login => '登录';
	@override String get logout => '登出';
	@override String get register => '注册';
	@override String get email => '邮箱';
	@override String get email_or_username => '邮箱或用户名';
	@override String get password => '密码';
	@override String get forgot_password => '忘记密码';
	@override String get require_login => '请先登录';
}

// Path: profile
class _StringsProfileZhCn extends _StringsProfileEn {
	_StringsProfileZhCn._(_StringsZhCn root) : this._root = root, super._(root);

	@override final _StringsZhCn _root; // ignore: unused_field

	// Translations
	@override String get profile => '个人资料';
	@override String get follow => '关注';
	@override String get followers => '粉丝';
	@override String get following => '关注中';
	@override String get nickname => '昵称';
	@override String get username => '用户名';
	@override String get user_id => '用户 ID';
	@override String get description => '个人简介';
	@override String get no_description => '该用户是个神秘人，不喜欢被人围观。';
	@override String get join_date => '加入时间';
	@override String get last_active_time => '最后在线时间';
	@override String get online => '在线';
	@override String get message => '私信';
	@override String get guestbook => '留言板';
	@override String get view_more => '查看更多';
}

// Path: sort
class _StringsSortZhCn extends _StringsSortEn {
	_StringsSortZhCn._(_StringsZhCn root) : this._root = root, super._(root);

	@override final _StringsZhCn _root; // ignore: unused_field

	// Translations
	@override String get latest => '最新';
	@override String get trending => '流行';
	@override String get popularity => '人气';
	@override String get most_views => '最多观看';
	@override String get most_likes => '最多点赞';
}

// Path: filter
class _StringsFilterZhCn extends _StringsFilterEn {
	_StringsFilterZhCn._(_StringsZhCn root) : this._root = root, super._(root);

	@override final _StringsZhCn _root; // ignore: unused_field

	// Translations
	@override String get all => '全部';
	@override String get filter => '筛选';
	@override String get rating => '分级';
	@override String get tag => '标签';
	@override String get tags => '标签';
	@override String get date => '日期';
	@override String get general => '全年龄';
	@override String get ecchi => '成人';
	@override String get select_rating => '选择分级';
	@override String get select_year => '选择年份';
	@override String get select_month => '选择月份';
}

// Path: search
class _StringsSearchZhCn extends _StringsSearchEn {
	_StringsSearchZhCn._(_StringsZhCn root) : this._root = root, super._(root);

	@override final _StringsZhCn _root; // ignore: unused_field

	// Translations
	@override String get users => '用户';
	@override String get search => '搜索';
	@override late final _StringsSearchHistoryZhCn history = _StringsSearchHistoryZhCn._(_root);
}

// Path: time
class _StringsTimeZhCn extends _StringsTimeEn {
	_StringsTimeZhCn._(_StringsZhCn root) : this._root = root, super._(root);

	@override final _StringsZhCn _root; // ignore: unused_field

	// Translations
	@override String seconds_ago({required Object time}) => '${time} 秒前';
	@override String minutes_ago({required Object time}) => '${time} 分钟前';
	@override String hours_ago({required Object time}) => '${time} 小时前';
	@override String days_ago({required Object time}) => '${time} 天前';
}

// Path: media
class _StringsMediaZhCn extends _StringsMediaEn {
	_StringsMediaZhCn._(_StringsZhCn root) : this._root = root, super._(root);

	@override final _StringsZhCn _root; // ignore: unused_field

	// Translations
	@override String get private => '私有';
	@override String get add_to_playlist => '添加到播放列表';
	@override String get external_video => '外部视频';
	@override String get share => '分享';
	@override String get download => '下载';
	@override String more_from({required Object username}) => '更多来自 ${username}';
	@override String get more_like_this => '类似作品';
	@override String updated_at({required Object time}) => '更新于 ${time}';
}

// Path: player
class _StringsPlayerZhCn extends _StringsPlayerEn {
	_StringsPlayerZhCn._(_StringsZhCn root) : this._root = root, super._(root);

	@override final _StringsZhCn _root; // ignore: unused_field

	// Translations
	@override String current_item({required Object item}) => '当前: ${item}';
	@override String get quality => '画质';
	@override String get select_quality => '选择画质';
	@override String get playback_speed => '播放速度';
	@override String get select_playback_speed => '选择播放速度';
	@override String get aspect_ratio => '宽高比';
	@override String get select_aspect_ratio => '选择宽高比';
	@override late final _StringsPlayerAspectRatiosZhCn aspect_ratios = _StringsPlayerAspectRatiosZhCn._(_root);
	@override String seconds({required Object value}) => '${value} 秒';
	@override String get double_speed => '2 倍';
}

// Path: comment
class _StringsCommentZhCn extends _StringsCommentEn {
	_StringsCommentZhCn._(_StringsZhCn root) : this._root = root, super._(root);

	@override final _StringsZhCn _root; // ignore: unused_field

	// Translations
	@override String get comment => '评论';
	@override String get comments => '评论';
	@override String get comment_detail => '评论详情';
	@override String get edit_comment => '编辑评论';
	@override String get delete_comment => '删除评论';
	@override String get reply => '回复';
	@override String replies_in_total({required Object numReply}) => '共 ${numReply} 条回复';
	@override String show_all_replies({required Object numReply}) => '显示全部 ${numReply} 条回复';
}

// Path: user
class _StringsUserZhCn extends _StringsUserEn {
	_StringsUserZhCn._(_StringsZhCn root) : this._root = root, super._(root);

	@override final _StringsZhCn _root; // ignore: unused_field

	// Translations
	@override String get following => '关注中';
	@override String get history => '历史记录';
	@override String get blocked_tags => '屏蔽标签';
	@override String get friends => '好友';
	@override String get downloads => '缓存';
	@override String get favorites => '收藏';
	@override String get playlists => '播放列表';
	@override String get settings => '设置';
	@override String get about => '关于';
}

// Path: friend
class _StringsFriendZhCn extends _StringsFriendEn {
	_StringsFriendZhCn._(_StringsZhCn root) : this._root = root, super._(root);

	@override final _StringsZhCn _root; // ignore: unused_field

	// Translations
	@override String get friend_requests => '好友请求';
	@override String get add_friend => '添加好友';
	@override String get pending => '待处理';
	@override String get unfriend => '解除好友';
	@override String get accept => '接受';
	@override String get reject => '拒绝';
}

// Path: blocked_tags
class _StringsBlockedTagsZhCn extends _StringsBlockedTagsEn {
	_StringsBlockedTagsZhCn._(_StringsZhCn root) : this._root = root, super._(root);

	@override final _StringsZhCn _root; // ignore: unused_field

	// Translations
	@override String get add_blocked_tag => '添加屏蔽标签';
	@override String get blocked_tag => '屏蔽标签';
}

// Path: download
class _StringsDownloadZhCn extends _StringsDownloadEn {
	_StringsDownloadZhCn._(_StringsZhCn root) : this._root = root, super._(root);

	@override final _StringsZhCn _root; // ignore: unused_field

	// Translations
	@override String get create_download_task => '创建下载任务';
	@override String get unknown => '未知';
	@override String get enqueued => '等待中';
	@override String get downloading => '下载中';
	@override String get paused => '已暂停';
	@override String get finished => '已完成';
	@override String get failed => '下载失败';
	@override String get retry => '重新下载';
	@override String get delete => '删除下载任务';
	@override String get pause => '暂停';
	@override String get resume => '继续';
	@override String get open_with => '用...打开';
	@override String get jump_to_detail => '查看详情页';
}

// Path: playlist
class _StringsPlaylistZhCn extends _StringsPlaylistEn {
	_StringsPlaylistZhCn._(_StringsZhCn root) : this._root = root, super._(root);

	@override final _StringsZhCn _root; // ignore: unused_field

	// Translations
	@override String get title => '播放列表标题';
	@override String get create => '创建播放列表';
	@override String get select => '选择播放列表';
	@override String get edit_title => '编辑标题';
	@override String videos_count({required Object numVideo}) => '${numVideo} 个视频';
	@override String videos_count_plural({required Object numVideo}) => '${numVideo} 个视频';
}

// Path: channel
class _StringsChannelZhCn extends _StringsChannelEn {
	_StringsChannelZhCn._(_StringsZhCn root) : this._root = root, super._(root);

	@override final _StringsZhCn _root; // ignore: unused_field

	// Translations
	@override String get administration => '管理者';
	@override String get announcements => '公告';
	@override String get feedback => '反馈';
	@override String get support => '支持';
	@override String get global => '常规';
	@override String get general => '普通';
	@override String get guides => '指南';
	@override String get questions => '帮助/问题';
	@override String get requests => '请求';
	@override String get sharing => '分享';
	@override String label({required Object numThread, required Object numPosts}) => '${numThread} 个帖子 ${numPosts} 个回复';
}

// Path: create_thread
class _StringsCreateThreadZhCn extends _StringsCreateThreadEn {
	_StringsCreateThreadZhCn._(_StringsZhCn root) : this._root = root, super._(root);

	@override final _StringsZhCn _root; // ignore: unused_field

	// Translations
	@override String get create_thread => '发帖';
	@override String get title => '标题';
	@override String get content => '内容';
}

// Path: notifications
class _StringsNotificationsZhCn extends _StringsNotificationsEn {
	_StringsNotificationsZhCn._(_StringsZhCn root) : this._root = root, super._(root);

	@override final _StringsZhCn _root; // ignore: unused_field

	// Translations
	@override String get ok => '好的';
	@override String get success => '成功';
	@override String get error => '错误';
	@override String get loading => '加载中...';
	@override String get cancel => '取消';
	@override String get confirm => '确认';
	@override String get apply => '应用';
}

// Path: settings
class _StringsSettingsZhCn extends _StringsSettingsEn {
	_StringsSettingsZhCn._(_StringsZhCn root) : this._root = root, super._(root);

	@override final _StringsZhCn _root; // ignore: unused_field

	// Translations
	@override String get appearance => '外观设置';
	@override String get theme => '主题';
	@override String get theme_desc => '设置应用的主题';
	@override String get dynamic_color => '动态取色';
	@override String get dynamic_color_desc => '根据内容动态更改应用的颜色';
	@override String get custom_color => '自定义颜色';
	@override String get custom_color_desc => '自定义应用的主题色';
	@override String get language => '语言';
	@override String get language_desc => '设置应用的语言';
	@override String get display_mode => '显示模式';
	@override String get display_mode_desc => '设置应用的显示模式';
	@override String get work_mode => '工作模式';
	@override String get work_mode_desc => '隐藏所有 NSFW 内容的封面';
	@override String get network => '网络设置';
	@override String get enable_proxy => '启用代理';
	@override String get enable_proxy_desc => '启用代理服务';
	@override String get proxy => '代理设置';
	@override String get proxy_desc => '设置代理服务器';
	@override String get player => '播放器设置';
	@override String get autoplay => '自动播放';
	@override String get autoplay_desc => '打开视频页面时自动播放视频';
	@override String get background_play => '后台播放';
	@override String get background_play_desc => '允许应用在后台播放视频';
	@override String get download => '下载设置';
	@override String get download_path => '下载路径';
	@override String get allow_media_scan => '允许媒体扫描';
	@override String get allow_media_scan_desc => '允许媒体扫描程序读取下载的媒体文件';
	@override String get logging => '日志设置';
	@override String get enable_logging => '启用日志';
	@override String get enable_logging_desc => '启用应用的日志记录';
	@override String get clear_log => '清除日志';
	@override String clear_log_desc({required Object size}) => '当前日志大小: ${size}';
	@override String get enable_verbose_logging => '启用详细日志';
	@override String get enable_verbose_logging_desc => '记录更详细的日志';
	@override String get about => '关于';
	@override String get check_update => '检查更新';
	@override String get check_update_desc => '检查是否有新版本可用';
	@override String get third_party_license => '第三方库许可';
	@override String get third_party_license_desc => '查看第三方库的许可证';
}

// Path: theme
class _StringsThemeZhCn extends _StringsThemeEn {
	_StringsThemeZhCn._(_StringsZhCn root) : this._root = root, super._(root);

	@override final _StringsZhCn _root; // ignore: unused_field

	// Translations
	@override String get system => '跟随系统';
	@override String get light => '浅色';
	@override String get dark => '深色';
}

// Path: colors
class _StringsColorsZhCn extends _StringsColorsEn {
	_StringsColorsZhCn._(_StringsZhCn root) : this._root = root, super._(root);

	@override final _StringsZhCn _root; // ignore: unused_field

	// Translations
	@override String get pink => '粉红';
	@override String get red => '红色';
	@override String get orange => '橙色';
	@override String get amber => '琥珀';
	@override String get yellow => '黄色';
	@override String get lime => '绿黄';
	@override String get lightGreen => '浅绿';
	@override String get green => '绿色';
	@override String get teal => '青色';
	@override String get cyan => '青绿';
	@override String get lightBlue => '浅蓝';
	@override String get blue => '蓝色';
	@override String get indigo => '靛蓝';
	@override String get purple => '紫色';
	@override String get deepPurple => '深紫';
	@override String get blueGrey => '蓝灰';
	@override String get brown => '棕色';
	@override String get grey => '灰色';
}

// Path: display_mode
class _StringsDisplayModeZhCn extends _StringsDisplayModeEn {
	_StringsDisplayModeZhCn._(_StringsZhCn root) : this._root = root, super._(root);

	@override final _StringsZhCn _root; // ignore: unused_field

	// Translations
	@override String get no_available => '无可用显示模式';
	@override String get auto => '自动';
	@override String get system => '系统';
}

// Path: proxy
class _StringsProxyZhCn extends _StringsProxyEn {
	_StringsProxyZhCn._(_StringsZhCn root) : this._root = root, super._(root);

	@override final _StringsZhCn _root; // ignore: unused_field

	// Translations
	@override String get host => '主机名';
	@override String get port => '端口';
}

// Path: message
class _StringsMessageZhCn extends _StringsMessageEn {
	_StringsMessageZhCn._(_StringsZhCn root) : this._root = root, super._(root);

	@override final _StringsZhCn _root; // ignore: unused_field

	// Translations
	@override String get exit_app => '再按一次退出应用';
	@override String get are_you_sure_to_do_that => '你确定要这么做吗？';
	@override String get restart_required => '重启后生效';
	@override String get please_type_host => '请输入主机名';
	@override String get please_type_port => '请输入端口';
	@override late final _StringsMessageAccountZhCn account = _StringsMessageAccountZhCn._(_root);
	@override late final _StringsMessageCommentZhCn comment = _StringsMessageCommentZhCn._(_root);
	@override late final _StringsMessageCreateThreadZhCn create_thread = _StringsMessageCreateThreadZhCn._(_root);
	@override late final _StringsMessageBlockedTagsZhCn blocked_tags = _StringsMessageBlockedTagsZhCn._(_root);
	@override late final _StringsMessagePlaylistZhCn playlist = _StringsMessagePlaylistZhCn._(_root);
	@override late final _StringsMessageDownloadZhCn download = _StringsMessageDownloadZhCn._(_root);
	@override late final _StringsMessageUpdateZhCn update = _StringsMessageUpdateZhCn._(_root);
}

// Path: error
class _StringsErrorZhCn extends _StringsErrorEn {
	_StringsErrorZhCn._(_StringsZhCn root) : this._root = root, super._(root);

	@override final _StringsZhCn _root; // ignore: unused_field

	// Translations
	@override String get retry => '加载失败，点击重试';
	@override String get fetch_failed => '无法获取视频链接';
	@override String get fetch_user_info_failed => '无法获取用户信息';
	@override String get invalid_path => '无效的路径';
	@override late final _StringsErrorAccountZhCn account = _StringsErrorAccountZhCn._(_root);
}

// Path: search.history
class _StringsSearchHistoryZhCn extends _StringsSearchHistoryEn {
	_StringsSearchHistoryZhCn._(_StringsZhCn root) : this._root = root, super._(root);

	@override final _StringsZhCn _root; // ignore: unused_field

	// Translations
	@override String get delete => '删除所有记录';
}

// Path: player.aspect_ratios
class _StringsPlayerAspectRatiosZhCn extends _StringsPlayerAspectRatiosEn {
	_StringsPlayerAspectRatiosZhCn._(_StringsZhCn root) : this._root = root, super._(root);

	@override final _StringsZhCn _root; // ignore: unused_field

	// Translations
	@override String get contain => '包含';
	@override String get cover => '覆盖';
	@override String get fill => '填充';
	@override String get fit_height => '适应高度';
	@override String get fit_width => '适应宽度';
	@override String get scale_down => '缩小适应';
}

// Path: message.account
class _StringsMessageAccountZhCn extends _StringsMessageAccountEn {
	_StringsMessageAccountZhCn._(_StringsZhCn root) : this._root = root, super._(root);

	@override final _StringsZhCn _root; // ignore: unused_field

	// Translations
	@override String get login_success => '登入成功！';
	@override String get register_success => '注册成功，请查看邮箱激活账号。';
	@override String get login_password_longer_than_6 => '密码长度至少为 6 位';
	@override String get please_type_email => '请输入邮箱';
	@override String get please_type_email_or_username => '请输入邮箱或用户名';
	@override String get please_type_valid_email => '请输入正确的邮箱';
	@override String get please_type_password => '请输入密码';
	@override String get please_type_captcha => '请输入验证码';
}

// Path: message.comment
class _StringsMessageCommentZhCn extends _StringsMessageCommentEn {
	_StringsMessageCommentZhCn._(_StringsZhCn root) : this._root = root, super._(root);

	@override final _StringsZhCn _root; // ignore: unused_field

	// Translations
	@override String get content_empty => '内容不能为空。';
	@override String get content_too_long => '内容不能超过 1000 个字符。';
	@override String get sent => '回复已发送。';
}

// Path: message.create_thread
class _StringsMessageCreateThreadZhCn extends _StringsMessageCreateThreadEn {
	_StringsMessageCreateThreadZhCn._(_StringsZhCn root) : this._root = root, super._(root);

	@override final _StringsZhCn _root; // ignore: unused_field

	// Translations
	@override String get title_empty => '标题不能为空。';
	@override String get title_too_long => '标题不能过长。';
	@override String get content_empty => '内容不能为空。';
	@override String get content_too_long => '内容不能超过 20000 个字符。';
	@override String get created => '帖子已发送。';
}

// Path: message.blocked_tags
class _StringsMessageBlockedTagsZhCn extends _StringsMessageBlockedTagsEn {
	_StringsMessageBlockedTagsZhCn._(_StringsZhCn root) : this._root = root, super._(root);

	@override final _StringsZhCn _root; // ignore: unused_field

	// Translations
	@override String get save_confirm => '确定保存屏蔽标签吗？';
	@override String get saved => '屏蔽标签已保存。';
	@override String get reached_limit => '屏蔽标签数量已达到上限。';
}

// Path: message.playlist
class _StringsMessagePlaylistZhCn extends _StringsMessagePlaylistEn {
	_StringsMessagePlaylistZhCn._(_StringsZhCn root) : this._root = root, super._(root);

	@override final _StringsZhCn _root; // ignore: unused_field

	// Translations
	@override String get empty_playlist_title => '播放列表标题不能为空。';
	@override String get playlist_created => '播放列表已创建。';
	@override String get playlist_title_edited => '播放列表标题已修改。';
}

// Path: message.download
class _StringsMessageDownloadZhCn extends _StringsMessageDownloadEn {
	_StringsMessageDownloadZhCn._(_StringsZhCn root) : this._root = root, super._(root);

	@override final _StringsZhCn _root; // ignore: unused_field

	// Translations
	@override String get no_provide_storage_permission => '未提供存储权限。';
	@override String get task_already_exists => '下载任务已存在。';
	@override String get task_created => '下载任务已创建。';
	@override String get maximum_simultaneous_download_reached => '已达到最大同时下载数。';
}

// Path: message.update
class _StringsMessageUpdateZhCn extends _StringsMessageUpdateEn {
	_StringsMessageUpdateZhCn._(_StringsZhCn root) : this._root = root, super._(root);

	@override final _StringsZhCn _root; // ignore: unused_field

	// Translations
	@override String get check_update_failed => '检查更新失败';
	@override String get update_available => '有新版本可用';
	@override String get already_latest_version => '已是最新版本';
	@override String current_version({required Object version}) => '当前版本：${version}';
	@override String latest_version({required Object version}) => '最新版本：${version}';
	@override String get view_update => '查看更新';
}

// Path: error.account
class _StringsErrorAccountZhCn extends _StringsErrorAccountEn {
	_StringsErrorAccountZhCn._(_StringsZhCn root) : this._root = root, super._(root);

	@override final _StringsZhCn _root; // ignore: unused_field

	// Translations
	@override String get invalid_login => '邮箱或密码错误';
	@override String get invalid_host => '无效的主机名';
	@override String get invalid_captcha => '验证码错误';
}

// Path: <root>
class _StringsZhTw extends Translations {
	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	_StringsZhTw.build({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  $meta = TranslationMetadata(
		    locale: AppLocale.zhTw,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ),
		  super.build(cardinalResolver: cardinalResolver, ordinalResolver: ordinalResolver) {
		super.$meta.setFlatMapFunction($meta.getTranslation); // copy base translations to super.$meta
		$meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <zh-TW>.
	@override final TranslationMetadata<AppLocale, Translations> $meta;

	/// Access flat map
	@override dynamic operator[](String key) => $meta.getTranslation(key) ?? super.$meta.getTranslation(key);

	@override late final _StringsZhTw _root = this; // ignore: unused_field

	// Translations
	@override late final _StringsNavZhTw nav = _StringsNavZhTw._(_root);
	@override late final _StringsRulesZhTw rules = _StringsRulesZhTw._(_root);
	@override late final _StringsCommonZhTw common = _StringsCommonZhTw._(_root);
	@override late final _StringsRefreshZhTw refresh = _StringsRefreshZhTw._(_root);
	@override late final _StringsRecordsZhTw records = _StringsRecordsZhTw._(_root);
	@override late final _StringsAccountZhTw account = _StringsAccountZhTw._(_root);
	@override late final _StringsProfileZhTw profile = _StringsProfileZhTw._(_root);
	@override late final _StringsSortZhTw sort = _StringsSortZhTw._(_root);
	@override late final _StringsFilterZhTw filter = _StringsFilterZhTw._(_root);
	@override late final _StringsSearchZhTw search = _StringsSearchZhTw._(_root);
	@override late final _StringsTimeZhTw time = _StringsTimeZhTw._(_root);
	@override late final _StringsMediaZhTw media = _StringsMediaZhTw._(_root);
	@override late final _StringsPlayerZhTw player = _StringsPlayerZhTw._(_root);
	@override late final _StringsCommentZhTw comment = _StringsCommentZhTw._(_root);
	@override late final _StringsUserZhTw user = _StringsUserZhTw._(_root);
	@override late final _StringsFriendZhTw friend = _StringsFriendZhTw._(_root);
	@override late final _StringsBlockedTagsZhTw blocked_tags = _StringsBlockedTagsZhTw._(_root);
	@override late final _StringsDownloadZhTw download = _StringsDownloadZhTw._(_root);
	@override late final _StringsPlaylistZhTw playlist = _StringsPlaylistZhTw._(_root);
	@override late final _StringsChannelZhTw channel = _StringsChannelZhTw._(_root);
	@override late final _StringsCreateThreadZhTw create_thread = _StringsCreateThreadZhTw._(_root);
	@override late final _StringsNotificationsZhTw notifications = _StringsNotificationsZhTw._(_root);
	@override late final _StringsSettingsZhTw settings = _StringsSettingsZhTw._(_root);
	@override late final _StringsThemeZhTw theme = _StringsThemeZhTw._(_root);
	@override late final _StringsColorsZhTw colors = _StringsColorsZhTw._(_root);
	@override late final _StringsDisplayModeZhTw display_mode = _StringsDisplayModeZhTw._(_root);
	@override late final _StringsProxyZhTw proxy = _StringsProxyZhTw._(_root);
	@override late final _StringsMessageZhTw message = _StringsMessageZhTw._(_root);
	@override late final _StringsErrorZhTw error = _StringsErrorZhTw._(_root);
}

// Path: nav
class _StringsNavZhTw extends _StringsNavEn {
	_StringsNavZhTw._(_StringsZhTw root) : this._root = root, super._(root);

	@override final _StringsZhTw _root; // ignore: unused_field

	// Translations
	@override String get subscriptions => '訂閱';
	@override String get videos => '影片';
	@override String get images => '圖片';
	@override String get forum => '論壇';
	@override String get search => '搜尋';
}

// Path: rules
class _StringsRulesZhTw extends _StringsRulesEn {
	_StringsRulesZhTw._(_StringsZhTw root) : this._root = root, super._(root);

	@override final _StringsZhTw _root; // ignore: unused_field

	// Translations
	@override String get title => '規則';
	@override String get accept => '接受';
	@override String get accept_desc => '我同意：已閱讀規則並且會隨時留意未來的規則變更。';
}

// Path: common
class _StringsCommonZhTw extends _StringsCommonEn {
	_StringsCommonZhTw._(_StringsZhTw root) : this._root = root, super._(root);

	@override final _StringsZhTw _root; // ignore: unused_field

	// Translations
	@override String get video => '影片';
	@override String get image => '圖片';
	@override String get collapse => '收合';
	@override String get expand => '展開';
	@override String get translate => '翻譯';
	@override String get open => '打開';
}

// Path: refresh
class _StringsRefreshZhTw extends _StringsRefreshEn {
	_StringsRefreshZhTw._(_StringsZhTw root) : this._root = root, super._(root);

	@override final _StringsZhTw _root; // ignore: unused_field

	// Translations
	@override String get empty => '空空如也';
	@override String get drag_to_load => '下拉載入';
	@override String get release_to_load => '釋放載入';
	@override String get success => '載入成功';
	@override String get failed => '載入失敗';
	@override String get no_more => '沒有更多了';
	@override String get last_load => '上次載入於 %T';
}

// Path: records
class _StringsRecordsZhTw extends _StringsRecordsEn {
	_StringsRecordsZhTw._(_StringsZhTw root) : this._root = root, super._(root);

	@override final _StringsZhTw _root; // ignore: unused_field

	// Translations
	@override String get select_all => '全選';
	@override String get select_inverse => '反選';
	@override String selected_num({required Object num}) => '已選擇 ${num} 項';
	@override String get multiple_selection_mode => '多選模式';
	@override String get delete => '刪除';
	@override String get delete_all => '刪除所有';
}

// Path: account
class _StringsAccountZhTw extends _StringsAccountEn {
	_StringsAccountZhTw._(_StringsZhTw root) : this._root = root, super._(root);

	@override final _StringsZhTw _root; // ignore: unused_field

	// Translations
	@override String get captcha => '驗證碼';
	@override String get login => '登入';
	@override String get logout => '登出';
	@override String get register => '註冊';
	@override String get email => '電子郵件';
	@override String get email_or_username => '電子郵件或使用者名稱';
	@override String get password => '密碼';
	@override String get forgot_password => '忘記密碼';
	@override String get require_login => '請先登入';
}

// Path: profile
class _StringsProfileZhTw extends _StringsProfileEn {
	_StringsProfileZhTw._(_StringsZhTw root) : this._root = root, super._(root);

	@override final _StringsZhTw _root; // ignore: unused_field

	// Translations
	@override String get profile => '個人檔案';
	@override String get follow => '追蹤';
	@override String get followers => '粉絲';
	@override String get following => '正在追蹤';
	@override String get nickname => '暱稱';
	@override String get username => '使用者名稱';
	@override String get user_id => '使用者 ID';
	@override String get description => '個人簡介';
	@override String get no_description => '該使用者是個神秘人，不喜歡被人圍觀。';
	@override String get join_date => '加入日期';
	@override String get last_active_time => '最後上線時間';
	@override String get online => '在線上';
	@override String get message => '私訊';
	@override String get guestbook => '留言板';
	@override String get view_more => '查看更多';
}

// Path: sort
class _StringsSortZhTw extends _StringsSortEn {
	_StringsSortZhTw._(_StringsZhTw root) : this._root = root, super._(root);

	@override final _StringsZhTw _root; // ignore: unused_field

	// Translations
	@override String get latest => '最新';
	@override String get trending => '趨勢';
	@override String get popularity => '熱門';
	@override String get most_views => '最多觀看';
	@override String get most_likes => '最多按讚';
}

// Path: filter
class _StringsFilterZhTw extends _StringsFilterEn {
	_StringsFilterZhTw._(_StringsZhTw root) : this._root = root, super._(root);

	@override final _StringsZhTw _root; // ignore: unused_field

	// Translations
	@override String get all => '全部';
	@override String get filter => '篩選';
	@override String get rating => '分級';
	@override String get tag => '標籤';
	@override String get tags => '標籤';
	@override String get date => '日期';
	@override String get general => '普遍級';
	@override String get ecchi => '成人級';
	@override String get select_rating => '選擇分級';
	@override String get select_year => '選擇年份';
	@override String get select_month => '選擇月份';
}

// Path: search
class _StringsSearchZhTw extends _StringsSearchEn {
	_StringsSearchZhTw._(_StringsZhTw root) : this._root = root, super._(root);

	@override final _StringsZhTw _root; // ignore: unused_field

	// Translations
	@override String get users => '使用者';
	@override String get search => '搜尋';
	@override late final _StringsSearchHistoryZhTw history = _StringsSearchHistoryZhTw._(_root);
}

// Path: time
class _StringsTimeZhTw extends _StringsTimeEn {
	_StringsTimeZhTw._(_StringsZhTw root) : this._root = root, super._(root);

	@override final _StringsZhTw _root; // ignore: unused_field

	// Translations
	@override String seconds_ago({required Object time}) => '${time} 秒前';
	@override String minutes_ago({required Object time}) => '${time} 分鐘前';
	@override String hours_ago({required Object time}) => '${time} 小時前';
	@override String days_ago({required Object time}) => '${time} 天前';
}

// Path: media
class _StringsMediaZhTw extends _StringsMediaEn {
	_StringsMediaZhTw._(_StringsZhTw root) : this._root = root, super._(root);

	@override final _StringsZhTw _root; // ignore: unused_field

	// Translations
	@override String get private => '私人';
	@override String get add_to_playlist => '加入播放清單';
	@override String get external_video => '外部影片';
	@override String get share => '分享';
	@override String get download => '下載';
	@override String more_from({required Object username}) => '更多來自 ${username}';
	@override String get more_like_this => '類似作品';
	@override String updated_at({required Object time}) => '更新於 ${time}';
}

// Path: player
class _StringsPlayerZhTw extends _StringsPlayerEn {
	_StringsPlayerZhTw._(_StringsZhTw root) : this._root = root, super._(root);

	@override final _StringsZhTw _root; // ignore: unused_field

	// Translations
	@override String current_item({required Object item}) => '目前: ${item}';
	@override String get quality => '畫質';
	@override String get select_quality => '選擇畫質';
	@override String get playback_speed => '播放速度';
	@override String get select_playback_speed => '選擇播放速度';
	@override String get aspect_ratio => '長寬比';
	@override String get select_aspect_ratio => '選擇長寬比';
	@override late final _StringsPlayerAspectRatiosZhTw aspect_ratios = _StringsPlayerAspectRatiosZhTw._(_root);
	@override String seconds({required Object value}) => '${value} 秒';
	@override String get double_speed => '2 倍';
}

// Path: comment
class _StringsCommentZhTw extends _StringsCommentEn {
	_StringsCommentZhTw._(_StringsZhTw root) : this._root = root, super._(root);

	@override final _StringsZhTw _root; // ignore: unused_field

	// Translations
	@override String get comment => '評論';
	@override String get comments => '評論';
	@override String get comment_detail => '評論詳情';
	@override String get edit_comment => '編輯評論';
	@override String get delete_comment => '刪除評論';
	@override String get reply => '回覆';
	@override String replies_in_total({required Object numReply}) => '共 ${numReply} 條回覆';
	@override String show_all_replies({required Object numReply}) => '顯示全部 ${numReply} 條回覆';
}

// Path: user
class _StringsUserZhTw extends _StringsUserEn {
	_StringsUserZhTw._(_StringsZhTw root) : this._root = root, super._(root);

	@override final _StringsZhTw _root; // ignore: unused_field

	// Translations
	@override String get following => '正在關注';
	@override String get history => '歷史紀錄';
	@override String get blocked_tags => '封鎖標籤';
	@override String get friends => '好友';
	@override String get downloads => '下載記錄';
	@override String get favorites => '收藏';
	@override String get playlists => '播放清單';
	@override String get settings => '設置';
	@override String get about => '關於';
}

// Path: friend
class _StringsFriendZhTw extends _StringsFriendEn {
	_StringsFriendZhTw._(_StringsZhTw root) : this._root = root, super._(root);

	@override final _StringsZhTw _root; // ignore: unused_field

	// Translations
	@override String get friend_requests => '好友請求';
	@override String get add_friend => '新增好友';
	@override String get pending => '待處理';
	@override String get unfriend => '解除好友關係';
	@override String get accept => '接受';
	@override String get reject => '拒絕';
}

// Path: blocked_tags
class _StringsBlockedTagsZhTw extends _StringsBlockedTagsEn {
	_StringsBlockedTagsZhTw._(_StringsZhTw root) : this._root = root, super._(root);

	@override final _StringsZhTw _root; // ignore: unused_field

	// Translations
	@override String get add_blocked_tag => '新增封鎖標籤';
	@override String get blocked_tag => '封鎖標籤';
}

// Path: download
class _StringsDownloadZhTw extends _StringsDownloadEn {
	_StringsDownloadZhTw._(_StringsZhTw root) : this._root = root, super._(root);

	@override final _StringsZhTw _root; // ignore: unused_field

	// Translations
	@override String get create_download_task => '建立下載任務';
	@override String get unknown => '未知';
	@override String get enqueued => '等待中';
	@override String get downloading => '下載中';
	@override String get paused => '已暫停';
	@override String get finished => '已完成';
	@override String get failed => '下載失敗';
	@override String get retry => '重新下載';
	@override String get delete => '刪除下載任務';
	@override String get pause => '暫停';
	@override String get resume => '繼續';
	@override String get open_with => '用...開啟';
	@override String get jump_to_detail => '查看詳情';
}

// Path: playlist
class _StringsPlaylistZhTw extends _StringsPlaylistEn {
	_StringsPlaylistZhTw._(_StringsZhTw root) : this._root = root, super._(root);

	@override final _StringsZhTw _root; // ignore: unused_field

	// Translations
	@override String get title => '播放清單標題';
	@override String get create => '創建播放清單';
	@override String get select => '選擇播放清單';
	@override String get edit_title => '編輯標題';
	@override String videos_count({required Object numVideo}) => '${numVideo} 個影片';
	@override String videos_count_plural({required Object numVideo}) => '${numVideo} 個影片';
}

// Path: channel
class _StringsChannelZhTw extends _StringsChannelEn {
	_StringsChannelZhTw._(_StringsZhTw root) : this._root = root, super._(root);

	@override final _StringsZhTw _root; // ignore: unused_field

	// Translations
	@override String get administration => '管理者';
	@override String get announcements => '公告';
	@override String get feedback => '回饋';
	@override String get support => '支援';
	@override String get global => '全域';
	@override String get general => '一般';
	@override String get guides => '指南';
	@override String get questions => '幫助/問題';
	@override String get requests => '請求';
	@override String get sharing => '分享';
	@override String label({required Object numThread, required Object numPosts}) => '${numThread} 個帖子 ${numPosts} 個回覆';
}

// Path: create_thread
class _StringsCreateThreadZhTw extends _StringsCreateThreadEn {
	_StringsCreateThreadZhTw._(_StringsZhTw root) : this._root = root, super._(root);

	@override final _StringsZhTw _root; // ignore: unused_field

	// Translations
	@override String get create_thread => '發帖';
	@override String get title => '標題';
	@override String get content => '內容';
}

// Path: notifications
class _StringsNotificationsZhTw extends _StringsNotificationsEn {
	_StringsNotificationsZhTw._(_StringsZhTw root) : this._root = root, super._(root);

	@override final _StringsZhTw _root; // ignore: unused_field

	// Translations
	@override String get ok => '好的';
	@override String get success => '成功';
	@override String get error => '錯誤';
	@override String get loading => '載入中...';
	@override String get cancel => '取消';
	@override String get confirm => '確認';
	@override String get apply => '應用';
}

// Path: settings
class _StringsSettingsZhTw extends _StringsSettingsEn {
	_StringsSettingsZhTw._(_StringsZhTw root) : this._root = root, super._(root);

	@override final _StringsZhTw _root; // ignore: unused_field

	// Translations
	@override String get appearance => '外觀設定';
	@override String get theme => '主題';
	@override String get theme_desc => '設定該軟體的主題';
	@override String get dynamic_color => '動態取色';
	@override String get dynamic_color_desc => '根據內容動態更改該軟體的顏色';
	@override String get custom_color => '自定義顏色';
	@override String get custom_color_desc => '自定義該軟體的主題色';
	@override String get language => '語言';
	@override String get language_desc => '設定該軟體的語言';
	@override String get display_mode => '顯示模式';
	@override String get display_mode_desc => '設定該軟體的顯示模式';
	@override String get work_mode => '工作模式';
	@override String get work_mode_desc => '隱藏所有 NSFW 內容的封面';
	@override String get network => '網路設定';
	@override String get enable_proxy => '啟用代理';
	@override String get enable_proxy_desc => '啟用代理服務';
	@override String get proxy => '代理設定';
	@override String get proxy_desc => '設定代理伺服器';
	@override String get player => '播放器設定';
	@override String get autoplay => '自動播放';
	@override String get autoplay_desc => '打開影片頁面時自動播放影片';
	@override String get background_play => '背景播放';
	@override String get background_play_desc => '允許該軟體在後台播放影片';
	@override String get download => '下載設定';
	@override String get download_path => '下載路徑';
	@override String get allow_media_scan => '允許媒體掃描';
	@override String get allow_media_scan_desc => '允許媒體掃描程式讀取下載的媒體檔案';
	@override String get logging => '日誌設定';
	@override String get enable_logging => '啟用日誌';
	@override String get enable_logging_desc => '啟用該軟體的日誌記錄';
	@override String get clear_log => '清除日誌';
	@override String clear_log_desc({required Object size}) => '目前日誌大小: ${size}';
	@override String get enable_verbose_logging => '啟用詳細日誌';
	@override String get enable_verbose_logging_desc => '記錄更詳細的日誌';
	@override String get about => '關於';
	@override String get check_update => '檢查更新';
	@override String get check_update_desc => '檢查是否有新版本可用';
	@override String get third_party_license => '第三方庫許可';
	@override String get third_party_license_desc => '查看第三方庫的許可證';
}

// Path: theme
class _StringsThemeZhTw extends _StringsThemeEn {
	_StringsThemeZhTw._(_StringsZhTw root) : this._root = root, super._(root);

	@override final _StringsZhTw _root; // ignore: unused_field

	// Translations
	@override String get system => '跟隨系統';
	@override String get light => '淺色';
	@override String get dark => '深色';
}

// Path: colors
class _StringsColorsZhTw extends _StringsColorsEn {
	_StringsColorsZhTw._(_StringsZhTw root) : this._root = root, super._(root);

	@override final _StringsZhTw _root; // ignore: unused_field

	// Translations
	@override String get pink => '粉紅';
	@override String get red => '紅色';
	@override String get orange => '橙色';
	@override String get amber => '琥珀';
	@override String get yellow => '黃色';
	@override String get lime => '青檸';
	@override String get lightGreen => '淺綠';
	@override String get green => '綠色';
	@override String get teal => '青色';
	@override String get cyan => '藍綠';
	@override String get lightBlue => '淺藍';
	@override String get blue => '藍色';
	@override String get indigo => '藍靛';
	@override String get purple => '紫色';
	@override String get deepPurple => '深紫';
	@override String get blueGrey => '藍灰';
	@override String get brown => '棕色';
	@override String get grey => '灰色';
}

// Path: display_mode
class _StringsDisplayModeZhTw extends _StringsDisplayModeEn {
	_StringsDisplayModeZhTw._(_StringsZhTw root) : this._root = root, super._(root);

	@override final _StringsZhTw _root; // ignore: unused_field

	// Translations
	@override String get no_available => '無可用顯示模式';
	@override String get auto => '自動';
	@override String get system => '系統';
}

// Path: proxy
class _StringsProxyZhTw extends _StringsProxyEn {
	_StringsProxyZhTw._(_StringsZhTw root) : this._root = root, super._(root);

	@override final _StringsZhTw _root; // ignore: unused_field

	// Translations
	@override String get host => '主機名';
	@override String get port => '端口';
}

// Path: message
class _StringsMessageZhTw extends _StringsMessageEn {
	_StringsMessageZhTw._(_StringsZhTw root) : this._root = root, super._(root);

	@override final _StringsZhTw _root; // ignore: unused_field

	// Translations
	@override String get exit_app => '再按一次退出該軟體';
	@override String get are_you_sure_to_do_that => '你確定要這麼做嗎？';
	@override String get restart_required => '重啟後生效';
	@override String get please_type_host => '請輸入主機名';
	@override String get please_type_port => '請輸入端口';
	@override late final _StringsMessageAccountZhTw account = _StringsMessageAccountZhTw._(_root);
	@override late final _StringsMessageCommentZhTw comment = _StringsMessageCommentZhTw._(_root);
	@override late final _StringsMessageCreateThreadZhTw create_thread = _StringsMessageCreateThreadZhTw._(_root);
	@override late final _StringsMessageBlockedTagsZhTw blocked_tags = _StringsMessageBlockedTagsZhTw._(_root);
	@override late final _StringsMessagePlaylistZhTw playlist = _StringsMessagePlaylistZhTw._(_root);
	@override late final _StringsMessageDownloadZhTw download = _StringsMessageDownloadZhTw._(_root);
	@override late final _StringsMessageUpdateZhTw update = _StringsMessageUpdateZhTw._(_root);
}

// Path: error
class _StringsErrorZhTw extends _StringsErrorEn {
	_StringsErrorZhTw._(_StringsZhTw root) : this._root = root, super._(root);

	@override final _StringsZhTw _root; // ignore: unused_field

	// Translations
	@override String get retry => '載入失敗，點擊重試';
	@override String get fetch_failed => '無法獲取影片連結';
	@override String get fetch_user_info_failed => '無法獲取使用者資訊';
	@override String get invalid_path => '無效的路徑';
	@override late final _StringsErrorAccountZhTw account = _StringsErrorAccountZhTw._(_root);
}

// Path: search.history
class _StringsSearchHistoryZhTw extends _StringsSearchHistoryEn {
	_StringsSearchHistoryZhTw._(_StringsZhTw root) : this._root = root, super._(root);

	@override final _StringsZhTw _root; // ignore: unused_field

	// Translations
	@override String get delete => '刪除所有紀錄';
}

// Path: player.aspect_ratios
class _StringsPlayerAspectRatiosZhTw extends _StringsPlayerAspectRatiosEn {
	_StringsPlayerAspectRatiosZhTw._(_StringsZhTw root) : this._root = root, super._(root);

	@override final _StringsZhTw _root; // ignore: unused_field

	// Translations
	@override String get contain => '包含';
	@override String get cover => '覆蓋';
	@override String get fill => '填滿';
	@override String get fit_height => '適應高度';
	@override String get fit_width => '適應寬度';
	@override String get scale_down => '縮小適應';
}

// Path: message.account
class _StringsMessageAccountZhTw extends _StringsMessageAccountEn {
	_StringsMessageAccountZhTw._(_StringsZhTw root) : this._root = root, super._(root);

	@override final _StringsZhTw _root; // ignore: unused_field

	// Translations
	@override String get login_success => '登入成功！';
	@override String get register_success => '註冊成功，請查看郵箱激活帳號。';
	@override String get login_password_longer_than_6 => '密碼長度至少為 6 位';
	@override String get please_type_email => '請輸入郵箱';
	@override String get please_type_email_or_username => '請輸入郵箱或用戶名';
	@override String get please_type_valid_email => '請輸入正確的郵箱';
	@override String get please_type_password => '請輸入密碼';
	@override String get please_type_captcha => '請輸入驗證碼';
}

// Path: message.comment
class _StringsMessageCommentZhTw extends _StringsMessageCommentEn {
	_StringsMessageCommentZhTw._(_StringsZhTw root) : this._root = root, super._(root);

	@override final _StringsZhTw _root; // ignore: unused_field

	// Translations
	@override String get content_empty => '內容不能為空。';
	@override String get content_too_long => '內容不能超過 1000 個字符。';
	@override String get sent => '回覆已發送。';
}

// Path: message.create_thread
class _StringsMessageCreateThreadZhTw extends _StringsMessageCreateThreadEn {
	_StringsMessageCreateThreadZhTw._(_StringsZhTw root) : this._root = root, super._(root);

	@override final _StringsZhTw _root; // ignore: unused_field

	// Translations
	@override String get title_empty => '標題不能為空。';
	@override String get title_too_long => '標題不能太長。';
	@override String get content_empty => '內容不能為空。';
	@override String get content_too_long => '內容不能超過 20000 個字符。';
	@override String get created => '帖子已發送。';
}

// Path: message.blocked_tags
class _StringsMessageBlockedTagsZhTw extends _StringsMessageBlockedTagsEn {
	_StringsMessageBlockedTagsZhTw._(_StringsZhTw root) : this._root = root, super._(root);

	@override final _StringsZhTw _root; // ignore: unused_field

	// Translations
	@override String get save_confirm => '確定保存屏蔽標籤嗎？';
	@override String get saved => '屏蔽標籤已保存。';
	@override String get reached_limit => '屏蔽標籤數量已達到上限。';
}

// Path: message.playlist
class _StringsMessagePlaylistZhTw extends _StringsMessagePlaylistEn {
	_StringsMessagePlaylistZhTw._(_StringsZhTw root) : this._root = root, super._(root);

	@override final _StringsZhTw _root; // ignore: unused_field

	// Translations
	@override String get empty_playlist_title => '播放列表標題不能為空。';
	@override String get playlist_created => '播放列表已創建。';
	@override String get playlist_title_edited => '播放列表標題已修改。';
}

// Path: message.download
class _StringsMessageDownloadZhTw extends _StringsMessageDownloadEn {
	_StringsMessageDownloadZhTw._(_StringsZhTw root) : this._root = root, super._(root);

	@override final _StringsZhTw _root; // ignore: unused_field

	// Translations
	@override String get no_provide_storage_permission => '未提供存儲權限。';
	@override String get task_already_exists => '下載任務已存在。';
	@override String get task_created => '下載任務已創建。';
	@override String get maximum_simultaneous_download_reached => '已達到最大同時下載數。';
}

// Path: message.update
class _StringsMessageUpdateZhTw extends _StringsMessageUpdateEn {
	_StringsMessageUpdateZhTw._(_StringsZhTw root) : this._root = root, super._(root);

	@override final _StringsZhTw _root; // ignore: unused_field

	// Translations
	@override String get check_update_failed => '檢查更新失敗';
	@override String get update_available => '有新版本可用';
	@override String get already_latest_version => '已經是最新版本';
	@override String current_version({required Object version}) => '當前版本：${version}';
	@override String latest_version({required Object version}) => '最新版本：${version}';
	@override String get view_update => '查看更新';
}

// Path: error.account
class _StringsErrorAccountZhTw extends _StringsErrorAccountEn {
	_StringsErrorAccountZhTw._(_StringsZhTw root) : this._root = root, super._(root);

	@override final _StringsZhTw _root; // ignore: unused_field

	// Translations
	@override String get invalid_login => '郵箱或密碼錯誤';
	@override String get invalid_host => '無效的主機名';
	@override String get invalid_captcha => '驗證碼錯誤';
}

/// Flat map(s) containing all translations.
/// Only for edge cases! For simple maps, use the map function of this library.

extension on Translations {
	dynamic _flatMapFunction(String path) {
		switch (path) {
			case 'locales.en': return 'English';
			case 'locales.ja': return '日本語';
			case 'locales.zh-CN': return '简体中文';
			case 'locales.zh-TW': return '繁體中文';
			case 'rules.title': return 'Rules';
			case 'rules.accept': return 'I accept the rules';
			case 'rules.accept_desc': return 'I agree to have read the rules and will stay up to date with any future rule changes.';
			case 'nav.subscriptions': return 'Subscriptions';
			case 'nav.videos': return 'Videos';
			case 'nav.images': return 'Images';
			case 'nav.forum': return 'Forum';
			case 'nav.search': return 'Search';
			case 'common.video': return 'Video';
			case 'common.image': return 'Image';
			case 'common.collapse': return 'Collapse';
			case 'common.expand': return 'Expand';
			case 'common.translate': return 'Translate';
			case 'common.open': return 'Open';
			case 'refresh.empty': return 'Nothing here';
			case 'refresh.drag_to_load': return 'Pull to load';
			case 'refresh.release_to_load': return 'Release to load';
			case 'refresh.success': return 'Succeeded';
			case 'refresh.failed': return 'Failed';
			case 'refresh.no_more': return 'No more';
			case 'refresh.last_load': return 'Last updated at %T';
			case 'records.select_all': return 'Select all';
			case 'records.select_inverse': return 'Select inverse';
			case 'records.selected_num': return ({required Object num}) => '${num} selected';
			case 'records.multiple_selection_mode': return 'Multiple selection mode';
			case 'records.delete': return 'Delete';
			case 'records.delete_all': return 'Delete all';
			case 'account.captcha': return 'Captcha';
			case 'account.login': return 'Login';
			case 'account.logout': return 'Logout';
			case 'account.register': return 'Register';
			case 'account.email': return 'Email';
			case 'account.email_or_username': return 'Email or username';
			case 'account.password': return 'Password';
			case 'account.forgot_password': return 'Forgot password?';
			case 'account.require_login': return 'You must be logged in to do that.';
			case 'profile.profile': return 'Profile';
			case 'profile.follow': return 'Follow';
			case 'profile.followers': return 'Followers';
			case 'profile.following': return 'Following';
			case 'profile.nickname': return 'Nickname';
			case 'profile.username': return 'Username';
			case 'profile.user_id': return 'User ID';
			case 'profile.description': return 'Description';
			case 'profile.no_description': return 'This user prefers to keep an air of mystery around them.';
			case 'profile.join_date': return 'Join date';
			case 'profile.last_active_time': return 'Last active time';
			case 'profile.online': return 'Online';
			case 'profile.message': return 'Message';
			case 'profile.guestbook': return 'Guestbook';
			case 'profile.view_more': return 'View more';
			case 'sort.latest': return 'Latest';
			case 'sort.trending': return 'Trending';
			case 'sort.popularity': return 'Popularity';
			case 'sort.most_views': return 'Most views';
			case 'sort.most_likes': return 'Most likes';
			case 'filter.all': return 'All';
			case 'filter.filter': return 'Filter';
			case 'filter.rating': return 'Rating';
			case 'filter.tag': return 'Tag';
			case 'filter.tags': return 'Tags';
			case 'filter.date': return 'Date';
			case 'filter.general': return 'General';
			case 'filter.ecchi': return 'Ecchi';
			case 'filter.select_rating': return 'Select rating';
			case 'filter.select_year': return 'Select year';
			case 'filter.select_month': return 'Select month';
			case 'search.users': return 'Users';
			case 'search.search': return 'Search';
			case 'search.history.delete': return 'Delete All';
			case 'time.seconds_ago': return ({required Object time}) => '${time} seconds ago';
			case 'time.minutes_ago': return ({required Object time}) => '${time} minutes ago';
			case 'time.hours_ago': return ({required Object time}) => '${time} hours ago';
			case 'time.days_ago': return ({required Object time}) => '${time} days ago';
			case 'media.private': return 'Private';
			case 'media.add_to_playlist': return 'Add to playlist';
			case 'media.external_video': return 'External video';
			case 'media.share': return 'Share';
			case 'media.download': return 'Download';
			case 'media.more_from': return ({required Object username}) => 'More from ${username}';
			case 'media.more_like_this': return 'More like this';
			case 'media.updated_at': return ({required Object time}) => 'Updated at ${time}';
			case 'player.current_item': return ({required Object item}) => 'Current: ${item}';
			case 'player.quality': return 'Quality';
			case 'player.select_quality': return 'Select quality';
			case 'player.playback_speed': return 'Playback speed';
			case 'player.select_playback_speed': return 'Select playback speed';
			case 'player.aspect_ratio': return 'Aspect ratio';
			case 'player.select_aspect_ratio': return 'Select aspect ratio';
			case 'player.aspect_ratios.contain': return 'Contain';
			case 'player.aspect_ratios.cover': return 'Cover';
			case 'player.aspect_ratios.fill': return 'Fill';
			case 'player.aspect_ratios.fit_height': return 'Fit height';
			case 'player.aspect_ratios.fit_width': return 'Fit width';
			case 'player.aspect_ratios.scale_down': return 'Scale down';
			case 'player.seconds': return ({required Object value}) => '${value}s';
			case 'player.double_speed': return '2x';
			case 'comment.comment': return 'Comment';
			case 'comment.comments': return 'Comments';
			case 'comment.comment_detail': return 'Comment detail';
			case 'comment.edit_comment': return 'Edit comment';
			case 'comment.delete_comment': return 'Delete comment';
			case 'comment.reply': return 'Reply';
			case 'comment.replies_in_total': return ({required Object numReply}) => '${numReply} replies in total';
			case 'comment.show_all_replies': return ({required Object numReply}) => 'Show all ${numReply} replies';
			case 'user.following': return 'Following';
			case 'user.history': return 'History';
			case 'user.blocked_tags': return 'Blocked Tags';
			case 'user.friends': return 'Friends';
			case 'user.downloads': return 'Downloads';
			case 'user.favorites': return 'Favorites';
			case 'user.playlists': return 'Playlists';
			case 'user.settings': return 'Settings';
			case 'user.about': return 'About';
			case 'friend.friend_requests': return 'Friend Requests';
			case 'friend.add_friend': return 'Add friend';
			case 'friend.pending': return 'Pending';
			case 'friend.unfriend': return 'Unfriend';
			case 'friend.accept': return 'Accept';
			case 'friend.reject': return 'Reject';
			case 'blocked_tags.add_blocked_tag': return 'Add blocked tag';
			case 'blocked_tags.blocked_tag': return 'Blocked tag';
			case 'download.create_download_task': return 'Create download task';
			case 'download.unknown': return 'Unknown';
			case 'download.enqueued': return 'Enqueued';
			case 'download.downloading': return 'Downloading';
			case 'download.paused': return 'Paused';
			case 'download.finished': return 'Finished';
			case 'download.failed': return 'Failed';
			case 'download.retry': return 'Retry';
			case 'download.delete': return 'Delete';
			case 'download.pause': return 'Pause';
			case 'download.resume': return 'Resume';
			case 'download.open_with': return 'Open with';
			case 'download.jump_to_detail': return 'Jump to detail page';
			case 'playlist.title': return 'Playlist title';
			case 'playlist.create': return 'Create playlist';
			case 'playlist.select': return 'Select playlist';
			case 'playlist.edit_title': return 'Edit title';
			case 'playlist.videos_count': return ({required Object numVideo}) => '${numVideo} video';
			case 'playlist.videos_count_plural': return ({required Object numVideo}) => '${numVideo} videos';
			case 'channel.administration': return 'Administration';
			case 'channel.announcements': return 'Announcements';
			case 'channel.feedback': return 'Feedback';
			case 'channel.support': return 'Support';
			case 'channel.global': return 'Global';
			case 'channel.general': return 'General';
			case 'channel.guides': return 'Guides';
			case 'channel.questions': return 'Questions';
			case 'channel.requests': return 'Requests';
			case 'channel.sharing': return 'Sharing';
			case 'channel.label': return ({required Object numThread, required Object numPosts}) => '${numThread} Threads ${numPosts} Posts';
			case 'create_thread.create_thread': return 'Create thread';
			case 'create_thread.title': return 'Title';
			case 'create_thread.content': return 'Content';
			case 'notifications.ok': return 'OK';
			case 'notifications.success': return 'Success';
			case 'notifications.error': return 'Error';
			case 'notifications.loading': return 'Loading...';
			case 'notifications.cancel': return 'Cancel';
			case 'notifications.confirm': return 'Confirm';
			case 'notifications.apply': return 'Apply';
			case 'settings.appearance': return 'Appearance';
			case 'settings.theme': return 'Theme';
			case 'settings.theme_desc': return 'Change the theme of the App';
			case 'settings.dynamic_color': return 'Dynamic Color';
			case 'settings.dynamic_color_desc': return 'Change the color of the App according to the content';
			case 'settings.custom_color': return 'Custom Color';
			case 'settings.custom_color_desc': return 'Customize the color of the App';
			case 'settings.language': return 'Language';
			case 'settings.language_desc': return 'Change the language of the App';
			case 'settings.display_mode': return 'Display Mode';
			case 'settings.display_mode_desc': return 'Change the display mode of the App';
			case 'settings.work_mode': return 'Work Mode';
			case 'settings.work_mode_desc': return 'Hide all covers of NSFW content';
			case 'settings.network': return 'Network';
			case 'settings.enable_proxy': return 'Enable Proxy';
			case 'settings.enable_proxy_desc': return 'Enable proxy for the App';
			case 'settings.proxy': return 'Proxy';
			case 'settings.proxy_desc': return 'Set the host and port of the proxy';
			case 'settings.player': return 'Player';
			case 'settings.autoplay': return 'Autoplay';
			case 'settings.autoplay_desc': return 'Autoplay video when opening a video page';
			case 'settings.background_play': return 'Background Play';
			case 'settings.background_play_desc': return 'Allow the App to play video in the background';
			case 'settings.download': return 'Download';
			case 'settings.download_path': return 'Download Path';
			case 'settings.allow_media_scan': return 'Allow Media Scan';
			case 'settings.allow_media_scan_desc': return 'Allow media scanner to read downloaded media files';
			case 'settings.logging': return 'Logging';
			case 'settings.enable_logging': return 'Enable Logging';
			case 'settings.enable_logging_desc': return 'Enable logging for the App';
			case 'settings.clear_log': return 'Clear Log';
			case 'settings.clear_log_desc': return ({required Object size}) => 'Current log size: ${size}';
			case 'settings.enable_verbose_logging': return 'Enable Verbose Logging';
			case 'settings.enable_verbose_logging_desc': return 'Record more detailed logs';
			case 'settings.about': return 'About';
			case 'settings.check_update': return 'Check Update';
			case 'settings.check_update_desc': return 'Check if there is a new version available';
			case 'settings.third_party_license': return 'Third Party License';
			case 'settings.third_party_license_desc': return 'View the license of third party libraries';
			case 'theme.system': return 'System';
			case 'theme.light': return 'Light';
			case 'theme.dark': return 'Dark';
			case 'colors.pink': return 'Pink';
			case 'colors.red': return 'Red';
			case 'colors.orange': return 'Orange';
			case 'colors.amber': return 'Amber';
			case 'colors.yellow': return 'Yellow';
			case 'colors.lime': return 'Lime';
			case 'colors.lightGreen': return 'Light Green';
			case 'colors.green': return 'Green';
			case 'colors.teal': return 'Teal';
			case 'colors.cyan': return 'Cyan';
			case 'colors.lightBlue': return 'Light Blue';
			case 'colors.blue': return 'Blue';
			case 'colors.indigo': return 'Indigo';
			case 'colors.purple': return 'Purple';
			case 'colors.deepPurple': return 'Deep Purple';
			case 'colors.blueGrey': return 'Blue Grey';
			case 'colors.brown': return 'Brown';
			case 'colors.grey': return 'Grey';
			case 'display_mode.no_available': return 'No available display mode';
			case 'display_mode.auto': return 'Auto';
			case 'display_mode.system': return 'System';
			case 'proxy.host': return 'Host';
			case 'proxy.port': return 'Port';
			case 'message.exit_app': return 'Press again to exit the App';
			case 'message.are_you_sure_to_do_that': return 'Are you sure to do that?';
			case 'message.restart_required': return 'Restart the App to apply the changes.';
			case 'message.please_type_host': return 'Please type the host';
			case 'message.please_type_port': return 'Please type the port';
			case 'message.account.login_success': return 'Login success.';
			case 'message.account.register_success': return 'Register success, further instructions have been sent to your email.';
			case 'message.account.login_password_longer_than_6': return 'Password must be longer than 6 characters';
			case 'message.account.please_type_email': return 'Please type your email';
			case 'message.account.please_type_email_or_username': return 'Please type your email or username';
			case 'message.account.please_type_valid_email': return 'Please type a valid email';
			case 'message.account.please_type_password': return 'Please type your password';
			case 'message.account.please_type_captcha': return 'Please type the captcha';
			case 'message.comment.content_empty': return 'Content can not be empty.';
			case 'message.comment.content_too_long': return 'Content can not be longer than 1000 characters.';
			case 'message.comment.sent': return 'Reply sent.';
			case 'message.create_thread.title_empty': return 'Title can not be empty.';
			case 'message.create_thread.title_too_long': return 'Title is too long.';
			case 'message.create_thread.content_empty': return 'Content can not be empty.';
			case 'message.create_thread.content_too_long': return 'Content can not be longer than 20000 characters.';
			case 'message.create_thread.created': return 'Thread Created.';
			case 'message.blocked_tags.save_confirm': return 'Are you sure to save the blocked tags?';
			case 'message.blocked_tags.saved': return 'Blocked tags saved.';
			case 'message.blocked_tags.reached_limit': return 'Blocked tags reached limit.';
			case 'message.playlist.empty_playlist_title': return 'Playlist title can not be empty.';
			case 'message.playlist.playlist_created': return 'Playlist created.';
			case 'message.playlist.playlist_title_edited': return 'Playlist title edited.';
			case 'message.download.no_provide_storage_permission': return 'No storage permission provided.';
			case 'message.download.task_already_exists': return 'Download task already exists.';
			case 'message.download.task_created': return 'Download task created.';
			case 'message.download.maximum_simultaneous_download_reached': return 'Maximum simultaneous download reached.';
			case 'message.update.check_update_failed': return 'Failed to check update.';
			case 'message.update.update_available': return 'Update available';
			case 'message.update.already_latest_version': return 'Already the latest version';
			case 'message.update.current_version': return ({required Object version}) => 'Current version: ${version}';
			case 'message.update.latest_version': return ({required Object version}) => 'Latest version: ${version}';
			case 'message.update.view_update': return 'View update';
			case 'error.retry': return 'Load failed, click to retry.';
			case 'error.fetch_failed': return 'Failed to fetch video links.';
			case 'error.fetch_user_info_failed': return 'Failed to fetch user info.';
			case 'error.invalid_path': return 'Invalid path.';
			case 'error.account.invalid_login': return 'Invalid email or password.';
			case 'error.account.invalid_host': return 'Invalid host.';
			case 'error.account.invalid_captcha': return 'Invalid captcha.';
			default: return null;
		}
	}
}

extension on _StringsJa {
	dynamic _flatMapFunction(String path) {
		switch (path) {
			case 'nav.subscriptions': return 'サブスク';
			case 'nav.videos': return '動画';
			case 'nav.images': return '画像';
			case 'nav.forum': return 'フォーラム';
			case 'nav.search': return '検索';
			case 'rules.title': return 'ルール';
			case 'rules.accept': return '同意する';
			case 'rules.accept_desc': return '私はルールを読み、これに同意し、今後のルール変更についても、最新の情報を確認することに同意します。';
			case 'common.video': return '動画';
			case 'common.image': return '画像';
			case 'common.collapse': return '折りたたむ';
			case 'common.expand': return '展開';
			case 'common.translate': return '翻訳';
			case 'common.open': return '開く';
			case 'refresh.empty': return '何もありません';
			case 'refresh.drag_to_load': return '引っ張って読み込む';
			case 'refresh.release_to_load': return 'リリースして読み込む';
			case 'refresh.success': return '読み込み成功';
			case 'refresh.failed': return '読み込み失敗';
			case 'refresh.no_more': return 'これ以上なし';
			case 'refresh.last_load': return '前回の読み込み： %T';
			case 'records.select_all': return 'すべて選択';
			case 'records.select_inverse': return '逆選択';
			case 'records.selected_num': return ({required Object num}) => '選択済み ${num} 項目';
			case 'records.multiple_selection_mode': return '複数選択モード';
			case 'records.delete': return '削除';
			case 'records.delete_all': return 'すべて削除';
			case 'account.captcha': return 'キャプチャ';
			case 'account.login': return 'ログイン';
			case 'account.logout': return 'ログアウト';
			case 'account.register': return '登録';
			case 'account.email': return 'メール';
			case 'account.email_or_username': return 'メールまたはユーザー名';
			case 'account.password': return 'パスワード';
			case 'account.forgot_password': return 'パスワードを忘れた';
			case 'account.require_login': return 'ログインしてください';
			case 'profile.profile': return 'プロフィール';
			case 'profile.follow': return 'フォロー';
			case 'profile.followers': return 'フォロワー';
			case 'profile.following': return 'フォロー中';
			case 'profile.nickname': return 'ニックネーム';
			case 'profile.username': return 'ユーザー名';
			case 'profile.user_id': return 'ユーザーID';
			case 'profile.description': return '自己紹介';
			case 'profile.no_description': return '自分の周りに謎の空気を漂わせるのが好きです。';
			case 'profile.join_date': return '参加日';
			case 'profile.last_active_time': return '最終アクティブ時間';
			case 'profile.online': return 'オンライン';
			case 'profile.message': return 'メッセージ';
			case 'profile.guestbook': return 'ゲストブック';
			case 'profile.view_more': return 'もっと見る';
			case 'sort.latest': return '最新';
			case 'sort.trending': return 'トレンド';
			case 'sort.popularity': return '人気順';
			case 'sort.most_views': return '閲覧数';
			case 'sort.most_likes': return 'お気に入り数';
			case 'filter.all': return 'すべて';
			case 'filter.filter': return 'フィルター';
			case 'filter.rating': return 'レーティング';
			case 'filter.tag': return 'タグ';
			case 'filter.tags': return 'タグ';
			case 'filter.date': return '日付';
			case 'filter.general': return '一般';
			case 'filter.ecchi': return 'エッチ';
			case 'filter.select_rating': return 'レーティングを選択';
			case 'filter.select_year': return '年を選択';
			case 'filter.select_month': return '月を選択';
			case 'search.users': return 'ユーザー';
			case 'search.search': return '検索';
			case 'search.history.delete': return 'すべての記録を削除';
			case 'time.seconds_ago': return ({required Object time}) => '${time} 秒前';
			case 'time.minutes_ago': return ({required Object time}) => '${time} 分前';
			case 'time.hours_ago': return ({required Object time}) => '${time} 時間前';
			case 'time.days_ago': return ({required Object time}) => '${time} 日前';
			case 'media.private': return 'プライベート';
			case 'media.add_to_playlist': return 'プレイリストに追加';
			case 'media.external_video': return '外部動画';
			case 'media.share': return '共有';
			case 'media.download': return 'ダウンロード';
			case 'media.more_from': return ({required Object username}) => '${username} からのその他';
			case 'media.more_like_this': return '同様の作品';
			case 'media.updated_at': return ({required Object time}) => '${time} に更新';
			case 'player.current_item': return ({required Object item}) => '現在：${item}';
			case 'player.quality': return '画質';
			case 'player.select_quality': return '画質を選択';
			case 'player.playback_speed': return '再生速度';
			case 'player.select_playback_speed': return '再生速度を選択';
			case 'player.aspect_ratio': return 'アスペクト比';
			case 'player.select_aspect_ratio': return 'アスペクト比を選択';
			case 'player.aspect_ratios.contain': return '含む';
			case 'player.aspect_ratios.cover': return 'カバー';
			case 'player.aspect_ratios.fill': return 'フィル';
			case 'player.aspect_ratios.fit_height': return '高さに合わせる';
			case 'player.aspect_ratios.fit_width': return '幅に合わせる';
			case 'player.aspect_ratios.scale_down': return '縮小';
			case 'player.seconds': return ({required Object value}) => '${value} 秒';
			case 'player.double_speed': return '2 倍';
			case 'comment.comment': return 'コメント';
			case 'comment.comments': return 'コメント';
			case 'comment.comment_detail': return 'コメントの詳細';
			case 'comment.edit_comment': return 'コメントの編集';
			case 'comment.delete_comment': return 'コメントの削除';
			case 'comment.reply': return '返信';
			case 'comment.replies_in_total': return ({required Object numReply}) => '合計 ${numReply} 件の返信';
			case 'comment.show_all_replies': return ({required Object numReply}) => 'すべての ${numReply} 件の返信を表示';
			case 'user.following': return 'フォロー中';
			case 'user.history': return '履歴';
			case 'user.blocked_tags': return 'ブロックされたタグ';
			case 'user.friends': return '友達';
			case 'user.downloads': return 'ダウンロード';
			case 'user.favorites': return 'お気に入り';
			case 'user.playlists': return 'プレイリスト';
			case 'user.settings': return '設定';
			case 'user.about': return 'について';
			case 'friend.friend_requests': return '友達リクエスト';
			case 'friend.add_friend': return '友達に追加';
			case 'friend.pending': return '保留中';
			case 'friend.unfriend': return '友達解除';
			case 'friend.accept': return '承認';
			case 'friend.reject': return '拒否';
			case 'blocked_tags.add_blocked_tag': return 'ブロックされたタグを追加';
			case 'blocked_tags.blocked_tag': return 'ブロックされたタグ';
			case 'download.create_download_task': return 'ダウンロードタスクの作成';
			case 'download.unknown': return '不明';
			case 'download.enqueued': return '待機中';
			case 'download.downloading': return 'ダウンロード中';
			case 'download.paused': return '一時停止済み';
			case 'download.finished': return '完了';
			case 'download.failed': return 'ダウンロード失敗';
			case 'download.retry': return '再試行';
			case 'download.delete': return '削除';
			case 'download.pause': return '一時停止';
			case 'download.resume': return '再開';
			case 'download.open_with': return '開く';
			case 'download.jump_to_detail': return '詳細ページに移動';
			case 'playlist.title': return 'プレイリストのタイトル';
			case 'playlist.create': return 'プレイリストの作成';
			case 'playlist.select': return 'プレイリストの選択';
			case 'playlist.edit_title': return 'タイトルを編集';
			case 'playlist.videos_count': return ({required Object numVideo}) => '${numVideo} 本のビデオ';
			case 'playlist.videos_count_plural': return ({required Object numVideo}) => '${numVideo} 本のビデオ';
			case 'channel.administration': return '管理者';
			case 'channel.announcements': return 'お知らせ';
			case 'channel.feedback': return 'フィードバック';
			case 'channel.support': return 'サポート';
			case 'channel.global': return '一般';
			case 'channel.general': return '一般';
			case 'channel.guides': return 'ガイド';
			case 'channel.questions': return 'ヘルプ/質問';
			case 'channel.requests': return 'リクエスト';
			case 'channel.sharing': return '共有';
			case 'channel.label': return ({required Object numThread, required Object numPosts}) => '${numThread} 本のスレッド ${numPosts} 本の返信';
			case 'create_thread.create_thread': return 'スレッドの作成';
			case 'create_thread.title': return 'タイトル';
			case 'create_thread.content': return '内容';
			case 'notifications.ok': return 'OK';
			case 'notifications.success': return '成功';
			case 'notifications.error': return 'エラー';
			case 'notifications.loading': return '読み込み中...';
			case 'notifications.cancel': return 'キャンセル';
			case 'notifications.confirm': return '確認';
			case 'notifications.apply': return '適用';
			case 'settings.appearance': return '外観設定';
			case 'settings.theme': return 'テーマ';
			case 'settings.theme_desc': return 'アプリのテーマを設定します';
			case 'settings.dynamic_color': return 'ダイナミックカラー';
			case 'settings.dynamic_color_desc': return 'コンテンツに応じてアプリの色を変更します';
			case 'settings.custom_color': return 'カスタムカラー';
			case 'settings.custom_color_desc': return 'アプリのテーマカラーをカスタマイズします';
			case 'settings.language': return '言語';
			case 'settings.language_desc': return 'アプリの言語を設定します';
			case 'settings.display_mode': return '表示モード';
			case 'settings.display_mode_desc': return 'アプリの表示モードを設定します';
			case 'settings.work_mode': return '作業モード';
			case 'settings.work_mode_desc': return 'NSFW コンテンツのカバーを非表示にします';
			case 'settings.network': return 'ネットワーク設定';
			case 'settings.enable_proxy': return 'プロキシを有効にする';
			case 'settings.enable_proxy_desc': return 'プロキシサービスを有効にします';
			case 'settings.proxy': return 'プロキシ設定';
			case 'settings.proxy_desc': return 'プロキシサーバーを設定します';
			case 'settings.player': return 'プレイヤー設定';
			case 'settings.autoplay': return '自動再生';
			case 'settings.autoplay_desc': return 'ビデオページを開くときに自動でビデオを再生します';
			case 'settings.background_play': return 'バックグラウンド再生';
			case 'settings.background_play_desc': return 'アプリをバックグラウンドでビデオを再生することを許可します';
			case 'settings.download': return 'ダウンロード設定';
			case 'settings.download_path': return 'ダウンロードパス';
			case 'settings.allow_media_scan': return 'メディアスキャンを許可';
			case 'settings.allow_media_scan_desc': return 'ダウンロードしたメディアファイルをメディアスキャンアプリに読み取らせることを許可します';
			case 'settings.logging': return 'ログ';
			case 'settings.enable_logging': return 'ログを有効にする';
			case 'settings.enable_logging_desc': return 'アプリのログを有効にします';
			case 'settings.clear_log': return 'ログをクリア';
			case 'settings.clear_log_desc': return ({required Object size}) => '現在のログサイズ：${size}';
			case 'settings.enable_verbose_logging': return '詳細なログを有効にする';
			case 'settings.enable_verbose_logging_desc': return 'より詳細なログを記録します';
			case 'settings.about': return '情報';
			case 'settings.check_update': return '更新を確認';
			case 'settings.check_update_desc': return '新しいバージョンが利用可能かどうかを確認します';
			case 'settings.third_party_license': return 'サードパーティのライセンス';
			case 'settings.third_party_license_desc': return 'サードパーティのライブラリのライセンスを確認します';
			case 'theme.system': return 'システムに従う';
			case 'theme.light': return 'ライト';
			case 'theme.dark': return 'ダーク';
			case 'colors.pink': return 'ピンク';
			case 'colors.red': return '赤';
			case 'colors.orange': return 'オレンジ';
			case 'colors.amber': return 'アンバー';
			case 'colors.yellow': return '黄';
			case 'colors.lime': return 'ライム';
			case 'colors.lightGreen': return 'ライトグリーン';
			case 'colors.green': return '緑';
			case 'colors.teal': return 'ティール';
			case 'colors.cyan': return 'シアン';
			case 'colors.lightBlue': return 'ライトブルー';
			case 'colors.blue': return '青';
			case 'colors.indigo': return 'インディゴ';
			case 'colors.purple': return '紫';
			case 'colors.deepPurple': return 'ディープパープル';
			case 'colors.blueGrey': return 'ブルーグレー';
			case 'colors.brown': return '茶色';
			case 'colors.grey': return 'グレー';
			case 'display_mode.no_available': return '利用可能な表示モードはありません';
			case 'display_mode.auto': return '自動';
			case 'display_mode.system': return 'システム';
			case 'proxy.host': return 'ホスト名';
			case 'proxy.port': return 'ポート';
			case 'message.exit_app': return 'アプリを終了するにはもう一度押してください';
			case 'message.are_you_sure_to_do_that': return 'それを行うことを確認していますか？';
			case 'message.restart_required': return '再起動後に有効';
			case 'message.please_type_host': return 'ホスト名を入力してください';
			case 'message.please_type_port': return 'ポートを入力してください';
			case 'message.account.login_success': return 'ログイン成功！';
			case 'message.account.register_success': return '登録が成功しました。メールでアカウントを有効にしてください。';
			case 'message.account.login_password_longer_than_6': return 'パスワードは少なくとも6文字である必要があります';
			case 'message.account.please_type_email': return 'メールアドレスを入力してください';
			case 'message.account.please_type_email_or_username': return 'メールアドレスまたはユーザー名を入力してください';
			case 'message.account.please_type_valid_email': return '正しいメールアドレスを入力してください';
			case 'message.account.please_type_password': return 'パスワードを入力してください';
			case 'message.account.please_type_captcha': return 'キャプチャを入力してください';
			case 'message.comment.content_empty': return '内容は空であってはいけません。';
			case 'message.comment.content_too_long': return '内容は1000文字を超えてはいけません。';
			case 'message.comment.sent': return '返信が送信されました。';
			case 'message.create_thread.title_empty': return 'タイトルは空であってはいけません。';
			case 'message.create_thread.title_too_long': return 'タイトルは長すぎてはいけません。';
			case 'message.create_thread.content_empty': return '内容は空であってはいけません。';
			case 'message.create_thread.content_too_long': return '内容は20000文字を超えてはいけません。';
			case 'message.create_thread.created': return 'スレッドが送信されました。';
			case 'message.blocked_tags.save_confirm': return 'タグのブロックを保存しますか？';
			case 'message.blocked_tags.saved': return 'ブロックされたタグが保存されました。';
			case 'message.blocked_tags.reached_limit': return 'ブロックされたタグの数が上限に達しました。';
			case 'message.playlist.empty_playlist_title': return 'プレイリストのタイトルは空であってはいけません。';
			case 'message.playlist.playlist_created': return 'プレイリストが作成されました。';
			case 'message.playlist.playlist_title_edited': return 'プレイリストのタイトルが編集されました。';
			case 'message.download.no_provide_storage_permission': return 'ストレージの許可がありません。';
			case 'message.download.task_already_exists': return 'ダウンロードタスクはすでに存在します。';
			case 'message.download.task_created': return 'ダウンロードタスクが作成されました。';
			case 'message.download.maximum_simultaneous_download_reached': return '最大同時ダウンロード数に達しました。';
			case 'message.update.check_update_failed': return '更新の確認に失敗しました';
			case 'message.update.update_available': return '新しいバージョンが利用可能です';
			case 'message.update.already_latest_version': return 'すでに最新バージョンです';
			case 'message.update.current_version': return ({required Object version}) => '現在のバージョン：${version}';
			case 'message.update.latest_version': return ({required Object version}) => '最新バージョン：${version}';
			case 'message.update.view_update': return '更新を表示';
			case 'error.retry': return '読み込みに失敗しました。再試行する';
			case 'error.fetch_failed': return 'ビデオリンクを取得できません';
			case 'error.fetch_user_info_failed': return 'ユーザー情報を取得できません';
			case 'error.invalid_path': return '無効なパス';
			case 'error.account.invalid_login': return '無効なメールアドレスまたはパスワード';
			case 'error.account.invalid_host': return '無効なホスト名';
			case 'error.account.invalid_captcha': return '無効なキャプチャ';
			default: return null;
		}
	}
}

extension on _StringsZhCn {
	dynamic _flatMapFunction(String path) {
		switch (path) {
			case 'nav.subscriptions': return '订阅';
			case 'nav.videos': return '视频';
			case 'nav.images': return '图片';
			case 'nav.forum': return '论坛';
			case 'nav.search': return '搜索';
			case 'rules.title': return '规则';
			case 'rules.accept': return '接受';
			case 'rules.accept_desc': return '我同意：已阅读规则并且会随时留意未来的规则变更。';
			case 'common.video': return '视频';
			case 'common.image': return '图片';
			case 'common.collapse': return '收起';
			case 'common.expand': return '展开';
			case 'common.translate': return '翻译';
			case 'common.open': return '打开';
			case 'refresh.empty': return '空空如也';
			case 'refresh.drag_to_load': return '下拉加载';
			case 'refresh.release_to_load': return '释放加载';
			case 'refresh.success': return '加载成功';
			case 'refresh.failed': return '加载失败';
			case 'refresh.no_more': return '没有更多了';
			case 'refresh.last_load': return '上次加载于 %T';
			case 'records.select_all': return '全选';
			case 'records.select_inverse': return '反选';
			case 'records.selected_num': return ({required Object num}) => '已选 ${num} 项';
			case 'records.multiple_selection_mode': return '多选模式';
			case 'records.delete': return '删除';
			case 'records.delete_all': return '删除所有';
			case 'account.captcha': return '验证码';
			case 'account.login': return '登录';
			case 'account.logout': return '登出';
			case 'account.register': return '注册';
			case 'account.email': return '邮箱';
			case 'account.email_or_username': return '邮箱或用户名';
			case 'account.password': return '密码';
			case 'account.forgot_password': return '忘记密码';
			case 'account.require_login': return '请先登录';
			case 'profile.profile': return '个人资料';
			case 'profile.follow': return '关注';
			case 'profile.followers': return '粉丝';
			case 'profile.following': return '关注中';
			case 'profile.nickname': return '昵称';
			case 'profile.username': return '用户名';
			case 'profile.user_id': return '用户 ID';
			case 'profile.description': return '个人简介';
			case 'profile.no_description': return '该用户是个神秘人，不喜欢被人围观。';
			case 'profile.join_date': return '加入时间';
			case 'profile.last_active_time': return '最后在线时间';
			case 'profile.online': return '在线';
			case 'profile.message': return '私信';
			case 'profile.guestbook': return '留言板';
			case 'profile.view_more': return '查看更多';
			case 'sort.latest': return '最新';
			case 'sort.trending': return '流行';
			case 'sort.popularity': return '人气';
			case 'sort.most_views': return '最多观看';
			case 'sort.most_likes': return '最多点赞';
			case 'filter.all': return '全部';
			case 'filter.filter': return '筛选';
			case 'filter.rating': return '分级';
			case 'filter.tag': return '标签';
			case 'filter.tags': return '标签';
			case 'filter.date': return '日期';
			case 'filter.general': return '全年龄';
			case 'filter.ecchi': return '成人';
			case 'filter.select_rating': return '选择分级';
			case 'filter.select_year': return '选择年份';
			case 'filter.select_month': return '选择月份';
			case 'search.users': return '用户';
			case 'search.search': return '搜索';
			case 'search.history.delete': return '删除所有记录';
			case 'time.seconds_ago': return ({required Object time}) => '${time} 秒前';
			case 'time.minutes_ago': return ({required Object time}) => '${time} 分钟前';
			case 'time.hours_ago': return ({required Object time}) => '${time} 小时前';
			case 'time.days_ago': return ({required Object time}) => '${time} 天前';
			case 'media.private': return '私有';
			case 'media.add_to_playlist': return '添加到播放列表';
			case 'media.external_video': return '外部视频';
			case 'media.share': return '分享';
			case 'media.download': return '下载';
			case 'media.more_from': return ({required Object username}) => '更多来自 ${username}';
			case 'media.more_like_this': return '类似作品';
			case 'media.updated_at': return ({required Object time}) => '更新于 ${time}';
			case 'player.current_item': return ({required Object item}) => '当前: ${item}';
			case 'player.quality': return '画质';
			case 'player.select_quality': return '选择画质';
			case 'player.playback_speed': return '播放速度';
			case 'player.select_playback_speed': return '选择播放速度';
			case 'player.aspect_ratio': return '宽高比';
			case 'player.select_aspect_ratio': return '选择宽高比';
			case 'player.aspect_ratios.contain': return '包含';
			case 'player.aspect_ratios.cover': return '覆盖';
			case 'player.aspect_ratios.fill': return '填充';
			case 'player.aspect_ratios.fit_height': return '适应高度';
			case 'player.aspect_ratios.fit_width': return '适应宽度';
			case 'player.aspect_ratios.scale_down': return '缩小适应';
			case 'player.seconds': return ({required Object value}) => '${value} 秒';
			case 'player.double_speed': return '2 倍';
			case 'comment.comment': return '评论';
			case 'comment.comments': return '评论';
			case 'comment.comment_detail': return '评论详情';
			case 'comment.edit_comment': return '编辑评论';
			case 'comment.delete_comment': return '删除评论';
			case 'comment.reply': return '回复';
			case 'comment.replies_in_total': return ({required Object numReply}) => '共 ${numReply} 条回复';
			case 'comment.show_all_replies': return ({required Object numReply}) => '显示全部 ${numReply} 条回复';
			case 'user.following': return '关注中';
			case 'user.history': return '历史记录';
			case 'user.blocked_tags': return '屏蔽标签';
			case 'user.friends': return '好友';
			case 'user.downloads': return '缓存';
			case 'user.favorites': return '收藏';
			case 'user.playlists': return '播放列表';
			case 'user.settings': return '设置';
			case 'user.about': return '关于';
			case 'friend.friend_requests': return '好友请求';
			case 'friend.add_friend': return '添加好友';
			case 'friend.pending': return '待处理';
			case 'friend.unfriend': return '解除好友';
			case 'friend.accept': return '接受';
			case 'friend.reject': return '拒绝';
			case 'blocked_tags.add_blocked_tag': return '添加屏蔽标签';
			case 'blocked_tags.blocked_tag': return '屏蔽标签';
			case 'download.create_download_task': return '创建下载任务';
			case 'download.unknown': return '未知';
			case 'download.enqueued': return '等待中';
			case 'download.downloading': return '下载中';
			case 'download.paused': return '已暂停';
			case 'download.finished': return '已完成';
			case 'download.failed': return '下载失败';
			case 'download.retry': return '重新下载';
			case 'download.delete': return '删除下载任务';
			case 'download.pause': return '暂停';
			case 'download.resume': return '继续';
			case 'download.open_with': return '用...打开';
			case 'download.jump_to_detail': return '查看详情页';
			case 'playlist.title': return '播放列表标题';
			case 'playlist.create': return '创建播放列表';
			case 'playlist.select': return '选择播放列表';
			case 'playlist.edit_title': return '编辑标题';
			case 'playlist.videos_count': return ({required Object numVideo}) => '${numVideo} 个视频';
			case 'playlist.videos_count_plural': return ({required Object numVideo}) => '${numVideo} 个视频';
			case 'channel.administration': return '管理者';
			case 'channel.announcements': return '公告';
			case 'channel.feedback': return '反馈';
			case 'channel.support': return '支持';
			case 'channel.global': return '常规';
			case 'channel.general': return '普通';
			case 'channel.guides': return '指南';
			case 'channel.questions': return '帮助/问题';
			case 'channel.requests': return '请求';
			case 'channel.sharing': return '分享';
			case 'channel.label': return ({required Object numThread, required Object numPosts}) => '${numThread} 个帖子 ${numPosts} 个回复';
			case 'create_thread.create_thread': return '发帖';
			case 'create_thread.title': return '标题';
			case 'create_thread.content': return '内容';
			case 'notifications.ok': return '好的';
			case 'notifications.success': return '成功';
			case 'notifications.error': return '错误';
			case 'notifications.loading': return '加载中...';
			case 'notifications.cancel': return '取消';
			case 'notifications.confirm': return '确认';
			case 'notifications.apply': return '应用';
			case 'settings.appearance': return '外观设置';
			case 'settings.theme': return '主题';
			case 'settings.theme_desc': return '设置应用的主题';
			case 'settings.dynamic_color': return '动态取色';
			case 'settings.dynamic_color_desc': return '根据内容动态更改应用的颜色';
			case 'settings.custom_color': return '自定义颜色';
			case 'settings.custom_color_desc': return '自定义应用的主题色';
			case 'settings.language': return '语言';
			case 'settings.language_desc': return '设置应用的语言';
			case 'settings.display_mode': return '显示模式';
			case 'settings.display_mode_desc': return '设置应用的显示模式';
			case 'settings.work_mode': return '工作模式';
			case 'settings.work_mode_desc': return '隐藏所有 NSFW 内容的封面';
			case 'settings.network': return '网络设置';
			case 'settings.enable_proxy': return '启用代理';
			case 'settings.enable_proxy_desc': return '启用代理服务';
			case 'settings.proxy': return '代理设置';
			case 'settings.proxy_desc': return '设置代理服务器';
			case 'settings.player': return '播放器设置';
			case 'settings.autoplay': return '自动播放';
			case 'settings.autoplay_desc': return '打开视频页面时自动播放视频';
			case 'settings.background_play': return '后台播放';
			case 'settings.background_play_desc': return '允许应用在后台播放视频';
			case 'settings.download': return '下载设置';
			case 'settings.download_path': return '下载路径';
			case 'settings.allow_media_scan': return '允许媒体扫描';
			case 'settings.allow_media_scan_desc': return '允许媒体扫描程序读取下载的媒体文件';
			case 'settings.logging': return '日志设置';
			case 'settings.enable_logging': return '启用日志';
			case 'settings.enable_logging_desc': return '启用应用的日志记录';
			case 'settings.clear_log': return '清除日志';
			case 'settings.clear_log_desc': return ({required Object size}) => '当前日志大小: ${size}';
			case 'settings.enable_verbose_logging': return '启用详细日志';
			case 'settings.enable_verbose_logging_desc': return '记录更详细的日志';
			case 'settings.about': return '关于';
			case 'settings.check_update': return '检查更新';
			case 'settings.check_update_desc': return '检查是否有新版本可用';
			case 'settings.third_party_license': return '第三方库许可';
			case 'settings.third_party_license_desc': return '查看第三方库的许可证';
			case 'theme.system': return '跟随系统';
			case 'theme.light': return '浅色';
			case 'theme.dark': return '深色';
			case 'colors.pink': return '粉红';
			case 'colors.red': return '红色';
			case 'colors.orange': return '橙色';
			case 'colors.amber': return '琥珀';
			case 'colors.yellow': return '黄色';
			case 'colors.lime': return '绿黄';
			case 'colors.lightGreen': return '浅绿';
			case 'colors.green': return '绿色';
			case 'colors.teal': return '青色';
			case 'colors.cyan': return '青绿';
			case 'colors.lightBlue': return '浅蓝';
			case 'colors.blue': return '蓝色';
			case 'colors.indigo': return '靛蓝';
			case 'colors.purple': return '紫色';
			case 'colors.deepPurple': return '深紫';
			case 'colors.blueGrey': return '蓝灰';
			case 'colors.brown': return '棕色';
			case 'colors.grey': return '灰色';
			case 'display_mode.no_available': return '无可用显示模式';
			case 'display_mode.auto': return '自动';
			case 'display_mode.system': return '系统';
			case 'proxy.host': return '主机名';
			case 'proxy.port': return '端口';
			case 'message.exit_app': return '再按一次退出应用';
			case 'message.are_you_sure_to_do_that': return '你确定要这么做吗？';
			case 'message.restart_required': return '重启后生效';
			case 'message.please_type_host': return '请输入主机名';
			case 'message.please_type_port': return '请输入端口';
			case 'message.account.login_success': return '登入成功！';
			case 'message.account.register_success': return '注册成功，请查看邮箱激活账号。';
			case 'message.account.login_password_longer_than_6': return '密码长度至少为 6 位';
			case 'message.account.please_type_email': return '请输入邮箱';
			case 'message.account.please_type_email_or_username': return '请输入邮箱或用户名';
			case 'message.account.please_type_valid_email': return '请输入正确的邮箱';
			case 'message.account.please_type_password': return '请输入密码';
			case 'message.account.please_type_captcha': return '请输入验证码';
			case 'message.comment.content_empty': return '内容不能为空。';
			case 'message.comment.content_too_long': return '内容不能超过 1000 个字符。';
			case 'message.comment.sent': return '回复已发送。';
			case 'message.create_thread.title_empty': return '标题不能为空。';
			case 'message.create_thread.title_too_long': return '标题不能过长。';
			case 'message.create_thread.content_empty': return '内容不能为空。';
			case 'message.create_thread.content_too_long': return '内容不能超过 20000 个字符。';
			case 'message.create_thread.created': return '帖子已发送。';
			case 'message.blocked_tags.save_confirm': return '确定保存屏蔽标签吗？';
			case 'message.blocked_tags.saved': return '屏蔽标签已保存。';
			case 'message.blocked_tags.reached_limit': return '屏蔽标签数量已达到上限。';
			case 'message.playlist.empty_playlist_title': return '播放列表标题不能为空。';
			case 'message.playlist.playlist_created': return '播放列表已创建。';
			case 'message.playlist.playlist_title_edited': return '播放列表标题已修改。';
			case 'message.download.no_provide_storage_permission': return '未提供存储权限。';
			case 'message.download.task_already_exists': return '下载任务已存在。';
			case 'message.download.task_created': return '下载任务已创建。';
			case 'message.download.maximum_simultaneous_download_reached': return '已达到最大同时下载数。';
			case 'message.update.check_update_failed': return '检查更新失败';
			case 'message.update.update_available': return '有新版本可用';
			case 'message.update.already_latest_version': return '已是最新版本';
			case 'message.update.current_version': return ({required Object version}) => '当前版本：${version}';
			case 'message.update.latest_version': return ({required Object version}) => '最新版本：${version}';
			case 'message.update.view_update': return '查看更新';
			case 'error.retry': return '加载失败，点击重试';
			case 'error.fetch_failed': return '无法获取视频链接';
			case 'error.fetch_user_info_failed': return '无法获取用户信息';
			case 'error.invalid_path': return '无效的路径';
			case 'error.account.invalid_login': return '邮箱或密码错误';
			case 'error.account.invalid_host': return '无效的主机名';
			case 'error.account.invalid_captcha': return '验证码错误';
			default: return null;
		}
	}
}

extension on _StringsZhTw {
	dynamic _flatMapFunction(String path) {
		switch (path) {
			case 'nav.subscriptions': return '訂閱';
			case 'nav.videos': return '影片';
			case 'nav.images': return '圖片';
			case 'nav.forum': return '論壇';
			case 'nav.search': return '搜尋';
			case 'rules.title': return '規則';
			case 'rules.accept': return '接受';
			case 'rules.accept_desc': return '我同意：已閱讀規則並且會隨時留意未來的規則變更。';
			case 'common.video': return '影片';
			case 'common.image': return '圖片';
			case 'common.collapse': return '收合';
			case 'common.expand': return '展開';
			case 'common.translate': return '翻譯';
			case 'common.open': return '打開';
			case 'refresh.empty': return '空空如也';
			case 'refresh.drag_to_load': return '下拉載入';
			case 'refresh.release_to_load': return '釋放載入';
			case 'refresh.success': return '載入成功';
			case 'refresh.failed': return '載入失敗';
			case 'refresh.no_more': return '沒有更多了';
			case 'refresh.last_load': return '上次載入於 %T';
			case 'records.select_all': return '全選';
			case 'records.select_inverse': return '反選';
			case 'records.selected_num': return ({required Object num}) => '已選擇 ${num} 項';
			case 'records.multiple_selection_mode': return '多選模式';
			case 'records.delete': return '刪除';
			case 'records.delete_all': return '刪除所有';
			case 'account.captcha': return '驗證碼';
			case 'account.login': return '登入';
			case 'account.logout': return '登出';
			case 'account.register': return '註冊';
			case 'account.email': return '電子郵件';
			case 'account.email_or_username': return '電子郵件或使用者名稱';
			case 'account.password': return '密碼';
			case 'account.forgot_password': return '忘記密碼';
			case 'account.require_login': return '請先登入';
			case 'profile.profile': return '個人檔案';
			case 'profile.follow': return '追蹤';
			case 'profile.followers': return '粉絲';
			case 'profile.following': return '正在追蹤';
			case 'profile.nickname': return '暱稱';
			case 'profile.username': return '使用者名稱';
			case 'profile.user_id': return '使用者 ID';
			case 'profile.description': return '個人簡介';
			case 'profile.no_description': return '該使用者是個神秘人，不喜歡被人圍觀。';
			case 'profile.join_date': return '加入日期';
			case 'profile.last_active_time': return '最後上線時間';
			case 'profile.online': return '在線上';
			case 'profile.message': return '私訊';
			case 'profile.guestbook': return '留言板';
			case 'profile.view_more': return '查看更多';
			case 'sort.latest': return '最新';
			case 'sort.trending': return '趨勢';
			case 'sort.popularity': return '熱門';
			case 'sort.most_views': return '最多觀看';
			case 'sort.most_likes': return '最多按讚';
			case 'filter.all': return '全部';
			case 'filter.filter': return '篩選';
			case 'filter.rating': return '分級';
			case 'filter.tag': return '標籤';
			case 'filter.tags': return '標籤';
			case 'filter.date': return '日期';
			case 'filter.general': return '普遍級';
			case 'filter.ecchi': return '成人級';
			case 'filter.select_rating': return '選擇分級';
			case 'filter.select_year': return '選擇年份';
			case 'filter.select_month': return '選擇月份';
			case 'search.users': return '使用者';
			case 'search.search': return '搜尋';
			case 'search.history.delete': return '刪除所有紀錄';
			case 'time.seconds_ago': return ({required Object time}) => '${time} 秒前';
			case 'time.minutes_ago': return ({required Object time}) => '${time} 分鐘前';
			case 'time.hours_ago': return ({required Object time}) => '${time} 小時前';
			case 'time.days_ago': return ({required Object time}) => '${time} 天前';
			case 'media.private': return '私人';
			case 'media.add_to_playlist': return '加入播放清單';
			case 'media.external_video': return '外部影片';
			case 'media.share': return '分享';
			case 'media.download': return '下載';
			case 'media.more_from': return ({required Object username}) => '更多來自 ${username}';
			case 'media.more_like_this': return '類似作品';
			case 'media.updated_at': return ({required Object time}) => '更新於 ${time}';
			case 'player.current_item': return ({required Object item}) => '目前: ${item}';
			case 'player.quality': return '畫質';
			case 'player.select_quality': return '選擇畫質';
			case 'player.playback_speed': return '播放速度';
			case 'player.select_playback_speed': return '選擇播放速度';
			case 'player.aspect_ratio': return '長寬比';
			case 'player.select_aspect_ratio': return '選擇長寬比';
			case 'player.aspect_ratios.contain': return '包含';
			case 'player.aspect_ratios.cover': return '覆蓋';
			case 'player.aspect_ratios.fill': return '填滿';
			case 'player.aspect_ratios.fit_height': return '適應高度';
			case 'player.aspect_ratios.fit_width': return '適應寬度';
			case 'player.aspect_ratios.scale_down': return '縮小適應';
			case 'player.seconds': return ({required Object value}) => '${value} 秒';
			case 'player.double_speed': return '2 倍';
			case 'comment.comment': return '評論';
			case 'comment.comments': return '評論';
			case 'comment.comment_detail': return '評論詳情';
			case 'comment.edit_comment': return '編輯評論';
			case 'comment.delete_comment': return '刪除評論';
			case 'comment.reply': return '回覆';
			case 'comment.replies_in_total': return ({required Object numReply}) => '共 ${numReply} 條回覆';
			case 'comment.show_all_replies': return ({required Object numReply}) => '顯示全部 ${numReply} 條回覆';
			case 'user.following': return '正在關注';
			case 'user.history': return '歷史紀錄';
			case 'user.blocked_tags': return '封鎖標籤';
			case 'user.friends': return '好友';
			case 'user.downloads': return '下載記錄';
			case 'user.favorites': return '收藏';
			case 'user.playlists': return '播放清單';
			case 'user.settings': return '設置';
			case 'user.about': return '關於';
			case 'friend.friend_requests': return '好友請求';
			case 'friend.add_friend': return '新增好友';
			case 'friend.pending': return '待處理';
			case 'friend.unfriend': return '解除好友關係';
			case 'friend.accept': return '接受';
			case 'friend.reject': return '拒絕';
			case 'blocked_tags.add_blocked_tag': return '新增封鎖標籤';
			case 'blocked_tags.blocked_tag': return '封鎖標籤';
			case 'download.create_download_task': return '建立下載任務';
			case 'download.unknown': return '未知';
			case 'download.enqueued': return '等待中';
			case 'download.downloading': return '下載中';
			case 'download.paused': return '已暫停';
			case 'download.finished': return '已完成';
			case 'download.failed': return '下載失敗';
			case 'download.retry': return '重新下載';
			case 'download.delete': return '刪除下載任務';
			case 'download.pause': return '暫停';
			case 'download.resume': return '繼續';
			case 'download.open_with': return '用...開啟';
			case 'download.jump_to_detail': return '查看詳情';
			case 'playlist.title': return '播放清單標題';
			case 'playlist.create': return '創建播放清單';
			case 'playlist.select': return '選擇播放清單';
			case 'playlist.edit_title': return '編輯標題';
			case 'playlist.videos_count': return ({required Object numVideo}) => '${numVideo} 個影片';
			case 'playlist.videos_count_plural': return ({required Object numVideo}) => '${numVideo} 個影片';
			case 'channel.administration': return '管理者';
			case 'channel.announcements': return '公告';
			case 'channel.feedback': return '回饋';
			case 'channel.support': return '支援';
			case 'channel.global': return '全域';
			case 'channel.general': return '一般';
			case 'channel.guides': return '指南';
			case 'channel.questions': return '幫助/問題';
			case 'channel.requests': return '請求';
			case 'channel.sharing': return '分享';
			case 'channel.label': return ({required Object numThread, required Object numPosts}) => '${numThread} 個帖子 ${numPosts} 個回覆';
			case 'create_thread.create_thread': return '發帖';
			case 'create_thread.title': return '標題';
			case 'create_thread.content': return '內容';
			case 'notifications.ok': return '好的';
			case 'notifications.success': return '成功';
			case 'notifications.error': return '錯誤';
			case 'notifications.loading': return '載入中...';
			case 'notifications.cancel': return '取消';
			case 'notifications.confirm': return '確認';
			case 'notifications.apply': return '應用';
			case 'settings.appearance': return '外觀設定';
			case 'settings.theme': return '主題';
			case 'settings.theme_desc': return '設定該軟體的主題';
			case 'settings.dynamic_color': return '動態取色';
			case 'settings.dynamic_color_desc': return '根據內容動態更改該軟體的顏色';
			case 'settings.custom_color': return '自定義顏色';
			case 'settings.custom_color_desc': return '自定義該軟體的主題色';
			case 'settings.language': return '語言';
			case 'settings.language_desc': return '設定該軟體的語言';
			case 'settings.display_mode': return '顯示模式';
			case 'settings.display_mode_desc': return '設定該軟體的顯示模式';
			case 'settings.work_mode': return '工作模式';
			case 'settings.work_mode_desc': return '隱藏所有 NSFW 內容的封面';
			case 'settings.network': return '網路設定';
			case 'settings.enable_proxy': return '啟用代理';
			case 'settings.enable_proxy_desc': return '啟用代理服務';
			case 'settings.proxy': return '代理設定';
			case 'settings.proxy_desc': return '設定代理伺服器';
			case 'settings.player': return '播放器設定';
			case 'settings.autoplay': return '自動播放';
			case 'settings.autoplay_desc': return '打開影片頁面時自動播放影片';
			case 'settings.background_play': return '背景播放';
			case 'settings.background_play_desc': return '允許該軟體在後台播放影片';
			case 'settings.download': return '下載設定';
			case 'settings.download_path': return '下載路徑';
			case 'settings.allow_media_scan': return '允許媒體掃描';
			case 'settings.allow_media_scan_desc': return '允許媒體掃描程式讀取下載的媒體檔案';
			case 'settings.logging': return '日誌設定';
			case 'settings.enable_logging': return '啟用日誌';
			case 'settings.enable_logging_desc': return '啟用該軟體的日誌記錄';
			case 'settings.clear_log': return '清除日誌';
			case 'settings.clear_log_desc': return ({required Object size}) => '目前日誌大小: ${size}';
			case 'settings.enable_verbose_logging': return '啟用詳細日誌';
			case 'settings.enable_verbose_logging_desc': return '記錄更詳細的日誌';
			case 'settings.about': return '關於';
			case 'settings.check_update': return '檢查更新';
			case 'settings.check_update_desc': return '檢查是否有新版本可用';
			case 'settings.third_party_license': return '第三方庫許可';
			case 'settings.third_party_license_desc': return '查看第三方庫的許可證';
			case 'theme.system': return '跟隨系統';
			case 'theme.light': return '淺色';
			case 'theme.dark': return '深色';
			case 'colors.pink': return '粉紅';
			case 'colors.red': return '紅色';
			case 'colors.orange': return '橙色';
			case 'colors.amber': return '琥珀';
			case 'colors.yellow': return '黃色';
			case 'colors.lime': return '青檸';
			case 'colors.lightGreen': return '淺綠';
			case 'colors.green': return '綠色';
			case 'colors.teal': return '青色';
			case 'colors.cyan': return '藍綠';
			case 'colors.lightBlue': return '淺藍';
			case 'colors.blue': return '藍色';
			case 'colors.indigo': return '藍靛';
			case 'colors.purple': return '紫色';
			case 'colors.deepPurple': return '深紫';
			case 'colors.blueGrey': return '藍灰';
			case 'colors.brown': return '棕色';
			case 'colors.grey': return '灰色';
			case 'display_mode.no_available': return '無可用顯示模式';
			case 'display_mode.auto': return '自動';
			case 'display_mode.system': return '系統';
			case 'proxy.host': return '主機名';
			case 'proxy.port': return '端口';
			case 'message.exit_app': return '再按一次退出該軟體';
			case 'message.are_you_sure_to_do_that': return '你確定要這麼做嗎？';
			case 'message.restart_required': return '重啟後生效';
			case 'message.please_type_host': return '請輸入主機名';
			case 'message.please_type_port': return '請輸入端口';
			case 'message.account.login_success': return '登入成功！';
			case 'message.account.register_success': return '註冊成功，請查看郵箱激活帳號。';
			case 'message.account.login_password_longer_than_6': return '密碼長度至少為 6 位';
			case 'message.account.please_type_email': return '請輸入郵箱';
			case 'message.account.please_type_email_or_username': return '請輸入郵箱或用戶名';
			case 'message.account.please_type_valid_email': return '請輸入正確的郵箱';
			case 'message.account.please_type_password': return '請輸入密碼';
			case 'message.account.please_type_captcha': return '請輸入驗證碼';
			case 'message.comment.content_empty': return '內容不能為空。';
			case 'message.comment.content_too_long': return '內容不能超過 1000 個字符。';
			case 'message.comment.sent': return '回覆已發送。';
			case 'message.create_thread.title_empty': return '標題不能為空。';
			case 'message.create_thread.title_too_long': return '標題不能太長。';
			case 'message.create_thread.content_empty': return '內容不能為空。';
			case 'message.create_thread.content_too_long': return '內容不能超過 20000 個字符。';
			case 'message.create_thread.created': return '帖子已發送。';
			case 'message.blocked_tags.save_confirm': return '確定保存屏蔽標籤嗎？';
			case 'message.blocked_tags.saved': return '屏蔽標籤已保存。';
			case 'message.blocked_tags.reached_limit': return '屏蔽標籤數量已達到上限。';
			case 'message.playlist.empty_playlist_title': return '播放列表標題不能為空。';
			case 'message.playlist.playlist_created': return '播放列表已創建。';
			case 'message.playlist.playlist_title_edited': return '播放列表標題已修改。';
			case 'message.download.no_provide_storage_permission': return '未提供存儲權限。';
			case 'message.download.task_already_exists': return '下載任務已存在。';
			case 'message.download.task_created': return '下載任務已創建。';
			case 'message.download.maximum_simultaneous_download_reached': return '已達到最大同時下載數。';
			case 'message.update.check_update_failed': return '檢查更新失敗';
			case 'message.update.update_available': return '有新版本可用';
			case 'message.update.already_latest_version': return '已經是最新版本';
			case 'message.update.current_version': return ({required Object version}) => '當前版本：${version}';
			case 'message.update.latest_version': return ({required Object version}) => '最新版本：${version}';
			case 'message.update.view_update': return '查看更新';
			case 'error.retry': return '載入失敗，點擊重試';
			case 'error.fetch_failed': return '無法獲取影片連結';
			case 'error.fetch_user_info_failed': return '無法獲取使用者資訊';
			case 'error.invalid_path': return '無效的路徑';
			case 'error.account.invalid_login': return '郵箱或密碼錯誤';
			case 'error.account.invalid_host': return '無效的主機名';
			case 'error.account.invalid_captcha': return '驗證碼錯誤';
			default: return null;
		}
	}
}
