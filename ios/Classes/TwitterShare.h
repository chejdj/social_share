#import "PlatformShare.h"
#import "Social/Social.h"

@interface TwitterShare:NSObject<PlatformShare>

@property (nonatomic, strong)NSString* serviceType;

@property (nonatomic,strong)NSArray<UIActivityType>* excludeArray;

@end
