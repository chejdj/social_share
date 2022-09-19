package com.chejdj.social_share;

import android.app.Activity;

import androidx.annotation.NonNull;

import java.io.File;

import io.flutter.plugin.common.MethodChannel.Result;

public interface PlatformShare {

    void shareText(String text, Result result, Activity activity);

    void shareImage(Activity activity, @NonNull File imageFile, Result result);

    void shareMusic(@NonNull String musicUrl, String title, String desc, File imgFile, Result result, Activity activity);

    void shareVideo(@NonNull String videoUrl, String title, String desc, File imgFile, Result result, Activity activity);

    void shareWebpage(@NonNull String webUrl, String title, String desc, File imgFile, Result result, Activity activity);

    void shareFile(@NonNull File file, String title, String desc, Activity activity, Result result);
}
