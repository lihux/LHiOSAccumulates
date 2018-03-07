#import <Foundation/Foundation.h>

@interface Talker : NSObject {
	NSString *lihux;
	NSInteger dog;
	NSNumber *people;
}

@property(weak) NSString *weakMan;
@property(strong) NSNumber *strongFish;

- (void) say: (NSString *) phrase;

@end
