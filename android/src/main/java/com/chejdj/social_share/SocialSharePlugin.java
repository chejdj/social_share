package com.chejdj.social_share;

import android.app.Activity;

import androidx.annotation.NonNull;

import com.chejdj.social_share.constants.ShareErrorCode;
import com.chejdj.social_share.constants.ShareTypeConst;
import com.chejdj.social_share.util.PlatformUtil;
import com.chejdj.social_share.util.Utils;

import java.io.File;
import java.util.HashMap;
import java.util.Map;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

/** SocialSharePlugin */
public class SocialSharePlugin implements FlutterPlugin, MethodCallHandler,ActivityAware {
  private Activity activity;
  private BinaryMessenger messenger;
  private MethodChannel channel;

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    messenger = flutterPluginBinding.getBinaryMessenger();
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    activity = null;
    messenger = null;
    channel.setMethodCallHandler(null);
  }

  @Override
  public void onAttachedToActivity(@NonNull ActivityPluginBinding activityPluginBinding) {
    activity = activityPluginBinding.getActivity();
    channel = new MethodChannel(messenger, "social_share_plugin");
    channel.setMethodCallHandler(this);
  }

  @Override
  public void onDetachedFromActivityForConfigChanges() {
  }

  @Override
  public void onReattachedToActivityForConfigChanges(@NonNull ActivityPluginBinding binding) {
  }

  @Override
  public void onDetachedFromActivity() {
  }

  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
    switch (call.method) {
      case "registerPlatforms":
        PlatformShareFactory.registerPlatform(activity, call.<Map<Integer, Map<String, String>>>arguments());
        break;
      case "isClientInstalled":
        PlatformUtil.isClientInstalled(activity, call.<Integer>argument("platform"), result);
        break;
      case "share":
        shareToPlatform(activity, call, result);
        break;
      default:
        result.notImplemented();
        break;
    }
  }

  private void shareToPlatform(Activity activity, MethodCall call, Result result) {
    Integer contentType = call.argument("contentType");
    Integer platformId = call.argument("platform");
    if (contentType == null || platformId == null) {
      resultFail(result, null);
      return;
    }
    String title = call.argument("title");
    String text = call.argument("text");
    String imageFilePath = call.argument("imageFilePath");
    String webUrl = call.argument("webUrl");
    String musicUrl = call.argument("musicUrl");
    String videoUrl = call.argument("videoUrl");
    String filePath = call.argument("filePath");
    String pkgName = call.argument("pkgNameAndroid");
    PlatformShare platformShare = PlatformShareFactory.getPlatformShare(platformId, pkgName);
    File imageFile = Utils.getFileWithPath(imageFilePath);
    File file = Utils.getFileWithPath(filePath);
    if (platformShare == null) {
      resultFail(result, null);
      return;
    }
    switch (contentType) {
      case ShareTypeConst.TEXT:
        platformShare.shareText(text, result, activity);
        break;
      case ShareTypeConst.IMAGE: {
        if (imageFile == null) {
          resultFail(result, "image url needed");
          break;
        }
        platformShare.shareImage(activity, imageFile, result);
        break;
      }
      case ShareTypeConst.WEB_PAGE: {
        if (Utils.isStringNullOrEmpty(webUrl)) {
          resultFail(result, "webUrl needed");
          break;
        }
        platformShare.shareWebpage(webUrl, title, text, imageFile, result, activity);
        break;
      }
      case ShareTypeConst.MUSIC: {
        if (Utils.isStringNullOrEmpty(musicUrl)) {
          resultFail(result, "musicUrl needed");
          break;
        }
        platformShare.shareMusic(musicUrl, title, text, imageFile, result, activity);
        break;
      }
      case ShareTypeConst.VIDEO: {
        if (Utils.isStringNullOrEmpty(videoUrl)) {
          resultFail(result, "musicUrl needed");
          break;
        }
        platformShare.shareVideo(videoUrl, title, text, imageFile, result, activity);
        break;
      }
      case ShareTypeConst.FILE: {
        if (file == null) {
          resultFail(result, "file url needed");
          break;
        }
        platformShare.shareFile(file, title, text, activity, result);
      }
      default: {
        break;
      }
    }
  }

  public static void resultFail(Result result, String errorMessage) {
    resultFail(result, ShareErrorCode.ERROR_BEFORE_JUMP, errorMessage);
  }

  public static void resultFail(Result result, String errorCode, String errorMessage) {
    result.success(generateResultMap(false, errorCode, errorMessage));
  }

  public static void resultSuccess(Result result) {
    result.success(generateResultMap(true, null, null));
  }

  public static Map<String, Object> generateResultMap(boolean isSuccess, String errorCode, String errorMessage) {
    final Map<String, Object> map = new HashMap<>();
    map.put("isShareSuccess", isSuccess);
    map.put("errorCode", errorCode);
    map.put("errorMessage", errorMessage);
    return map;
  }
}
