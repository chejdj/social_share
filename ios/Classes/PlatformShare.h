#import <Foundation/Foundation.h>
#import <Flutter/Flutter.h>

@protocol PlatformShare <NSObject>

-(void)shareText:(NSString*)text result:(FlutterResult)result;

-(void)shareImage:(NSString*)imgFilePath result:(FlutterResult)result;

-(void)shareWebpage:(NSString*)webUrl title:(NSString*)title desc:(NSString*)desc imgFilePath:(NSString*)imgFilePath result:(FlutterResult)result;

@end
