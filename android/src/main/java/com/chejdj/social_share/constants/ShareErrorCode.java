package com.chejdj.social_share.constants;

public class ShareErrorCode {

    /**
     * 跳转到第三方 app 之前发生错误
     */
    public static final String ERROR_BEFORE_JUMP = "101";
    /**
     * 跳转后发生错误，用于支持回调的第三方 app
     */
    public static final String ERROR_AFTER_JUMP = "102";
    /**
     * 取消分享，用于支持回调的第三方 app
     */
    public static final String CANCELED = "103";
}
