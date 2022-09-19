#import <Foundation/Foundation.h>
#import <PlatformShare.h>

@interface PlatformShareFactory : NSObject

+(void)registerPlatform:(NSDictionary<NSNumber*, NSDictionary*>*)platformInfos;

+(NSObject<PlatformShare>*)getPlatformShare:(int)platform;

@end
