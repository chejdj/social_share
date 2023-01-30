import 'share_defines.dart';

/// Model used to register the platforms
class ShareRegister {
  static const String _appId = "appId";
  static const String _appUniversalLink = "appUniversalLink";

  final Map<int, Map<String, String>> platformsInfo = {};

  /// set up wechat platform info
  void setupWechat(String appId, String appUniversalLink) {
    _setupPlatform(SharePlatforms.wechatSession.id, appId, appUniversalLink);
  }

  void _setupPlatform(int platformId, String appId, String appUniversalLink) {
    Map<String, String> info = {
      _appId: appId,
      _appUniversalLink: appUniversalLink
    };
    platformsInfo[platformId] = info;
  }
}
