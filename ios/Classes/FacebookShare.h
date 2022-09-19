#import "PlatformShare.h"

@interface FacebookShare:NSObject<PlatformShare>

@property (nonatomic,strong)NSArray<UIActivityType>* excludeArray;

@end
