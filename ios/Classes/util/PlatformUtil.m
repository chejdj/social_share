#import "PlatformUtil.h"
#import "../constants/PlatformConst.h"

@implementation PlatformUtil:NSObject

+(void)isClientInstalled:(int)platform result:(FlutterResult)result {
    NSURL* url = [NSURL URLWithString:[self getUrlWithPlatform:platform]];
    if ([[UIApplication sharedApplication]canOpenURL:url]) {
        result([NSNumber numberWithBool:true]);
    } else {
        result([NSNumber numberWithBool:false]);
    }
}

+(NSString*)getUrlWithPlatform:(int)platform {
    switch (platform) {
        case WECHAT_SESSION:
        case WECHAT_TIMELINE: {
            return @"weixin://";
        }
        case FACEBOOK:
            return @"fb://";
        case TWITTER:
            return @"twitter://";
        case WHATS_APP:
            return @"whatsapp://";
        case LINE:
            return @"line://";
        default:
            return nil;
    }
}

@end
