#import "WechatShare.h"
#import "PlatformShareFactory.h"
#import "constants/PlatformConst.h"
#import "FacebookShare.h"
#import "TwitterShare.h"
#import "WhatsAppShare.h"
#import "LineShare.h"
#import "SystemShare.h"
#import "WXApi.h"

static WechatShare* wechatShare = nil;

@implementation PlatformShareFactory

+(void)registerPlatform:(NSDictionary<NSNumber*, NSDictionary*>*)platformInfos {
    [platformInfos enumerateKeysAndObjectsUsingBlock:^(NSNumber * _Nonnull key, NSDictionary * _Nonnull platformInfo, BOOL * _Nonnull stop) {
        int platform = [key intValue];
        switch (platform) {
            case WECHAT_SESSION:
            case WECHAT_TIMELINE: {
                wechatShare = [[WechatShare alloc] initWithAppId:platformInfo[@"appId"] universalLink:platformInfo[@"appUniversalLink"]];
                break;
            }
            default:
                break;
        }
    }];
}

+(NSObject<PlatformShare>*)getPlatformShare:(int)platform {
    switch (platform) {
        case WECHAT_SESSION: {
            wechatShare.scene = WXSceneSession;
            return wechatShare;
        }
        case WECHAT_TIMELINE: {
            wechatShare.scene = WXSceneTimeline;
            return wechatShare;
        }
        case FACEBOOK: {
            return [[FacebookShare alloc] init];
        }
        case TWITTER: {
            return [[TwitterShare alloc] init];
        }
        case WHATS_APP: {
            return [[WhatsAppShare alloc] init];
        }
        case LINE: {
            return [[LineShare alloc] init];
        }
        case NATIVE: {
            return [SystemShare alloc];
        }
        default:
            return nil;
    }
}

@end
