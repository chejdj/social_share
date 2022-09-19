import 'share_defines.dart';

/// Model used to register the platforms
class ShareRegister {
  static const String _appId = "appId";
  static const String _appSecret = "appSecret";
  static const String _appUniversalLink = "appUniversalLink";

  final Map<int, Map<String, String>> platformsInfo = {};

  /// set up wechat platform info
  void setupWechat(String appId, String appSecret, String appUniversalLink) {
    _setupPlatform(
        SharePlatforms.wechatSession.id, appId, appSecret, appUniversalLink);
  }

  void _setupPlatform(
      int platformId, String appId, String appSecret, String appUniversalLink) {
    Map<String, String> info = {
      _appId: appId,
      _appSecret: appSecret,
      _appUniversalLink: appUniversalLink
    };
    platformsInfo[platformId] = info;
  }

  /// set up facebook platform info
  void setupFacebook(String appId, String appSecret, String appUniversalLink) {
    _setupPlatform(
        SharePlatforms.facebook.id, appId, appSecret, appUniversalLink);
  }

  /// set up twitter platform info
  void setupTwitter(String appId, String appSecret, String appUniversalLink) {
    _setupPlatform(
        SharePlatforms.twitter.id, appId, appSecret, appUniversalLink);
  }
}
