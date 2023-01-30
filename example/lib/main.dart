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
      'https://images.ctfassets.net/41derkrb00ei/56TMtTb175hK9WydTsxkbN/bc9081f8bacca79faed82f1755c5c8a3/_______________1-0118______.png';
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
    register.setupWechat(
        "wx66192691ae27148b", "https://pplingo.page.link/UdTB/");
    SharePlugin.registerPlatforms(register);
  }

  final PlatformCallback _notInstallCallback = (int? platformId) {
    BotToast.showText(text: "not install");
  };

  final Function _successCallback = () {
    BotToast.showText(text: "share successfully");
  };

  final Function _errorCallback = (String code, {String? message}) {
    BotToast.showText(text: "share failed：$code");
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
      title: "This is title",
      text: "This is description",
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
          body: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                MaterialButton(
                  child: const Text("share images to wechat friends"),
                  onPressed: () async {
                    SharePlugin.share(
                        await _buildImageBean(SharePlatforms.wechatSession),
                        _notInstallCallback,
                        _successCallback,
                        _errorCallback);
                  },
                ),
                MaterialButton(
                  child: const Text("share images to wechat timeline"),
                  onPressed: () async {
                    SharePlugin.share(
                        await _buildImageBean(SharePlatforms.wechatTimeline),
                        _notInstallCallback,
                        _successCallback,
                        _errorCallback);
                  },
                ),
                MaterialButton(
                  child: const Text("share images to facebook"),
                  onPressed: () async {
                    SharePlugin.share(
                        await _buildImageBean(SharePlatforms.facebook),
                        _notInstallCallback,
                        _successCallback,
                        _errorCallback);
                  },
                ),
                MaterialButton(
                  child: const Text("share images to whatsapp"),
                  onPressed: () async {
                    SharePlugin.share(
                        await _buildImageBean(SharePlatforms.whatsApp),
                        _notInstallCallback,
                        _successCallback,
                        _errorCallback);
                  },
                ),
                MaterialButton(
                  child: const Text("share images to twitter"),
                  onPressed: () async {
                    SharePlugin.share(
                        await _buildImageBean(SharePlatforms.twitter),
                        _notInstallCallback,
                        _successCallback,
                        _errorCallback);
                  },
                ),
                MaterialButton(
                  child: const Text("share images to line"),
                  onPressed: () async {
                    SharePlugin.share(
                        await _buildImageBean(SharePlatforms.line),
                        _notInstallCallback,
                        _successCallback,
                        _errorCallback);
                  },
                ),
                MaterialButton(
                  child: const Text("share images to native"),
                  onPressed: () async {
                    SharePlugin.share(
                        await _buildImageBean(SharePlatforms.native),
                        _notInstallCallback,
                        _successCallback,
                        _errorCallback);
                  },
                ),
                MaterialButton(
                  child: const Text("share webpage to wechat friends"),
                  onPressed: () async {
                    SharePlugin.share(
                        await _buildWebpageBean(SharePlatforms.wechatSession),
                        _notInstallCallback,
                        _successCallback,
                        _errorCallback);
                  },
                ),
                MaterialButton(
                  child: const Text("share webpage to wechat timeline"),
                  onPressed: () async {
                    SharePlugin.share(
                        await _buildWebpageBean(SharePlatforms.wechatTimeline),
                        _notInstallCallback,
                        _successCallback,
                        _errorCallback);
                  },
                ),
                MaterialButton(
                  child: const Text("share webpage to facebook"),
                  onPressed: () async {
                    SharePlugin.share(
                        await _buildWebpageBean(SharePlatforms.facebook),
                        _notInstallCallback,
                        _successCallback,
                        _errorCallback);
                  },
                ),
                MaterialButton(
                  child: const Text("share webpage to whatsApp"),
                  onPressed: () async {
                    SharePlugin.share(
                        await _buildWebpageBean(SharePlatforms.whatsApp),
                        _notInstallCallback,
                        _successCallback,
                        _errorCallback);
                  },
                ),
                MaterialButton(
                  child: const Text("share webpage to twitter"),
                  onPressed: () async {
                    SharePlugin.share(
                        await _buildWebpageBean(SharePlatforms.twitter),
                        _notInstallCallback,
                        _successCallback,
                        _errorCallback);
                  },
                ),
                MaterialButton(
                  child: const Text("share webpage to line"),
                  onPressed: () async {
                    SharePlugin.share(
                        await _buildWebpageBean(SharePlatforms.line),
                        _notInstallCallback,
                        _successCallback,
                        _errorCallback);
                  },
                ),
                MaterialButton(
                  child: const Text("share webpage to native"),
                  onPressed: () async {
                    SharePlugin.share(
                        await _buildWebpageBean(SharePlatforms.native),
                        _notInstallCallback,
                        _successCallback,
                        _errorCallback);
                  },
                ),
              ],
            ),
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
