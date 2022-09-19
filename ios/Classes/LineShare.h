#import "PlatformShare.h"

@interface LineShare:NSObject<PlatformShare>

@property (nonatomic, strong)NSString* schemePrefix;

@property (nonatomic,strong)NSArray<UIActivityType>* excludeArray;

@end
