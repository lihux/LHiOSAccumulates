//
//  DummyObject.h
//  LHiOSAccumulatesInObjectiveC
//
//  Created by lihui on 2019/7/6.
//  Copyright © 2019 Lihux. All rights reserved.
//

#import <Foundation/Foundation.h>

#define DummySize(size) (size - 8)

#define Dummy_Struct(num) struct Dummy##num##B {char a[num - 8];};

Dummy_Struct(9)
Dummy_Struct(15)
Dummy_Struct(23)
Dummy_Struct(513)
Dummy_Struct(1025)

@interface Dummy9BObject : NSObject
@property (nonatomic, assign) char a;
@end

@interface Dummy15BObject : NSObject
@property (nonatomic, assign) struct Dummy15B a;
@end

@interface Dummy23BObject : NSObject
@property (nonatomic, assign) struct Dummy23B a;
@end

@interface Dummy513BObject : NSObject
@property (nonatomic, assign) struct Dummy513B s;
@end

@interface Dummy1025BObject : NSObject
@property (nonatomic, assign) struct Dummy1025B s;
@end

@interface DummyObject : NSObject

+ (NSArray *)testClasses;

@end

