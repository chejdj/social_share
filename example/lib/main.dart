import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:bot_toast/bot_toast.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:social_share_plus/social_share.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _imageUrl =
      "https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fyouimg1.c-ctrip.com%2Ftarget%2Ftg%2F004%2F531%2F381%2F4339f96900344574a0c8ca272a7b8f27.jpg&refer=http%3A%2F%2Fyouimg1.c-ctrip.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=jpeg?sec=1619144668&t=963700eceb2ea65e6b85b56d53fb92ea";
  final _webpageUrl = "https://www.baidu.com/";
  final _imageUrlForWeb =
      "https://cdn.lingoace.com/image/pub/default-avatar-st.jpg";

  @override
  void initState() {
    super.initState();
    _registerPlatform();
  }

  void _registerPlatform() {
    ShareRegister register = ShareRegister();
    register.setupWechat("wx13bba80f4a585352",
        "1f88b2da6eb79e7115b4fe7274641ad9", "https://ksoub.share2dlink.com/");
    register.setupFacebook(
        "786751755425259", "59827b76294e1bde356cddb1e1808010", "shareSDK");
    register.setupTwitter("viOnkeLpHBKs6KXV7MPpeGyzE",
        "NJEglQUy2rqZ9Io9FcAU9p17omFqbORknUpRrCDOK46aAbIiey", "http://mob.com");

    ///如果后面接入其他平台分享在这里再加上对应平台初始化注册代码
    SharePlugin.registerPlatforms(register);
  }

  final PlatformCallback _notInstallCallback = (int? platformId) {
    BotToast.showText(text: "未安装");
  };

  final Function _successCallback = () {
    BotToast.showText(text: "分享成功");
  };

  final Function _errorCallback = (String code, {String? message}) {
    BotToast.showText(text: "分享失败：$code");
  };

  Future<ShareParamsBean> _buildImageBean(SharePlatform platform,
      {String? pkgName}) async {
    var response = await Dio()
        .get(_imageUrl, options: Options(responseType: ResponseType.bytes));
    File file = await createFileOfPdfUrl(Uint8List.fromList(response.data));
    return ShareParamsBean(
      contentType: LaShareContentTypes.image,
      platform: platform,
      imageFilePath: file.path,
      pkgNameAndroid: pkgName,
    );
  }

  Future<ShareParamsBean> _buildWebpageBean(SharePlatform platform,
      {String? pkgName}) async {
    var response = await Dio().get(_imageUrlForWeb,
        options: Options(responseType: ResponseType.bytes));
    File file = await createFileOfPdfUrl(Uint8List.fromList(response.data));
    return ShareParamsBean(
      contentType: LaShareContentTypes.webpage,
      platform: platform,
      imageFilePath: file.path,
      webUrl: _webpageUrl,
      title: "这是标题",
      text: "这是描述",
      pkgNameAndroid: pkgName,
    );
  }

  @override
  Widget build(BuildContext context) {
    final botToastBuilder = BotToastInit(); //1.调用BotToastInit
    return MaterialApp(
      builder: (context, child) {
        return botToastBuilder(context, child);
      },
      home: Builder(builder: (BuildContext context) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Plugin example app'),
          ),
          body: Column(
            children: <Widget>[
              MaterialButton(
                child: const Text("分享图片到微信好友"),
                onPressed: () async {
                  SharePlugin.share(
                      await _buildImageBean(SharePlatforms.wechatSession),
                      _notInstallCallback,
                      _successCallback,
                      _errorCallback);
                },
              ),
              MaterialButton(
                child: const Text("分享图片到朋友圈"),
                onPressed: () async {
                  SharePlugin.share(
                      await _buildImageBean(SharePlatforms.wechatTimeline),
                      _notInstallCallback,
                      _successCallback,
                      _errorCallback);
                },
              ),
              MaterialButton(
                child: const Text("分享图片到 facebook"),
                onPressed: () async {
                  SharePlugin.share(
                      await _buildImageBean(SharePlatforms.facebook),
                      _notInstallCallback,
                      _successCallback,
                      _errorCallback);
                },
              ),
              MaterialButton(
                child: const Text("分享图片到 whatsapp"),
                onPressed: () async {
                  SharePlugin.share(
                      await _buildImageBean(SharePlatforms.whatsApp),
                      _notInstallCallback,
                      _successCallback,
                      _errorCallback);
                },
              ),
              MaterialButton(
                child: const Text("分享图片到 twitter"),
                onPressed: () async {
                  SharePlugin.share(
                      await _buildImageBean(SharePlatforms.twitter),
                      _notInstallCallback,
                      _successCallback,
                      _errorCallback);
                },
              ),
              MaterialButton(
                child: const Text("分享图片到 line"),
                onPressed: () async {
                  SharePlugin.share(await _buildImageBean(SharePlatforms.line),
                      _notInstallCallback, _successCallback, _errorCallback);
                },
              ),
              MaterialButton(
                child: const Text("分享图片到 native"),
                onPressed: () async {
                  SharePlugin.share(
                      await _buildImageBean(SharePlatforms.native),
                      _notInstallCallback,
                      _successCallback,
                      _errorCallback);
                },
              ),
              MaterialButton(
                child: const Text("分享网页到微信好友"),
                onPressed: () async {
                  SharePlugin.share(
                      await _buildWebpageBean(SharePlatforms.wechatSession),
                      _notInstallCallback,
                      _successCallback,
                      _errorCallback);
                },
              ),
              MaterialButton(
                child: const Text("分享网页到朋友圈"),
                onPressed: () async {
                  SharePlugin.share(
                      await _buildWebpageBean(SharePlatforms.wechatTimeline),
                      _notInstallCallback,
                      _successCallback,
                      _errorCallback);
                },
              ),
              MaterialButton(
                child: const Text("分享网页到 facebook"),
                onPressed: () async {
                  SharePlugin.share(
                      await _buildWebpageBean(SharePlatforms.facebook),
                      _notInstallCallback,
                      _successCallback,
                      _errorCallback);
                },
              ),
              MaterialButton(
                child: const Text("分享网页到 whatsApp"),
                onPressed: () async {
                  SharePlugin.share(
                      await _buildWebpageBean(SharePlatforms.whatsApp),
                      _notInstallCallback,
                      _successCallback,
                      _errorCallback);
                },
              ),
              MaterialButton(
                child: const Text("分享网页到 twitter"),
                onPressed: () async {
                  SharePlugin.share(
                      await _buildWebpageBean(SharePlatforms.twitter),
                      _notInstallCallback,
                      _successCallback,
                      _errorCallback);
                },
              ),
              MaterialButton(
                child: const Text("分享网页到 line"),
                onPressed: () async {
                  SharePlugin.share(
                      await _buildWebpageBean(SharePlatforms.line),
                      _notInstallCallback,
                      _successCallback,
                      _errorCallback);
                },
              ),
              MaterialButton(
                child: const Text("分享网页到 native"),
                onPressed: () async {
                  SharePlugin.share(
                      await _buildWebpageBean(SharePlatforms.native),
                      _notInstallCallback,
                      _successCallback,
                      _errorCallback);
                },
              ),
              MaterialButton(
                child: const Text("分享弹窗"),
                onPressed: () async {
                  SharePlugin.startShare(
                      shareParamsBean:
                          await _buildWebpageBean(SharePlatforms.native),
                      notInstallCallback: _notInstallCallback,
                      successCallback: _successCallback,
                      errorCallBack: _errorCallback,
                      context: context);
                },
              ),
            ],
          ),
        );
      }),
    );
  }

  static Future<File> writeToFile(var data, String path) async {
    final buffer = data.buffer;
    return File(path).writeAsBytes(
        buffer.asUint8List(data.offsetInBytes, data.lengthInBytes),
        flush: true);
  }

  static Future<File> createFileOfPdfUrl(var bytes) async {
    var dir = (await getTemporaryDirectory()).path + "/imageShare";
    Directory directory = Directory(dir);
    if (!directory.existsSync()) {
      directory.createSync();
    }
    String filePath = "${DateTime.now().millisecondsSinceEpoch}.jpg";

    File file = await writeToFile(bytes, '$dir/$filePath');
    return file;
  }
}
