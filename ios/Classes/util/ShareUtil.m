#import "ShareUtil.h"
#import <SocialSharePlugin.h>
#import "../constants/ShareErrorCode.h"

@implementation ShareUtil

+(void)systemShare:(NSString*)title withText:(NSString*)text withImage:(UIImage*)image withUrl:(NSURL*)url
            result:(FlutterResult)result  excludeArray:(NSArray<UIActivityType>*)excludeArray {
    NSMutableArray *activityItems = [NSMutableArray array];
    if(title){
        [activityItems addObject:title];
    }

    if(text){
        [activityItems addObject:text];
    }
    
    if(url){
        [activityItems addObject:url];
    }
    
    if(image){
        [activityItems addObject:image];
    }
    
    UIActivityViewController *activityVC = [[UIActivityViewController alloc]initWithActivityItems:activityItems applicationActivities:nil];
    //不出现在活动项目
    activityVC.excludedActivityTypes = excludeArray;
    if ([[UIDevice currentDevice] userInterfaceIdiom] ==
        UIUserInterfaceIdiomPad){
        UIPopoverPresentationController *popover = activityVC.popoverPresentationController;
        CGFloat maxLen = MAX([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        CGFloat minLen = MIN([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(minLen - 200, maxLen - 200, 100, 100)];
        popover.sourceView = view;
        if (popover) {
            popover.permittedArrowDirections = UIPopoverArrowDirectionDown;
            [[UIApplication sharedApplication].keyWindow.rootViewController.view addSubview:view];
        }
    }
    // 分享之后的回调
    activityVC.completionWithItemsHandler = ^(UIActivityType  _Nullable activityType, BOOL completed, NSArray * _Nullable returnedItems, NSError * _Nullable activityError) {
        if (completed) {
            [SocialSharePlugin resultSuccess:result];
        } else  {
            [SocialSharePlugin resultFail:result errorCode:ERROR_AFTER_JUMP errorMessage:nil];
        }
    };
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:activityVC animated:YES completion:nil];
}

+(void)systemShareText:(NSString*)text appScheme:(NSString*)appScheme result:(FlutterResult)result {
    NSString * urlStr = [NSString stringWithFormat:@"%@send?text=%@",appScheme,text];
    NSURL * url = [NSURL URLWithString:[urlStr stringByAddingPercentEncodingWithAllowedCharacters:NSCharacterSet.URLQueryAllowedCharacterSet]];
    [[UIApplication sharedApplication] openURL: url];
    [SocialSharePlugin resultSuccess:result];
}

+(void)customSysShare:(NSString*)title withText:(NSString*)text withImage:(UIImage*)image withUrl:(NSURL*)url
               result:(FlutterResult)result serviceType:(NSString*)serviceType {
    SLComposeViewController *composeVC = [SLComposeViewController composeViewControllerForServiceType: serviceType];
    if(title){
        [composeVC setTitle:title];
    }

    if(text){
        [composeVC setInitialText:text];
    }
    
    if(url){
        [composeVC addURL:url];
    }
    
    if(image){
        [composeVC addImage:image];
    }
    composeVC.completionHandler = ^(SLComposeViewControllerResult composeResult) {
        if (composeResult == SLComposeViewControllerResultDone) {
            [SocialSharePlugin resultSuccess:result];
        } else if (composeResult == SLComposeViewControllerResultCancelled) {
            [SocialSharePlugin resultFail:result errorCode:CANCELED errorMessage:nil];
        } else  {
            [SocialSharePlugin resultFail:result errorCode:ERROR_AFTER_JUMP errorMessage:nil];
        }
    };
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:composeVC animated:YES completion:nil];
}

+(UIImage*)generateImageWithPath:(NSString*)imgFilePath {
    if (imgFilePath == nil) {
        return nil;
    }
    NSData* imgData = [NSData dataWithContentsOfFile:imgFilePath];
    if (imgData == nil) {
        return nil;
    }
    return [UIImage imageWithData:imgData];
}

+(UIImage*)generateImageWithPath:(NSString*)imgFilePath limitBytes:(long)limitBytes {
    if (imgFilePath == nil) {
        return nil;
    }
    NSData* imgData = [NSData dataWithContentsOfFile:imgFilePath];
    if (imgData == nil || imgData.length > limitBytes) {
        return nil;
    }
    return [UIImage imageWithData:imgData];
}

@end
