import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:social_share_plus/src/share_defines.dart';
import 'package:social_share_plus/src/share_plugin.dart';

import '../utils/adapt.dart';
import 'share_factory.dart';

class ShareDialog {
  final Map<Language, String> _title = ShareFactory.buildTitle();
  final Map<Language, String> _bottomBtn = ShareFactory.buildBottomBtnText();
  final List<ShareItem> _shareItems = ShareFactory.buildShareItems();

  void showShareDialog(
      {required ShareParamsBean shareParamsBean,
      required BuildContext context,
      PlatformCallback? notInstallCallBack,
      successCallBack,
      errorCallBack,
      PlatformCallback? selectedCallback}) {
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) {
          return Container(
            clipBehavior: Clip.antiAlias,
            padding: EdgeInsets.only(
                top: Adapt.px(49), right: Adapt.px(43), left: Adapt.px(43)),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(Adapt.px(43)),
                    topRight: Radius.circular(Adapt.px(43)))),
            height: MediaQuery.of(context).size.height * 0.25,
            child: Column(
              children: [
                Container(
                  alignment: Alignment.topLeft,
                  child: Text(
                    _title[shareParamsBean.language]!,
                    style: TextStyle(
                      color: const Color(0xff333333),
                      fontWeight: FontWeight.bold,
                      fontSize: Adapt.fz(40),
                    ),
                  ),
                ),
                Container(height: Adapt.px(43)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: buildShareItems(
                      context,
                      shareParamsBean,
                      notInstallCallBack,
                      successCallBack,
                      errorCallBack,
                      selectedCallback),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 30),
                  height: Adapt.px(3),
                  decoration: const BoxDecoration(color: Color(0x12000000)),
                ),
                TextButton(
                  style: ButtonStyle(
                      padding: MaterialStateProperty.all<EdgeInsets>(
                          const EdgeInsets.all(0.0))),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    height: Adapt.px(130),
                    width: double.infinity,
                    alignment: Alignment.center,
                    child: Text(
                      _bottomBtn[shareParamsBean.language]!,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: const Color(0xff333333),
                          fontSize: Adapt.fz(43),
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }

  List<Widget> buildShareItems(
      BuildContext context,
      ShareParamsBean shareParamsBean,
      notInstallCallBack,
      successCallBack,
      errorCallBack,
      PlatformCallback? selectedCallback) {
    List<Widget> items = List<Widget>.empty(growable: true);
    for (var element in _shareItems) {
      items.add(GestureDetector(
          child: Column(
            children: [
              Image.asset(element.icon,
                  width: Adapt.px(127),
                  height: Adapt.px(127),
                  package: 'social_share_plus'),
              Container(
                margin: EdgeInsets.only(top: Adapt.px(26)),
                child: Text(
                  element.iconDes[shareParamsBean.language]!,
                  style: TextStyle(
                      color: const Color(0xff666666), fontSize: Adapt.fz(32)),
                ),
              )
            ],
          ),
          onTap: () {
            if (selectedCallback != null) {
              selectedCallback(element.platform?.id);
            }
            if (element.platform == null) {
              Clipboard.setData(ClipboardData(text: shareParamsBean.text));
              successCallBack();
              Navigator.of(context).pop();
              return;
            }

            /// share webpageType only support Wechat, others platforms are 'text' content type
            if (shareParamsBean.contentType.value ==
                    LaShareContentTypes.webpage.value &&
                element.platform?.id != SharePlatforms.facebook.id &&
                element.platform?.id != SharePlatforms.wechatTimeline.id &&
                element.platform?.id != SharePlatforms.wechatSession.id) {
              SharePlugin.share(
                  ShareParamsBean(
                      contentType: LaShareContentTypes.text,
                      platform: element.platform!,
                      title: shareParamsBean.title,
                      text: shareParamsBean.text,
                      imageFilePath: shareParamsBean.imageFilePath,
                      webUrl: shareParamsBean.webUrl,
                      musicUrl: shareParamsBean.musicUrl,
                      videoUrl: shareParamsBean.videoUrl,
                      pkgNameAndroid: shareParamsBean.pkgNameAndroid),
                  notInstallCallBack,
                  successCallBack,
                  errorCallBack);
              Navigator.of(context).pop();
              return;
            }
            SharePlugin.share(
                ShareParamsBean(
                    contentType: shareParamsBean.contentType,
                    platform: element.platform!,
                    title: shareParamsBean.title,
                    text: shareParamsBean.text,
                    imageFilePath: shareParamsBean.imageFilePath,
                    webUrl: shareParamsBean.webUrl,
                    musicUrl: shareParamsBean.musicUrl,
                    videoUrl: shareParamsBean.videoUrl,
                    pkgNameAndroid: shareParamsBean.pkgNameAndroid),
                notInstallCallBack,
                successCallBack,
                errorCallBack);
            Navigator.of(context).pop();
          }));
    }
    return items;
  }
}
