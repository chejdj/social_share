package com.chejdj.social_share.util;

import android.content.Context;
import android.content.Intent;
import android.net.Uri;
import android.os.Build;
import android.text.TextUtils;

import androidx.annotation.NonNull;

import com.chejdj.social_share.provider.ShareFileProvider;

import java.io.File;

public class ShareUtil {

    private static final String FILE_PROVIDER_AUTHORITY = "com.pplingo.share";

    public static Uri generateFilePath(Context context, File file, String pkgName) {
        Uri uri;
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
            try {
                uri = ShareFileProvider.getUriForFile(context, FILE_PROVIDER_AUTHORITY, file);
                if (!TextUtils.isEmpty(pkgName)) {
                    context.grantUriPermission(pkgName, uri, Intent.FLAG_GRANT_READ_URI_PERMISSION);
                }
            } catch (IllegalArgumentException e) {
                uri = Uri.fromFile(file);
            }
        } else {
            uri = Uri.fromFile(file);
        }
        return uri;
    }

    public static Intent createShareIntent(@NonNull String intentType, String pkgName, String title, String text, Uri fileUri) {
        Intent shareIntent = new Intent();
        shareIntent.setAction(Intent.ACTION_SEND);
        shareIntent.setType(intentType);
        if (!TextUtils.isEmpty(pkgName)) {
            shareIntent.setPackage(pkgName);
        }
        if (!TextUtils.isEmpty(title)) {
            shareIntent.putExtra(Intent.EXTRA_SUBJECT, title);
        }
        if (!TextUtils.isEmpty(text)) {
            shareIntent.putExtra(Intent.EXTRA_TEXT, text);
        }
        if (fileUri != null) {
            shareIntent.putExtra(Intent.EXTRA_STREAM, fileUri);
        }
        return shareIntent;
    }
}
