//
//  LCDKVCViewController.m
//  LHiOSAccumulatesInObjectiveC
//
//  Created by 李辉 on 2018/8/9.
//  Copyright © 2018年 Lihux. All rights reserved.
//

#import "LCDKVCViewController.h"


@interface LCDKVCPerson: NSObject

@property (nonatomic, strong) NSString *A;
@property (nonatomic, strong) NSString *B;
@property (nonatomic, assign) BOOL cantAccessVar;

@end

@implementation LCDKVCPerson {
    NSString *_C;
    NSString *_D;
    NSString *_E;
    NSString *_isF;
    NSString *G;
    NSString *isH;
}

- (NSString *)getA {
    return @"通过-(NSString *)getA方法返回的结果：A";
}

-(NSString *)B {
    return @"通过-(NSString *)B方法返回的结果：B";
}

- (NSString *)isC {
    return @"通过-(NSString *)isC方法返回的结果：C";
}

- (NSString *)_D {
    return @"通过-(NSString *)_D方法返回的结果：D";
}

- (id)valueForUndefinedKey:(NSString *)key {
    return [NSString stringWithFormat:@"valueForUndefinedKey里说丰年：没有定义%@啊", key];
}

@end

@interface LCDKVCDog: NSObject
@end

@implementation LCDKVCDog {
    NSString *name;
}

+(BOOL)accessInstanceVariablesDirectly {
    NSLog(@"你看，我就是不让你过去，你能咋地！");
    return NO;
}

@end

@interface LCDKVCViewController ()
@end

@implementation LCDKVCViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

//1. Searches the class of the receiver for an accessor method whose name matches the pattern -get<Key>, -<key>, or -is<Key>, in that order. If such a method is found it is invoked. If the type of the method's result is an object pointer type the result is simply returned. If the type of the result is one of the scalar types supported by NSNumber conversion is done and an NSNumber is returned. Otherwise, conversion is done and an NSValue is returned (new in Mac OS 10.5: results of arbitrary type are converted to NSValues, not just NSPoint, NRange, NSRect, and NSSize).
//2 (introduced in Mac OS 10.7). Otherwise (no simple accessor method is found), searches the class of the receiver for methods whose names match the patterns -countOf<Key> and -indexIn<Key>OfObject: and -objectIn<Key>AtIndex: (corresponding to the primitive methods defined by the NSOrderedSet class) and also -<key>AtIndexes: (corresponding to -[NSOrderedSet objectsAtIndexes:]). If a count method and an indexOf method and at least one of the other two possible methods are found, a collection proxy object that responds to all NSOrderedSet methods is returned. Each NSOrderedSet message sent to the collection proxy object will result in some combination of -countOf<Key>, -indexIn<Key>OfObject:, -objectIn<Key>AtIndex:, and -<key>AtIndexes: messages being sent to the original receiver of -valueForKey:. If the class of the receiver also implements an optional method whose name matches the pattern -get<Key>:range: that method will be used when appropriate for best performance.
//3. Otherwise (no simple accessor method or set of ordered set access methods is found), searches the class of the receiver for methods whose names match the patterns -countOf<Key> and -objectIn<Key>AtIndex: (corresponding to the primitive methods defined by the NSArray class) and (introduced in Mac OS 10.4) also -<key>AtIndexes: (corresponding to -[NSArray objectsAtIndexes:]). If a count method and at least one of the other two possible methods are found, a collection proxy object that responds to all NSArray methods is returned. Each NSArray message sent to the collection proxy object will result in some combination of -countOf<Key>, -objectIn<Key>AtIndex:, and -<key>AtIndexes: messages being sent to the original receiver of -valueForKey:. If the class of the receiver also implements an optional method whose name matches the pattern -get<Key>:range: that method will be used when appropriate for best performance.
//4 (introduced in Mac OS 10.4). Otherwise (no simple accessor method or set of ordered set or array access methods is found), searches the class of the receiver for a threesome of methods whose names match the patterns -countOf<Key>, -enumeratorOf<Key>, and -memberOf<Key>: (corresponding to the primitive methods defined by the NSSet class). If all three such methods are found a collection proxy object that responds to all NSSet methods is returned. Each NSSet message sent to the collection proxy object will result in some combination of -countOf<Key>, -enumeratorOf<Key>, and -memberOf<Key>: messages being sent to the original receiver of -valueForKey:.
//5. Otherwise (no simple accessor method or set of collection access methods is found), if the receiver's class' +accessInstanceVariablesDirectly property returns YES, searches the class of the receiver for an instance variable whose name matches the pattern _<key>, _is<Key>, <key>, or is<Key>, in that order. If such an instance variable is found, the value of the instance variable in the receiver is returned, with the same sort of conversion to NSNumber or NSValue as in step 1.
//6. Otherwise (no simple accessor method, set of collection access methods, or instance variable is found), invokes -valueForUndefinedKey: and returns the result. The default implementation of -valueForUndefinedKey: raises an NSUndefinedKeyException, but you can override it in your application.

#pragma mark override
-(NSArray *)buildArrayData {
    return @[@"valueForA调用顺序方法1.-getA",
             @"valueForB调用顺序方法2.-b",
             @"valueForC调用顺序方法3.-isGetC",
             @"valueForD调用顺序方法4.-_D",
             @"valueForE调用顺序成员变量5._E",
             @"valueForF调用顺序成员变量5._isF",
             @"valueForG调用顺序成员变量5.G",
             @"valueForH调用顺序成员变量5.isH",
             @"valueForI没有定义I，走到valueForUndefineKey方法",
             @"accessInstanceVariablesDirectly为NO，闪退",
             ];
}

-(void)actionForIndex:(NSInteger)index {
    LCDKVCPerson *person = [LCDKVCPerson new];
    LCDKVCDog *dog = [LCDKVCDog new];
    [person setValue:@"通过成员变量_E获取值" forKey:@"E"];
    [person setValue:@"通过成员变量_isF获取值" forKey:@"F"];
    [person setValue:@"通过成员变量G获取值" forKey:@"G"];
    [person setValue:@"通过成员变量isH获取值" forKey:@"H"];
    switch (index) {
        case 0:
            [self log:[person valueForKey:@"A"]];
            break;
        case 1:
            [self log:[person valueForKey:@"B"]];
            break;
        case 2:
            [self log:[person valueForKey:@"C"]];
            break;
        case 3:
            [self log:[person valueForKey:@"D"]];
            break;
        case 4:
            [self log:[person valueForKey:@"E"]];
            break;
        case 5:
            [self log:[person valueForKey:@"F"]];
            break;
        case 6:
            [self log:[person valueForKey:@"G"]];
            break;
        case 7:
            [self log:[person valueForKey:@"H"]];
            break;
        case 8:
            [self log:[person valueForKey:@"I"]];
            break;
        case 9:
            [self log:[dog valueForKey:@"name"]];
            break;

        default:
            break;
    }
}

@end
