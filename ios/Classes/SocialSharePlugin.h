#import <Flutter/Flutter.h>
#import <UIKit/UIKit.h>

@interface SocialSharePlugin : NSObject<FlutterPlugin>
+(NSDictionary*)generateResultDic:(BOOL)isSuccess errorCode:(NSString*)errorCode errorMessage:(NSString*)errorMessage;

+(void)resultFail:(FlutterResult)result errorMessage:(NSString*)errorMessage;

+(void)resultFail:(FlutterResult)result errorCode:(NSString*)errorCode errorMessage:(NSString*)errorMessage;

+(void)resultSuccess:(FlutterResult)result;

-(void)shareToPlatform:(NSDictionary*)arguments result:(FlutterResult)result;
@end
