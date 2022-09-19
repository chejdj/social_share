#import <Foundation/Foundation.h>
#import <PlatformShare.h>

@interface WechatShare : NSObject<PlatformShare>

@property (nonatomic, assign) int scene;

@property (nonatomic, strong)NSString* serviceType;

- (instancetype)initWithAppId:(NSString*)appId universalLink:(NSString*)universalLink;

@end
