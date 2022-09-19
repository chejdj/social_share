import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:social_share_plus/src/share_register.dart';

import 'dialog/share_dialog.dart';
import 'share_defines.dart';

typedef PlatformCallback = void Function(int? platformId);

class SharePlugin {
  static const MethodChannel _channel = MethodChannel('social_share_plugin');

  /// 注册方法：
  /// 1. 创建register对象，
  /// 2. 通过register对象的函数设置平台参数，
  /// 3. 通过register注册
  static Future<dynamic> registerPlatforms(ShareRegister register) async {
    return await _channel.invokeMethod(
        "registerPlatforms", register.platformsInfo);
  }

  static Future<dynamic> isClientInstalled(SharePlatform platform) async {
    Map args = {"platform": platform.id};
    return await _channel.invokeMethod("isClientInstalled", args);
  }

  ///分享到渠道
  ///installCallBack :调用端的是否安装成功需要判断
  ///successCallBack :分享成功之后的回调
  ///errorCallBack ：出现error回调
  static void share(
      ShareParamsBean shareParamsBean,
      PlatformCallback notInstallCallBack,
      successCallBack,
      errorCallBack) async {
    // 首先判断应用是否安装
    if (shareParamsBean.platform != SharePlatforms.native) {
      bool isInstalled = await isClientInstalled(shareParamsBean.platform);
      if (!isInstalled) {
        notInstallCallBack(shareParamsBean.platform.id);
        return;
      }
    }
    await _channel
        .invokeMethod("share", shareParamsBean.toChannelMap())
        .then((response) {
      if (response["isShareSuccess"] && successCallBack != null) {
        successCallBack();
      } else {
        debugPrint(
            'share error errorCode ${response['errorCode']} errorMessage ${response['errorMessage']}');
        if (errorCallBack != null) {
          errorCallBack(
              response["errorCode"] ?? ShareErrorCode.ERROR_BEFORE_JUMP,
              response["errorMessage"]);
        }
      }
    }).catchError((error) {
      debugPrint('share error ${error.toString()}');
      if (errorCallBack != null) {
        errorCallBack(ShareErrorCode.ERROR_BEFORE_JUMP);
      }
    });
  }

  ///分享弹窗, 由用户指定分享平台(LaShareParamsBean中指定平台将被覆盖)
  static void startShare(
      {required ShareParamsBean shareParamsBean,
      required BuildContext context,
      PlatformCallback? notInstallCallback,
      successCallback,
      errorCallBack,
      PlatformCallback? selectedCallback}) {
    ShareDialog().showShareDialog(
        shareParamsBean: shareParamsBean,
        context: context,
        notInstallCallBack: notInstallCallback,
        selectedCallback: selectedCallback,
        successCallBack: successCallback,
        errorCallBack: errorCallBack);
  }
}
