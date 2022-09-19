#import "SocialSharePlugin.h"
#import "constants/ShareErrorCode.h"
#import "PlatformShareFactory.h"
#import "util/PlatformUtil.h"
#import "PlatformShare.h"
#import "constants/ShareTypeConst.h"
#import "WXApi.h"

@implementation SocialSharePlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    FlutterMethodChannel* channel = [FlutterMethodChannel
        methodChannelWithName:@"social_share_plugin"
              binaryMessenger:[registrar messenger]];
    SocialSharePlugin* instance = [[SocialSharePlugin alloc] init];
    [registrar addMethodCallDelegate:instance channel:channel];
    [registrar addApplicationDelegate:instance];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([@"registerPlatforms" isEqualToString:call.method]) {
      [PlatformShareFactory registerPlatform:call.arguments];
  } else if ([@"isClientInstalled" isEqualToString:call.method]) {
      NSNumber* platform = call.arguments[@"platform"];
      [PlatformUtil isClientInstalled:platform.intValue result:result];
  } else if ([@"share" isEqualToString:call.method]) {
      [self shareToPlatform:call.arguments result:result];
  } else {
    result(FlutterMethodNotImplemented);
  }

}

/**
 return nil if the key not found
 */
-(id)getDataFromDic:(NSDictionary*)dic key:(NSString*)key {
    if ([dic[key] isKindOfClass:[NSNull class]]) {
        return nil;
    }
    return dic[key];
}

-(void)shareToPlatform:(NSDictionary*)arguments result:(FlutterResult)result {
    NSNumber* contentType = [self getDataFromDic:arguments key:@"contentType"];
    NSNumber* platformId = [self getDataFromDic:arguments key:@"platform"];
    if (contentType == nil || platformId == nil) {
        [SocialSharePlugin resultFail:result errorMessage:nil];
        return;
    }
    NSString* title = [self getDataFromDic:arguments key:@"title"];
    NSString* text = [self getDataFromDic:arguments key:@"text"];
    NSString* imageFilePath = [self getDataFromDic:arguments key:@"imageFilePath"];
    NSString* webUrl = [self getDataFromDic:arguments key:@"webUrl"];
    NSObject<PlatformShare>* platformShare = [PlatformShareFactory getPlatformShare:platformId.intValue];
    if (platformShare == nil) {
        [SocialSharePlugin resultFail:result errorMessage:nil];
        return;
    }
    switch (contentType.intValue) {
        case TEXT: {
            if (text == nil) {
                [SocialSharePlugin resultFail:result errorMessage:@"text needed"];
                return;
            }
            [platformShare shareText:text result:result];
            break;
        }
        case IMAGE: {
            if (imageFilePath == nil) {
                [SocialSharePlugin resultFail:result errorMessage:@"image url needed"];
                return;
            }
            [platformShare shareImage:imageFilePath result:result];
            break;
        }
        case WEB_PAGE: {
            if (webUrl == nil) {
                [SocialSharePlugin resultFail:result errorMessage:@"webUrl needed"];
                return;
            }
            [platformShare shareWebpage:webUrl title:title desc:text imgFilePath:imageFilePath result:result];
            break;
        }
        default: {
            [SocialSharePlugin resultFail:result errorMessage:@"not support"];
            break;
        }
    }
}

+(NSDictionary*)generateResultDic:(BOOL)isSuccess errorCode:(NSString*)errorCode errorMessage:(NSString*)errorMessage {
    if (errorCode == nil) {
        return @{
            @"isShareSuccess":@(isSuccess),
            };
    } else if (errorMessage == nil) {
        return @{
            @"isShareSuccess":@(isSuccess),
            @"errorCode":errorCode,
            };
    } else {
        return @{
            @"isShareSuccess":@(isSuccess),
            @"errorCode":errorCode,
            @"errorMessage":errorMessage,
            };
    }
}

+(void)resultFail:(FlutterResult)result errorMessage:(NSString*)errorMessage {
    [self resultFail:result errorCode:ERROR_BEFORE_JUMP errorMessage:errorMessage];
}

+(void)resultFail:(FlutterResult)result errorCode:(NSString*)errorCode errorMessage:(NSString*)errorMessage {
    result([self generateResultDic:false errorCode:errorCode errorMessage:errorMessage]);
}

+(void)resultSuccess:(FlutterResult)result {
    result([self generateResultDic:true errorCode:nil errorMessage:nil]);
}

-(BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray * _Nonnull))restorationHandler {
    return [WXApi handleOpenUniversalLink:userActivity
    delegate:self];
}
@end

