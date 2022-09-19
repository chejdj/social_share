#import <Flutter/Flutter.h>
#import <Foundation/Foundation.h>
#import "Social/Social.h"

@interface ShareUtil: NSObject

+(void)systemShare:(NSString*)title withText:(NSString*)text withImage:(UIImage*)image withUrl:(NSURL*)url
            result:(FlutterResult)result excludeArray:(NSArray<UIActivityType>*)excludeArray;

+(void)systemShareText:(NSString*)text appScheme:(NSString*)appScheme result:(FlutterResult)result;

+(UIImage*)generateImageWithPath:(NSString*)imgFilePath;

/**
 return nil if image larger than limitBytes
 */
+(UIImage*)generateImageWithPath:(NSString*)imgFilePath limitBytes:(long)limitBytes;

+(void)customSysShare:(NSString*)title withText:(NSString*)text withImage:(UIImage*)image withUrl:(NSURL*)url
               result:(FlutterResult)result serviceType:(NSString*)serviceType;

@end
