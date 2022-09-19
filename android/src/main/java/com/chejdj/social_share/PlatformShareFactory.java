package com.chejdj.social_share;

import android.content.Context;

import androidx.annotation.Nullable;

import com.chejdj.social_share.constants.PlatformConst;
import com.chejdj.social_share.impl.FacebookShare;
import com.chejdj.social_share.impl.LineShare;
import com.chejdj.social_share.impl.SystemShare;
import com.chejdj.social_share.impl.TwitterShare;
import com.chejdj.social_share.impl.WechatShare;
import com.chejdj.social_share.impl.WhatsAppShare;
import com.tencent.mm.opensdk.modelmsg.SendMessageToWX;

import java.util.Map;

public class PlatformShareFactory {

    private static WechatShare wechatShare;
    private static FacebookShare facebookShare;
    private static WhatsAppShare whatsAppShare;
    private static TwitterShare twitterShare;
    private static LineShare lineShare;

    public static void registerPlatform(Context context, Map<Integer, Map<String, String>> platformInfos) {
        for (Map.Entry<Integer, Map<String, String>> platformInfo : platformInfos.entrySet()) {
            switch (platformInfo.getKey()) {
                case PlatformConst.WECHAT_SESSION:
                case PlatformConst.WECHAT_TIMELINE: {
                    wechatShare = new WechatShare(context, platformInfo.getValue().get("appId"));
                    break;
                }
                default:
                    break;
            }
            facebookShare = new FacebookShare();
            whatsAppShare = new WhatsAppShare();
            twitterShare = new TwitterShare();
            lineShare = new LineShare();
        }
    }

    public static PlatformShare getPlatformShare(int platform, @Nullable String pkgName) {
        switch (platform) {
            case PlatformConst.WECHAT_SESSION: {
                wechatShare.setTargetScene(SendMessageToWX.Req.WXSceneSession, "com.tencent.mm.ui.tools.ShareImgUI");
                return wechatShare;
            }
            case PlatformConst.WECHAT_TIMELINE: {
                wechatShare.setTargetScene(SendMessageToWX.Req.WXSceneTimeline, "com.tencent.mm.ui.tools.ShareToTimeLineUI");
                return wechatShare;
            }
            case PlatformConst.FACEBOOK:
                return facebookShare;
            case PlatformConst.WHATS_APP: {
                return whatsAppShare;
            }
            case PlatformConst.TWITTER:
                return twitterShare;
            case PlatformConst.LINE:
                return lineShare;
            default:
                return new SystemShare(pkgName);
        }
    }
}
