class ShareParamsBean {
  /// webpage 类型可选
  final String? title;

  /// text 类型必须传，webpage 类型可选
  final String? text;

  /// image 类型必须传，webpage 类型可选
  final String? imageFilePath;

  /// webpage 类型必须传
  final String? webUrl;
  final String? musicUrl;
  final String? videoUrl;

  /// file 类型必须传
  final String? filePath;
  final ShareContentType contentType;
  final SharePlatform platform;

  /// Android 包名，用于在系统分享时指定包名
  final String? pkgNameAndroid;

  /// 分享弹窗多语言适配可选，默认英文
  final Language language;

  ShareParamsBean(
      {this.title,
      this.text,
      this.imageFilePath,
      this.webUrl,
      this.musicUrl,
      this.videoUrl,
      this.filePath,
      this.pkgNameAndroid,
      this.language = Language.EN,
      required this.contentType,
      required this.platform});

  Map<String, Object?> toChannelMap() {
    final Map<String, Object?> result = {};
    result['title'] = title;
    result['text'] = text;
    result['imageFilePath'] = imageFilePath;
    result['webUrl'] = webUrl;
    result['musicUrl'] = musicUrl;
    result['videoUrl'] = videoUrl;
    result['filePath'] = filePath;
    result['contentType'] = contentType.value;
    result['platform'] = platform.id;
    result['pkgNameAndroid'] = pkgNameAndroid;
    return result;
  }
}

class ShareContentType {
  ShareContentType({this.value}) : super();
  final int? value;
}

/// supported share content types
class LaShareContentTypes extends Object {
  static ShareContentType get text => ShareContentType(value: 0);

  static ShareContentType get image => ShareContentType(value: 1);

  static ShareContentType get webpage => ShareContentType(value: 2);

  static ShareContentType get music => ShareContentType(value: 3);

  static ShareContentType get video => ShareContentType(value: 4);

  static ShareContentType get file => ShareContentType(value: 5);
}

class SharePlatform {
  SharePlatform({required this.id, required this.name}) : super();
  final int id;
  final String name;
}

class SharePlatforms {
  static final SharePlatform native = SharePlatform(name: "native", id: 0);
  static final SharePlatform wechatSession =
      SharePlatform(name: "wechatSession", id: 1);
  static final SharePlatform wechatTimeline =
      SharePlatform(name: "wechatTimeline", id: 2);
  static final SharePlatform facebook = SharePlatform(name: "facebook", id: 3);
  static final SharePlatform twitter = SharePlatform(name: "twitter", id: 4);
  static final SharePlatform whatsApp = SharePlatform(name: "whatsApp", id: 5);
  static final SharePlatform line = SharePlatform(name: "line", id: 6);

  static SharePlatform getPlatformWithId(int id) {
    if (id == wechatSession.id) return wechatSession;
    if (id == wechatTimeline.id) return wechatTimeline;
    if (id == facebook.id) return facebook;
    if (id == twitter.id) return twitter;
    if (id == whatsApp.id) return whatsApp;
    if (id == line.id) return line;
    return native;
  }
}

class ShareErrorCode {
  /// 跳转到第三方 app 之前发生错误
  // ignore: constant_identifier_names
  static const String ERROR_BEFORE_JUMP = "101";

  /// 跳转后发生错误，用于支持回调的第三方 app 分享
  // ignore: constant_identifier_names
  static const String ERROR_AFTER_JUMP = "102";

  /// 取消分享，用于支持回调的第三方 app 分享
  // ignore: constant_identifier_names
  static const String CANCELED = "103";
}

// ignore: constant_identifier_names
enum Language { EN, CN }
