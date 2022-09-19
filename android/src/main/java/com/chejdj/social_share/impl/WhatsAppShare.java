package com.chejdj.social_share.impl;

import android.app.Activity;

import androidx.annotation.NonNull;

import com.chejdj.social_share.PlatformShare;
import com.chejdj.social_share.SocialSharePlugin;

import java.io.File;

import io.flutter.plugin.common.MethodChannel.Result;

public class WhatsAppShare implements PlatformShare {

    private final SystemShare systemShare;

    public WhatsAppShare() {
        systemShare = new SystemShare("com.whatsapp");
    }

    @Override
    public void shareText(String text, Result result, Activity activity) {
        systemShare.shareText(text, result, activity);
    }

    @Override
    public void shareImage(Activity activity, @NonNull File imageFile, Result result) {
        systemShare.shareImage(activity, imageFile, result);
    }

    @Override
    public void shareMusic(@NonNull String musicUrl, String title, String desc, File imgFile, Result result, Activity activity) {
        // not support
        SocialSharePlugin.resultFail(result, "not support");
    }

    @Override
    public void shareVideo(@NonNull String videoUrl, String title, String desc, File imgFile, Result result, Activity activity) {
        // not support
        SocialSharePlugin.resultFail(result, "not support");
    }

    @Override
    public void shareWebpage(@NonNull String webUrl, String title, String desc, File imgFile, Result result, Activity activity) {
        // WhatsApp only support text type
        shareText(webUrl, result, activity);
    }

    @Override
    public void shareFile(@NonNull File file, String title, String desc, Activity activity, Result result) {
        systemShare.shareFile(file, title, desc, activity, result);
    }
}
