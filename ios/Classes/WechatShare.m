#import "WechatShare.h"
#import "constants/ShareErrorCode.h"
#import <SocialSharePlugin.h>
#import "util/ShareUtil.h"
#import "WXApi.h"

@interface WechatShare ()

@property (nonatomic,strong)NSArray<UIActivityType>* excludeArray;

@end

static long THUMB_IMAGE_MAX_BYTES = 64000;

@implementation WechatShare

- (instancetype)initWithAppId:(NSString*)appId universalLink:(NSString*)universalLink {
    if (self = [super init]) {
        [WXApi registerApp:appId universalLink:universalLink];
        _scene = WXSceneSession;
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



- (void)shareText:(NSString *)text result:(FlutterResult)result {
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    req.bText = YES;
    req.text = text;
    req.scene = _scene;
    [WXApi sendReq:req completion:^(BOOL success) {
        if (success) {
            [SocialSharePlugin resultSuccess:result];
        } else {
            [SocialSharePlugin resultFail:result errorCode:ERROR_AFTER_JUMP errorMessage:nil];
        }
    }];
}

-(void)shareImage:(NSString*)imgFilePath result:(FlutterResult)result {
    UIImage *image = [ShareUtil generateImageWithPath:imgFilePath];
    if (image == nil) {
        [SocialSharePlugin resultFail:result errorMessage:@"image invalid"];
        return;
    }
    [ShareUtil systemShare:nil withText:nil withImage:image withUrl:nil result:result excludeArray:_excludeArray];
}

-(void)shareWebpage:(NSString*)webUrl title:(NSString*)title desc:(NSString*)desc
        imgFilePath:(NSString*)imgFilePath result:(FlutterResult)result {
    if (webUrl == nil || webUrl.length == 0) {
        [SocialSharePlugin resultFail:result errorMessage:@"webUrl invalid"];
        return;
    }
    WXWebpageObject *webpageObject = [WXWebpageObject object];
    webpageObject.webpageUrl = webUrl;
    WXMediaMessage *message = [WXMediaMessage message];
    if (title) {
        message.title = title;
    }
    if (desc) {
        message.description = desc;
    }
    UIImage *image = [ShareUtil generateImageWithPath:imgFilePath limitBytes:THUMB_IMAGE_MAX_BYTES];
    if (image) {
        [message setThumbImage:image];
    }
    message.mediaObject = webpageObject;
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = _scene;
    [WXApi sendReq:req completion:^(BOOL success) {
        if (success) {
            [SocialSharePlugin resultSuccess:result];
        } else {
            [SocialSharePlugin resultFail:result errorCode:ERROR_AFTER_JUMP errorMessage:nil];
        }
    }];
}

@end
