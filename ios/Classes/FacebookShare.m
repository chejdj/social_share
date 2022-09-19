#import "FacebookShare.h"
#import "util/ShareUtil.h"
#import <SocialSharePlugin.h>
#import "util/PlatformUtil.h"
#import "constants/PlatformConst.h"

static NSString *serviceType = @"com.apple.share.Facebook.post";

@implementation FacebookShare

- (instancetype)init {
    if (self = [super init]) {
        _excludeArray = @[UIActivityTypePostToTwitter,
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


-(void)shareText:(NSString*)text result:(FlutterResult)result {
    [ShareUtil systemShare:nil withText:text withImage:nil withUrl:nil result:result excludeArray:_excludeArray];
}

-(void)shareImage:(NSString*)imgFilePath result:(FlutterResult)result {
    UIImage *image = [ShareUtil generateImageWithPath:imgFilePath];
    if (image == nil) {
        [SocialSharePlugin resultFail:result errorMessage:@"image invalid"];
        return;
    }
    [ShareUtil customSysShare:nil withText:nil withImage:image withUrl:nil result:result serviceType:serviceType];
}

-(void)shareWebpage:(NSString*)webUrl title:(NSString*)title desc:(NSString*)desc
        imgFilePath:(NSString*)imgFilePath result:(FlutterResult)result {
    if (webUrl == nil || webUrl.length == 0) {
        [SocialSharePlugin resultFail:result errorMessage:@"webUrl invalid"];
        return;
    }
    if ([webUrl containsString:@"?"]) {
        // facebook iOS 不支持带参数的链接，直接分享文本
        [ShareUtil systemShare:nil withText:webUrl withImage:nil withUrl:nil result:result excludeArray:_excludeArray];
        return;
    }
    NSURL* url = [NSURL URLWithString:webUrl];
    [ShareUtil customSysShare:title withText:desc withImage:nil withUrl:url result:result serviceType:serviceType];
}

@end
