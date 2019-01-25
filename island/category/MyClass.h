#import <Foundation/Foundation.h>

@interface MyClass : NSObject

- (void)printName;

@end

@interface MyClass(MyAddition)

@property(nonatomic, copy) NSString *name;

- (void)printName;

@end
