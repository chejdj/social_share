package com.chejdj.social_share.util;

import java.io.File;

public class Utils {
    public static  File getFileWithPath(String filePath) {
        if (filePath == null || filePath.isEmpty()) return null;
        File file = new File(filePath);
        return file.isFile() ? file : null;
    }

    public static  boolean isStringNullOrEmpty(String str) {
        return str == null || str.isEmpty();
    }
}
