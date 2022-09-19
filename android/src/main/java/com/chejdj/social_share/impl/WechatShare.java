package com.chejdj.social_share.impl;

import android.app.Activity;
import android.content.BroadcastReceiver;
import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;

import androidx.annotation.NonNull;

import com.chejdj.social_share.PlatformShare;
import com.chejdj.social_share.SocialSharePlugin;
import com.chejdj.social_share.util.ShareUtil;
import com.tencent.mm.opensdk.constants.ConstantsAPI;
import com.tencent.mm.opensdk.modelmsg.SendMessageToWX;
import com.tencent.mm.opensdk.modelmsg.WXFileObject;
import com.tencent.mm.opensdk.modelmsg.WXMediaMessage;
import com.tencent.mm.opensdk.modelmsg.WXMusicObject;
import com.tencent.mm.opensdk.modelmsg.WXTextObject;
import com.tencent.mm.opensdk.modelmsg.WXVideoObject;
import com.tencent.mm.opensdk.modelmsg.WXWebpageObject;
import com.tencent.mm.opensdk.openapi.IWXAPI;
import com.tencent.mm.opensdk.openapi.WXAPIFactory;

import java.io.File;

import io.flutter.plugin.common.MethodChannel.Result;

public class WechatShare implements PlatformShare {

    private static final int THUMB_SIZE = 120;
    private static final String PKG_NAME = "com.tencent.mm";

    private final IWXAPI api;
    private int targetScene;
    private String targetSceneClassStr;

    public WechatShare(Context context, final String appId) {
        api = WXAPIFactory.createWXAPI(context, appId);
        api.registerApp(appId);
        context.registerReceiver(new BroadcastReceiver() {
            @Override
            public void onReceive(Context context, Intent intent) {
                api.registerApp(appId);
            }
        }, new IntentFilter(ConstantsAPI.ACTION_REFRESH_WXAPP));
    }

    public void setTargetScene(int targetScene, String targetSceneClassStr) {
        this.targetScene = targetScene;
        this.targetSceneClassStr = targetSceneClassStr;
    }

    @Override
    public void shareText(String text, Result result, Activity activity) {
        WXTextObject textObj = new WXTextObject(text);
        WXMediaMessage msg = new WXMediaMessage(textObj);
        msg.description = text;

        SendMessageToWX.Req req = new SendMessageToWX.Req();
        req.transaction = buildTransaction("text");
        req.message = msg;
        req.scene = targetScene;
        //调用api接口，发送数据到微信
        api.sendReq(req);
        SocialSharePlugin.resultSuccess(result);
    }

    private static String buildTransaction(String type) {
        return System.currentTimeMillis() + type;
    }

    @Override
    public void shareImage(Activity activity, @NonNull File imageFile, Result result) {
        if (!imageFile.isFile()) {
            SocialSharePlugin.resultFail(result, "image invalid");
            return;
        }
        try {
            Intent intent = new Intent();
            ComponentName cop = new ComponentName("com.tencent.mm", targetSceneClassStr);
            intent.setComponent(cop);
            intent.setAction(Intent.ACTION_SEND);
            intent.setType("image/*");
            intent.putExtra(Intent.EXTRA_STREAM, ShareUtil.generateFilePath(activity, imageFile, PKG_NAME));
            intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
            activity.startActivity(Intent.createChooser(intent, "Share"));
            SocialSharePlugin.resultSuccess(result);
        } catch (Exception e) {
            SocialSharePlugin.resultFail(result, "intent exception");
        }
    }

    @Override
    public void shareMusic(@NonNull String musicUrl, String title, String desc, File imgFile, Result result, Activity activity) {
        WXMusicObject music = new WXMusicObject();
        music.musicUrl = musicUrl;
        WXMediaMessage msg = new WXMediaMessage(music);
        if (title != null) {
            msg.title = title;
        }
        if (desc != null) {
            msg.description = desc;
        }
        Bitmap thumbBmp = generateThumbBmp(imgFile);
        if (thumbBmp != null) {
            msg.setThumbImage(thumbBmp);
        }
        SendMessageToWX.Req req = new SendMessageToWX.Req();
        req.transaction = buildTransaction("music");
        req.message = msg;
        req.scene = targetScene;
        api.sendReq(req);
        SocialSharePlugin.resultSuccess(result);
    }

    private Bitmap generateThumbBmp(File imgFile) {
        if (imgFile == null || !imgFile.isFile()) return null;
        Bitmap bmp = BitmapFactory.decodeFile(imgFile.getAbsolutePath());
        if (bmp == null) return null;
        return Bitmap.createScaledBitmap(bmp, THUMB_SIZE, THUMB_SIZE, true);
    }

    @Override
    public void shareVideo(@NonNull String videoUrl, String title, String desc, File imgFile, Result result, Activity activity) {
        WXVideoObject video = new WXVideoObject();
        video.videoUrl = videoUrl;
        WXMediaMessage msg = new WXMediaMessage(video);
        if (title != null) {
            msg.title = title;
        }
        if (desc != null) {
            msg.description = desc;
        }
        if (imgFile != null && imgFile.isFile()) {
            msg.setThumbImage(generateThumbBmp(imgFile));
        }
        SendMessageToWX.Req req = new SendMessageToWX.Req();
        req.transaction = buildTransaction("video");
        req.message = msg;
        req.scene = targetScene;
        api.sendReq(req);
        SocialSharePlugin.resultSuccess(result);
    }

    @Override
    public void shareWebpage(@NonNull String webUrl, String title, String desc, File imgFile, Result result, Activity activity) {
        if (webUrl.isEmpty()) {
            SocialSharePlugin.resultFail(result, "webUrl invalid");
            return;
        }
        WXWebpageObject webpage = new WXWebpageObject(webUrl);
        WXMediaMessage msg = new WXMediaMessage(webpage);
        if (title != null) {
            msg.title = title;
        }
        if (desc != null) {
            msg.description = desc;
        }
        if (imgFile != null && imgFile.isFile()) {
            msg.setThumbImage(generateThumbBmp(imgFile));
        }
        SendMessageToWX.Req req = new SendMessageToWX.Req();
        req.transaction = buildTransaction("webpage");
        req.message = msg;
        req.scene = targetScene;
        api.sendReq(req);
        SocialSharePlugin.resultSuccess(result);
    }

    @Override
    public void shareFile(@NonNull File file, String title, String desc, Activity activity, Result result) {
        if (!file.isFile()) {
            SocialSharePlugin.resultFail(result, "file invalid");
            return;
        }
        WXFileObject fileObj = new WXFileObject();
        fileObj.filePath = ShareUtil.generateFilePath(activity, file, PKG_NAME).toString();
        WXMediaMessage msg = new WXMediaMessage(fileObj);
        if (title != null) {
            msg.title = title;
        }
        if (desc != null) {
            msg.description = desc;
        }
        SendMessageToWX.Req req = new SendMessageToWX.Req();
        req.transaction = buildTransaction("file");
        req.message = msg;
        req.scene = targetScene;
        api.sendReq(req);
        SocialSharePlugin.resultSuccess(result);
    }
}
