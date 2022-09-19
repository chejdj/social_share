package com.chejdj.social_share.impl;

import android.app.Activity;
import android.content.ActivityNotFoundException;
import android.content.Intent;
import android.net.Uri;

import androidx.annotation.NonNull;

import com.chejdj.social_share.PlatformShare;
import com.chejdj.social_share.SocialSharePlugin;

import java.io.File;

import io.flutter.plugin.common.MethodChannel;

public class LineShare implements PlatformShare {

    private static final String LINE_SCHEME_PREFIX = "https://line.me/R/share?text=";

    private final SystemShare systemShare;

    public LineShare() {
        systemShare = new SystemShare("jp.naver.line.android");
    }

    @Override
    public void shareText(String text, MethodChannel.Result result, Activity activity) {
        try {
            activity.startActivity(new Intent(Intent.ACTION_VIEW, Uri.parse(LINE_SCHEME_PREFIX + text)));
        } catch (ActivityNotFoundException e) {
            SocialSharePlugin.resultFail(result, "activity not found");
        }
        SocialSharePlugin.resultSuccess(result);
    }

    @Override
    public void shareImage(Activity activity, @NonNull File imageFile, MethodChannel.Result result) {
        systemShare.shareImage(activity, imageFile, result);
    }

    @Override
    public void shareMusic(@NonNull String musicUrl, String title, String desc, File imgFile, MethodChannel.Result result, Activity activity) {
        // not support
        SocialSharePlugin.resultFail(result, "not support");
    }

    @Override
    public void shareVideo(@NonNull String videoUrl, String title, String desc, File imgFile, MethodChannel.Result result, Activity activity) {
        // not support
        SocialSharePlugin.resultFail(result, "not support");
    }

    @Override
    public void shareWebpage(@NonNull String webUrl, String title, String desc, File imgFile, MethodChannel.Result result, Activity activity) {
        // line only support the text type
        shareText(webUrl, result, activity);
    }

    @Override
    public void shareFile(@NonNull File file, String title, String desc, Activity activity, MethodChannel.Result result) {
        systemShare.shareFile(file, title, desc, activity, result);
    }
}
