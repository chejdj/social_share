import '../share_defines.dart';

class ShareFactory {
  static Map<Language, String> buildTitle() {
    return {Language.EN: "Share to", Language.CN: "分享到"};
  }

  static Map<Language, String> buildBottomBtnText() {
    return {Language.EN: "Cancel", Language.CN: "取消"};
  }

  static List<ShareItem> buildShareItems() {
    return [
      ShareItem(
          icon: 'assets/wechat.png',
          iconDes: {Language.EN: "Wechat", Language.CN: "微信"},
          platform: SharePlatforms.wechatSession),
      ShareItem(
          icon: 'assets/wechat_moments.png',
          iconDes: {Language.EN: "Monments", Language.CN: "朋友圈"},
          platform: SharePlatforms.wechatTimeline),
      ShareItem(
          icon: 'assets/facebook.png',
          iconDes: {Language.EN: "Facebook", Language.CN: "Facebook"},
          platform: SharePlatforms.facebook),
      ShareItem(
          icon: 'assets/whatsapp.png',
          iconDes: {Language.EN: "Whatsapp", Language.CN: "Whatsapp"},
          platform: SharePlatforms.whatsApp),
      ShareItem(
          icon: 'assets/copy_linker.png',
          iconDes: {Language.EN: "Copy link", Language.CN: "复制链接"})
    ];
  }
}

class ShareItem {
  final String icon;
  final Map<Language, String> iconDes;
  final SharePlatform? platform;
  ShareItem({required this.icon, required this.iconDes, this.platform});
}
