#import "SystemShare.h"
#import <SocialSharePlugin.h>
#import "util/ShareUtil.h"

@implementation SystemShare

- (void)shareImage:(NSString *)imgFilePath result:(FlutterResult)result {
    UIImage *image = [ShareUtil generateImageWithPath:imgFilePath];
    if (image == nil) {
        [SocialSharePlugin resultFail:result errorMessage:@"image invalid"];
        return;
    }
    [ShareUtil systemShare:nil withText:nil withImage:image withUrl:nil result:result excludeArray:nil];
}

- (void)shareText:(NSString *)text result:(FlutterResult)result {
    [ShareUtil systemShare:nil withText:text withImage:nil withUrl:nil result:result excludeArray:nil];
}

- (void)shareWebpage:(NSString *)webUrl title:(NSString *)title desc:(NSString *)desc imgFilePath:(NSString *)imgFilePath result:(FlutterResult)result {
    if (webUrl == nil || webUrl.length == 0) {
        [SocialSharePlugin resultFail:result errorMessage:@"webUrl invalid"];
        return;
    }
    UIImage *image = [ShareUtil generateImageWithPath:imgFilePath];
    NSURL* url = [NSURL URLWithString:webUrl];
    [ShareUtil systemShare:title withText:desc withImage:image withUrl:url result:result excludeArray:nil];
}

@end
