#import "TwitterShare.h"
#import <SocialSharePlugin.h>
#import "util/ShareUtil.h"

@implementation TwitterShare

- (instancetype)init {
    if (self = [super init]) {
        _serviceType = @"com.apple.share.Twitter.post";
        _excludeArray = @[UIActivityTypePostToFacebook,
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
    [ShareUtil customSysShare:nil withText:nil withImage:image withUrl:nil result:result serviceType:_serviceType];
}

- (void)shareText:(NSString *)text result:(FlutterResult)result {
    NSString * urlStr = [NSString stringWithFormat:@"https://twitter.com/intent/tweet?text=%@",text];
    NSURL * url = [NSURL URLWithString:[urlStr stringByAddingPercentEncodingWithAllowedCharacters:NSCharacterSet.URLQueryAllowedCharacterSet]];
    [[UIApplication sharedApplication] openURL: url];
    [SocialSharePlugin resultSuccess:result];
}

- (void)shareWebpage:(NSString *)webUrl title:(NSString *)title desc:(NSString *)desc imgFilePath:(NSString *)imgFilePath result:(FlutterResult)result {
    if (webUrl == nil || webUrl.length == 0) {
        [SocialSharePlugin resultFail:result errorMessage:@"webUrl invalid"];
        return;
    }
    [self shareText:webUrl result:result];
}

@end
