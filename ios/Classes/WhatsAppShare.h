#import "PlatformShare.h"

@interface WhatsAppShare:NSObject<PlatformShare>

@property (nonatomic,strong)NSArray<UIActivityType>* excludeArray;

@end
