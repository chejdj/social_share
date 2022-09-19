#import "WhatsAppShare.h"
#import <SocialSharePlugin.h>
#import "util/ShareUtil.h"
#import "util/PlatformUtil.h"
#import "constants/PlatformConst.h"

@implementation WhatsAppShare

- (instancetype)init {
    if (self = [super init]) {
        _excludeArray = @[UIActivityTypePostToFacebook,
                          UIActivityTypePostToTwitter,
                          UIActivityTypePostToVimeo,
                          UIActivityTypePostToTencentWeibo,
                          UIActivityTypePrint,
                          UIActivityTypeCopyToPasteboard,
                          UIActivityTypeAssignToContact,
                          UIActivityTypeSaveToCameraRoll,
                          UIActivityTypeAddToReadingList,
                          UIActivityTypePostToFlickr,
                          UIActivityTypeMail,
                          UIActivityTypeAirDrop,
                          UIActivityTypeMessage,
                          UIActivityTypeOpenInIBooks,
                          ];
    }
    return self;
}

- (void)shareImage:(NSString *)imgFilePath result:(FlutterResult)result {
    UIImage *image = [ShareUtil generateImageWithPath:imgFilePath];
    if (image == nil) {
        [SocialSharePlugin resultFail:result errorMessage:@"image invalid"];
        return;
    }
    [ShareUtil systemShare:nil withText:nil withImage:image withUrl:nil result:result excludeArray:_excludeArray];
}

- (void)shareText:(NSString *)text result:(FlutterResult)result {
    [ShareUtil systemShareText:text appScheme:[PlatformUtil getUrlWithPlatform:WHATS_APP] result:result];
}

- (void)shareWebpage:(NSString *)webUrl title:(NSString *)title desc:(NSString *)desc imgFilePath:(NSString *)imgFilePath result:(FlutterResult)result {
    if (webUrl == nil || webUrl.length == 0) {
        [SocialSharePlugin resultFail:result errorMessage:@"webUrl invalid"];
        return;
    }
    [self shareText:webUrl result:result];
}

@end
