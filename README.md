# <font size=7>social_share</font>

A plugin supports variety of sharing contents and sharing platforms.Maybe it is the simplest share tools.    

## <font size=6>Features</font>

| Platforms | Content | OS  |
| ----  | ---- | ----|
| *wechat*    | *Text/Image/Music/Video/WebPage/File* | *Android/iOS*  |
| *Facebook*   | *Text/Image/WebView/File*| *Android/iOS* |
| *Line* | *Text/Image/File* | *Android/iOS*|
| *Twiter*| *Text/Image/File* | *Android/iOS*|
| *WhatsApp*| *Text/Image/File* | *Andorid/iOS*|
| *SystemShare* | *---* | *---* |


## <font size=6>Usage</font>
### <font size=5>iOS</font>
config in Info.plist file
```
<array>
		<string>fb</string>
		<string>fbauth</string>
		<string>weixin</string>
		<string>weixinULAPI</string>
		<string>fbapi20150629</string>
		<string>fbapi20160328</string>
		<string>fbapi20130214</string>
		<string>fbapi</string>
		<string>fb-messenger-share-api</string>
		<string>fbauth2</string>
		<string>fbshareextension</string>
		<string>twitter</string>
		<string>whatsapp</string>
		<string>line</string>
</array>
```  


### <font size=5>reigster</font>
only should config wechat platform. The appId and secretKey is from [WechatOpenPlatform](https://open.weixin.qq.com/). Other platform no need.
```
 LaShareRegister register = LaShareRegister();
    register.setupWechat(appId, secretKey, universalLink); //only need wechat 
    LaSharePlugin.registerPlatforms(register);
```  
## <font size=6>start share</font>
* <font size =5>construct share data</font>
```
LaShareParamsBean generateBean() {
        return LaShareParamsBean(
              contentType: LaShareContentTypes.webpage,
              platform: LaSharePlatforms.whatsApp,
              webUrl: webUrl,
              title: title,
              text: desc,
              imageFilePath: imgFilePath,
            );
    }
```  
* <font size=5>start share</font>
```
 LaSharePlugin.share(
          generateBean(),
          notInstallCallBack,
          successCallBack,
          errorCallBack,
        );
```  
* <font size=5>check App whether install</font>
```
LaSharePlugin.isClientInstalled(LaSharePlatforms.whatsApp);
```
## <font size=6>Preview</font>
![all.png](https://s2.loli.net/2022/07/13/zTl4wc7PvIAoKx3.png)
## <font size=6>Attention</font>
1. iOS wechat image share use the SystemShare because wechat forbidden the image share for foreign company.
2. You should add some scheme config for accessing outer apps. Refer to example configuration.  

