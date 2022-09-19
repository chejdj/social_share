package com.chejdj.social_share.util;

import android.content.Context;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;

import com.chejdj.social_share.constants.PlatformConst;

import io.flutter.plugin.common.MethodChannel;

public class PlatformUtil {

    public static String getPackageName(Integer platformId) {
        if (platformId == null) return null;
        switch (platformId) {
            case PlatformConst.WECHAT_SESSION:
            case PlatformConst.WECHAT_TIMELINE:
                return "com.tencent.mm";
            case PlatformConst.FACEBOOK:
                return "com.facebook.katana";
            case PlatformConst.WHATS_APP:
                return "com.whatsapp";
            case PlatformConst.TWITTER:
                return "com.twitter.android";
            case PlatformConst.LINE:
                return "jp.naver.line.android";
            default:
                return null;
        }
    }

    public static void isClientInstalled(Context context, Integer platformId, MethodChannel.Result result) {
        result.success(isAppInstalled(context, platformId));
    }

    public static boolean isAppInstalled(Context context, Integer platformId) {
        String pkgName = PlatformUtil.getPackageName(platformId);
        if (pkgName == null) {
            return false;
        }
        PackageInfo packageInfo;
        try {
            packageInfo = context.getPackageManager().getPackageInfo(pkgName, 0);
        } catch (PackageManager.NameNotFoundException e) {
            packageInfo = null;
            e.printStackTrace();
        }
        return packageInfo != null;
    }
}
