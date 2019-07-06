//
//  DummyObject.h
//  LHiOSAccumulatesInObjectiveC
//
//  Created by lihui on 2019/7/6.
//  Copyright © 2019 Lihux. All rights reserved.
//

#import <Foundation/Foundation.h>

#define DummySize(size) (size - 8)
struct Dummy4B {
    char a[4];
};

struct Dummy16B {
    int *p1;
    int *p2;
};

struct Dummy513B {
    char a[DummySize(513)];
};

struct Dummy1111B {
    char a[DummySize(1111)];
};

@interface Dummy9BObject : NSObject
@property (nonatomic, strong) NSString *str;
@property (nonatomic, assign) char a;
@end

@interface Dummy15BObject : NSObject
@property (nonatomic, assign) char a;
@property (nonatomic, assign) char b;
@property (nonatomic, assign) char c;
@property (nonatomic, assign) char d;
@property (nonatomic, assign) char a1;
@property (nonatomic, assign) char b2;
@property (nonatomic, assign) char c3;
@end

@interface DummyStrIntBObject : NSObject
@property (nonatomic, strong) NSString *str;
@property (nonatomic, assign) int a;
@end

@interface Dummy520BObject : NSObject
@property (nonatomic, assign) struct Dummy513B s;
@end

@interface Dummy1111BObject : NSObject
@property (nonatomic, assign) struct Dummy1111B s;
@end

@interface DummyObject : NSObject

+ (NSArray *)testClasses;

@end

