package com.chejdj.social_share.impl;
import android.app.Activity;
import android.content.Intent;
import android.net.Uri;
import android.text.TextUtils;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.chejdj.social_share.PlatformShare;
import com.chejdj.social_share.SocialSharePlugin;
import com.chejdj.social_share.util.ShareUtil;

import java.io.File;

import io.flutter.plugin.common.MethodChannel;

public class SystemShare implements PlatformShare {

    private final String pkgName;

    public SystemShare(@Nullable String pkgName) {
        this.pkgName = pkgName;
    }

    @Override
    public void shareText(String text, MethodChannel.Result result, Activity activity) {
        if (TextUtils.isEmpty(text)) {
            SocialSharePlugin.resultFail(result, "text invalid");
            return;
        }
        try {
            Intent shareIntent = ShareUtil.createShareIntent("text/plain", pkgName, null, text, null);
            activity.startActivity(Intent.createChooser(shareIntent, "Share via"));
            SocialSharePlugin.resultSuccess(result);
        } catch (Exception e) {
            SocialSharePlugin.resultFail(result, "intent exception");
        }
    }

    @Override
    public void shareImage(Activity activity, @NonNull File imageFile, MethodChannel.Result result) {
        if (!imageFile.isFile()) {
            SocialSharePlugin.resultFail(result, "image invalid");
            return;
        }
        try {
            Uri fileUri = ShareUtil.generateFilePath(activity, imageFile, pkgName);
            Intent shareIntent = ShareUtil.createShareIntent("image/*", pkgName, null, null, fileUri);
            activity.startActivity(Intent.createChooser(shareIntent, "Share via"));
            SocialSharePlugin.resultSuccess(result);
        } catch (Exception e) {
            SocialSharePlugin.resultFail(result, "intent exception");
        }
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
        Intent shareIntent;
        if (imgFile != null && imgFile.isFile()) {
            Uri fileUri = ShareUtil.generateFilePath(activity, imgFile, pkgName);
            shareIntent = ShareUtil.createShareIntent("image/*", pkgName, title, webUrl, fileUri);
        } else {
            shareIntent = ShareUtil.createShareIntent("text/plain", pkgName, title, webUrl, null);
        }
        try {
            activity.startActivity(Intent.createChooser(shareIntent, "Share via"));
            SocialSharePlugin.resultSuccess(result);
        } catch (Exception e) {
            SocialSharePlugin.resultFail(result, "intent exception");
        }
    }

    @Override
    public void shareFile(@NonNull File file, String title, String desc, Activity activity, MethodChannel.Result result) {
        if (!file.isFile()) {
            SocialSharePlugin.resultFail(result, "file invalid");
            return;
        }
        try {
            Uri fileUri = ShareUtil.generateFilePath(activity, file, null);
            Intent shareIntent = ShareUtil.createShareIntent("application/octet-stream", pkgName, title, desc, fileUri);
            activity.startActivity(Intent.createChooser(shareIntent, "Share via"));
            SocialSharePlugin.resultSuccess(result);
        } catch (Exception e) {
            SocialSharePlugin.resultFail(result, "intent exception");
        }
    }
}
