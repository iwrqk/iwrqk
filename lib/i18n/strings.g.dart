/// Generated file. Do not edit.
///
/// Original: lib/i18n
/// To regenerate, run: `dart run slang`
///
/// Locales: 2
/// Strings: 404 (202 per locale)
///
/// Built on 2024-01-25 at 17:20 UTC

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
	zhCn(languageCode: 'zh', countryCode: 'CN', build: _StringsZhCn.build);

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
		'zh-CN': 'Chinese (Simplified)',
	};
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
	late final _StringsDisplayModeEn display_mode = _StringsDisplayModeEn._(_root);
	late final _StringsProxyEn proxy = _StringsProxyEn._(_root);
	late final _StringsMessageEn message = _StringsMessageEn._(_root);
	late final _StringsErrorEn error = _StringsErrorEn._(_root);
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
}

// Path: playlist
class _StringsPlaylistEn {
	_StringsPlaylistEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => 'Playlist title';
	String get create => 'Create playlist';
	String get select => 'Select playlist';
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
	String get theme_desc => 'Change the theme of the App.';
	String get language => 'Language';
	String get language_desc => 'Change the language of the App.';
	String get display_mode => 'Display Mode';
	String get display_mode_desc => 'Change the display mode of the App.';
	String get work_mode => 'Work Mode';
	String get work_mode_desc => 'Hide all covers of NSFW content.';
	String get network => 'Network';
	String get enable_proxy => 'Enable Proxy';
	String get enable_proxy_desc => 'Enable proxy for the App.';
	String get proxy => 'Proxy';
	String get proxy_desc => 'Set the host and port of the proxy.';
	String get player => 'Player';
	String get autoplay => 'Autoplay';
	String get autoplay_desc => 'Autoplay video when opening a video page.';
	String get about => 'About';
	String get thrid_party_license => 'Third Party License';
	String get thrid_party_license_desc => 'View the license of third party libraries.';
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
}

// Path: error
class _StringsErrorEn {
	_StringsErrorEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get retry => 'Load failed, click to retry.';
	String get fetch_failed => 'Failed to fetch video links.';
	String get fetch_user_info_failed => 'Failed to fetch user info.';
	late final _StringsErrorAccountEn account = _StringsErrorAccountEn._(_root);
}

// Path: search.history
class _StringsSearchHistoryEn {
	_StringsSearchHistoryEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get delete => 'Delete All';
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
class _StringsZhCn implements Translations {
	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	_StringsZhCn.build({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  $meta = TranslationMetadata(
		    locale: AppLocale.zhCn,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ) {
		$meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <zh-CN>.
	@override final TranslationMetadata<AppLocale, Translations> $meta;

	/// Access flat map
	@override dynamic operator[](String key) => $meta.getTranslation(key);

	@override late final _StringsZhCn _root = this; // ignore: unused_field

	// Translations
	@override Map<String, String> get locales => {
		'en': '英语',
		'zh-CN': '简体中文',
	};
	@override late final _StringsNavZhCn nav = _StringsNavZhCn._(_root);
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
	@override late final _StringsDisplayModeZhCn display_mode = _StringsDisplayModeZhCn._(_root);
	@override late final _StringsProxyZhCn proxy = _StringsProxyZhCn._(_root);
	@override late final _StringsMessageZhCn message = _StringsMessageZhCn._(_root);
	@override late final _StringsErrorZhCn error = _StringsErrorZhCn._(_root);
}

// Path: nav
class _StringsNavZhCn implements _StringsNavEn {
	_StringsNavZhCn._(this._root);

	@override final _StringsZhCn _root; // ignore: unused_field

	// Translations
	@override String get subscriptions => '订阅';
	@override String get videos => '视频';
	@override String get images => '图片';
	@override String get forum => '论坛';
	@override String get search => '搜索';
}

// Path: common
class _StringsCommonZhCn implements _StringsCommonEn {
	_StringsCommonZhCn._(this._root);

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
class _StringsRefreshZhCn implements _StringsRefreshEn {
	_StringsRefreshZhCn._(this._root);

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
class _StringsRecordsZhCn implements _StringsRecordsEn {
	_StringsRecordsZhCn._(this._root);

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
class _StringsAccountZhCn implements _StringsAccountEn {
	_StringsAccountZhCn._(this._root);

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
class _StringsProfileZhCn implements _StringsProfileEn {
	_StringsProfileZhCn._(this._root);

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
class _StringsSortZhCn implements _StringsSortEn {
	_StringsSortZhCn._(this._root);

	@override final _StringsZhCn _root; // ignore: unused_field

	// Translations
	@override String get latest => '最新';
	@override String get trending => '流行';
	@override String get popularity => '人气';
	@override String get most_views => '最多观看';
	@override String get most_likes => '最多点赞';
}

// Path: filter
class _StringsFilterZhCn implements _StringsFilterEn {
	_StringsFilterZhCn._(this._root);

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
class _StringsSearchZhCn implements _StringsSearchEn {
	_StringsSearchZhCn._(this._root);

	@override final _StringsZhCn _root; // ignore: unused_field

	// Translations
	@override String get users => '用户';
	@override String get search => '搜索';
	@override late final _StringsSearchHistoryZhCn history = _StringsSearchHistoryZhCn._(_root);
}

// Path: time
class _StringsTimeZhCn implements _StringsTimeEn {
	_StringsTimeZhCn._(this._root);

	@override final _StringsZhCn _root; // ignore: unused_field

	// Translations
	@override String seconds_ago({required Object time}) => '${time} 秒前';
	@override String minutes_ago({required Object time}) => '${time} 分钟前';
	@override String hours_ago({required Object time}) => '${time} 小时前';
	@override String days_ago({required Object time}) => '${time} 天前';
}

// Path: media
class _StringsMediaZhCn implements _StringsMediaEn {
	_StringsMediaZhCn._(this._root);

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

// Path: comment
class _StringsCommentZhCn implements _StringsCommentEn {
	_StringsCommentZhCn._(this._root);

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
class _StringsUserZhCn implements _StringsUserEn {
	_StringsUserZhCn._(this._root);

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
class _StringsFriendZhCn implements _StringsFriendEn {
	_StringsFriendZhCn._(this._root);

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
class _StringsBlockedTagsZhCn implements _StringsBlockedTagsEn {
	_StringsBlockedTagsZhCn._(this._root);

	@override final _StringsZhCn _root; // ignore: unused_field

	// Translations
	@override String get add_blocked_tag => '添加屏蔽标签';
	@override String get blocked_tag => '屏蔽标签';
}

// Path: download
class _StringsDownloadZhCn implements _StringsDownloadEn {
	_StringsDownloadZhCn._(this._root);

	@override final _StringsZhCn _root; // ignore: unused_field

	// Translations
	@override String get create_download_task => '创建下载任务';
	@override String get unknown => '未知';
	@override String get enqueued => '等待中';
	@override String get downloading => '下载中';
	@override String get paused => '已暂停';
	@override String get finished => '已完成';
	@override String get failed => '下载失败';
}

// Path: playlist
class _StringsPlaylistZhCn implements _StringsPlaylistEn {
	_StringsPlaylistZhCn._(this._root);

	@override final _StringsZhCn _root; // ignore: unused_field

	// Translations
	@override String get title => '播放列表标题';
	@override String get create => '创建播放列表';
	@override String get select => '选择播放列表';
	@override String videos_count({required Object numVideo}) => '${numVideo} 个视频';
	@override String videos_count_plural({required Object numVideo}) => '${numVideo} 个视频';
}

// Path: channel
class _StringsChannelZhCn implements _StringsChannelEn {
	_StringsChannelZhCn._(this._root);

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
class _StringsCreateThreadZhCn implements _StringsCreateThreadEn {
	_StringsCreateThreadZhCn._(this._root);

	@override final _StringsZhCn _root; // ignore: unused_field

	// Translations
	@override String get create_thread => '发帖';
	@override String get title => '标题';
	@override String get content => '内容';
}

// Path: notifications
class _StringsNotificationsZhCn implements _StringsNotificationsEn {
	_StringsNotificationsZhCn._(this._root);

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
class _StringsSettingsZhCn implements _StringsSettingsEn {
	_StringsSettingsZhCn._(this._root);

	@override final _StringsZhCn _root; // ignore: unused_field

	// Translations
	@override String get appearance => '外观设置';
	@override String get theme => '主题';
	@override String get theme_desc => '设置应用的主题';
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
	@override String get about => '关于';
	@override String get thrid_party_license => '第三方库许可';
	@override String get thrid_party_license_desc => '查看第三方库的许可证';
}

// Path: theme
class _StringsThemeZhCn implements _StringsThemeEn {
	_StringsThemeZhCn._(this._root);

	@override final _StringsZhCn _root; // ignore: unused_field

	// Translations
	@override String get system => '跟随系统';
	@override String get light => '浅色';
	@override String get dark => '深色';
}

// Path: display_mode
class _StringsDisplayModeZhCn implements _StringsDisplayModeEn {
	_StringsDisplayModeZhCn._(this._root);

	@override final _StringsZhCn _root; // ignore: unused_field

	// Translations
	@override String get no_available => '无可用显示模式';
	@override String get auto => '自动';
	@override String get system => '系统';
}

// Path: proxy
class _StringsProxyZhCn implements _StringsProxyEn {
	_StringsProxyZhCn._(this._root);

	@override final _StringsZhCn _root; // ignore: unused_field

	// Translations
	@override String get host => '主机名';
	@override String get port => '端口';
}

// Path: message
class _StringsMessageZhCn implements _StringsMessageEn {
	_StringsMessageZhCn._(this._root);

	@override final _StringsZhCn _root; // ignore: unused_field

	// Translations
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
}

// Path: error
class _StringsErrorZhCn implements _StringsErrorEn {
	_StringsErrorZhCn._(this._root);

	@override final _StringsZhCn _root; // ignore: unused_field

	// Translations
	@override String get retry => '加载失败，点击重试';
	@override String get fetch_failed => '无法获取视频链接';
	@override String get fetch_user_info_failed => '无法获取用户信息';
	@override late final _StringsErrorAccountZhCn account = _StringsErrorAccountZhCn._(_root);
}

// Path: search.history
class _StringsSearchHistoryZhCn implements _StringsSearchHistoryEn {
	_StringsSearchHistoryZhCn._(this._root);

	@override final _StringsZhCn _root; // ignore: unused_field

	// Translations
	@override String get delete => '删除所有记录';
}

// Path: message.account
class _StringsMessageAccountZhCn implements _StringsMessageAccountEn {
	_StringsMessageAccountZhCn._(this._root);

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
class _StringsMessageCommentZhCn implements _StringsMessageCommentEn {
	_StringsMessageCommentZhCn._(this._root);

	@override final _StringsZhCn _root; // ignore: unused_field

	// Translations
	@override String get content_empty => '内容不能为空。';
	@override String get content_too_long => '内容不能超过 1000 个字符。';
	@override String get sent => '回复已发送。';
}

// Path: message.create_thread
class _StringsMessageCreateThreadZhCn implements _StringsMessageCreateThreadEn {
	_StringsMessageCreateThreadZhCn._(this._root);

	@override final _StringsZhCn _root; // ignore: unused_field

	// Translations
	@override String get title_empty => '标题不能为空。';
	@override String get title_too_long => '标题不能过长。';
	@override String get content_empty => '内容不能为空。';
	@override String get content_too_long => '内容不能超过 20000 个字符。';
	@override String get created => '帖子已发送。';
}

// Path: message.blocked_tags
class _StringsMessageBlockedTagsZhCn implements _StringsMessageBlockedTagsEn {
	_StringsMessageBlockedTagsZhCn._(this._root);

	@override final _StringsZhCn _root; // ignore: unused_field

	// Translations
	@override String get save_confirm => '确定保存屏蔽标签吗？';
	@override String get saved => '屏蔽标签已保存。';
	@override String get reached_limit => '屏蔽标签数量已达到上限。';
}

// Path: message.playlist
class _StringsMessagePlaylistZhCn implements _StringsMessagePlaylistEn {
	_StringsMessagePlaylistZhCn._(this._root);

	@override final _StringsZhCn _root; // ignore: unused_field

	// Translations
	@override String get empty_playlist_title => '播放列表标题不能为空。';
	@override String get playlist_created => '播放列表已创建。';
}

// Path: message.download
class _StringsMessageDownloadZhCn implements _StringsMessageDownloadEn {
	_StringsMessageDownloadZhCn._(this._root);

	@override final _StringsZhCn _root; // ignore: unused_field

	// Translations
	@override String get no_provide_storage_permission => '未提供存储权限。';
	@override String get task_already_exists => '下载任务已存在。';
	@override String get task_created => '下载任务已创建。';
	@override String get maximum_simultaneous_download_reached => '已达到最大同时下载数。';
}

// Path: error.account
class _StringsErrorAccountZhCn implements _StringsErrorAccountEn {
	_StringsErrorAccountZhCn._(this._root);

	@override final _StringsZhCn _root; // ignore: unused_field

	// Translations
	@override String get invalid_login => '邮箱或密码错误';
	@override String get invalid_host => '无效的主机名';
	@override String get invalid_captcha => '验证码错误';
}

/// Flat map(s) containing all translations.
/// Only for edge cases! For simple maps, use the map function of this library.

extension on Translations {
	dynamic _flatMapFunction(String path) {
		switch (path) {
			case 'locales.en': return 'English';
			case 'locales.zh-CN': return 'Chinese (Simplified)';
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
			case 'playlist.title': return 'Playlist title';
			case 'playlist.create': return 'Create playlist';
			case 'playlist.select': return 'Select playlist';
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
			case 'settings.theme_desc': return 'Change the theme of the App.';
			case 'settings.language': return 'Language';
			case 'settings.language_desc': return 'Change the language of the App.';
			case 'settings.display_mode': return 'Display Mode';
			case 'settings.display_mode_desc': return 'Change the display mode of the App.';
			case 'settings.work_mode': return 'Work Mode';
			case 'settings.work_mode_desc': return 'Hide all covers of NSFW content.';
			case 'settings.network': return 'Network';
			case 'settings.enable_proxy': return 'Enable Proxy';
			case 'settings.enable_proxy_desc': return 'Enable proxy for the App.';
			case 'settings.proxy': return 'Proxy';
			case 'settings.proxy_desc': return 'Set the host and port of the proxy.';
			case 'settings.player': return 'Player';
			case 'settings.autoplay': return 'Autoplay';
			case 'settings.autoplay_desc': return 'Autoplay video when opening a video page.';
			case 'settings.about': return 'About';
			case 'settings.thrid_party_license': return 'Third Party License';
			case 'settings.thrid_party_license_desc': return 'View the license of third party libraries.';
			case 'theme.system': return 'System';
			case 'theme.light': return 'Light';
			case 'theme.dark': return 'Dark';
			case 'display_mode.no_available': return 'No available display mode';
			case 'display_mode.auto': return 'Auto';
			case 'display_mode.system': return 'System';
			case 'proxy.host': return 'Host';
			case 'proxy.port': return 'Port';
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
			case 'message.download.no_provide_storage_permission': return 'No storage permission provided.';
			case 'message.download.task_already_exists': return 'Download task already exists.';
			case 'message.download.task_created': return 'Download task created.';
			case 'message.download.maximum_simultaneous_download_reached': return 'Maximum simultaneous download reached.';
			case 'error.retry': return 'Load failed, click to retry.';
			case 'error.fetch_failed': return 'Failed to fetch video links.';
			case 'error.fetch_user_info_failed': return 'Failed to fetch user info.';
			case 'error.account.invalid_login': return 'Invalid email or password.';
			case 'error.account.invalid_host': return 'Invalid host.';
			case 'error.account.invalid_captcha': return 'Invalid captcha.';
			default: return null;
		}
	}
}

extension on _StringsZhCn {
	dynamic _flatMapFunction(String path) {
		switch (path) {
			case 'locales.en': return '英语';
			case 'locales.zh-CN': return '简体中文';
			case 'nav.subscriptions': return '订阅';
			case 'nav.videos': return '视频';
			case 'nav.images': return '图片';
			case 'nav.forum': return '论坛';
			case 'nav.search': return '搜索';
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
			case 'playlist.title': return '播放列表标题';
			case 'playlist.create': return '创建播放列表';
			case 'playlist.select': return '选择播放列表';
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
			case 'settings.about': return '关于';
			case 'settings.thrid_party_license': return '第三方库许可';
			case 'settings.thrid_party_license_desc': return '查看第三方库的许可证';
			case 'theme.system': return '跟随系统';
			case 'theme.light': return '浅色';
			case 'theme.dark': return '深色';
			case 'display_mode.no_available': return '无可用显示模式';
			case 'display_mode.auto': return '自动';
			case 'display_mode.system': return '系统';
			case 'proxy.host': return '主机名';
			case 'proxy.port': return '端口';
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
			case 'message.download.no_provide_storage_permission': return '未提供存储权限。';
			case 'message.download.task_already_exists': return '下载任务已存在。';
			case 'message.download.task_created': return '下载任务已创建。';
			case 'message.download.maximum_simultaneous_download_reached': return '已达到最大同时下载数。';
			case 'error.retry': return '加载失败，点击重试';
			case 'error.fetch_failed': return '无法获取视频链接';
			case 'error.fetch_user_info_failed': return '无法获取用户信息';
			case 'error.account.invalid_login': return '邮箱或密码错误';
			case 'error.account.invalid_host': return '无效的主机名';
			case 'error.account.invalid_captcha': return '验证码错误';
			default: return null;
		}
	}
}
