#import <Foundation/Foundation.h>

@interface MyClass : NSObject

- (void)printName;

@property(nonatomic, copy) NSString *lihux;

@end

@interface MyClass(MyAddition)

@property(nonatomic, copy) NSString *name;

- (void)printName;

@end
