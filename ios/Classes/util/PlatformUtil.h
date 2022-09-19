#import <Foundation/Foundation.h>
#import <Flutter/Flutter.h>

@interface PlatformUtil: NSObject

+(void)isClientInstalled:(int)platform result:(FlutterResult)result;

+(NSString*)getUrlWithPlatform:(int)platform;

@end
