//
//  LCDBENUMExploreViewController.m
//  LHiOSAccumulatesInObjectiveC
//
//  Created by lihui on 2017/6/17.
//  Copyright © 2017年 Lihux. All rights reserved.
//

#import "LCDBENUMExploreViewController.h"

enum {
    AA1,
    AA2,
    AA3,
};

typedef enum : NSUInteger {
    BB1,
    BB2,
    BB3,
} BB;

OBJC_ENUM(NSUInteger, CC) {
    CC1,
    CC2,
    CC3,
};

//#define OBJC_ENUM(_type, _name) enum _name : _type _name; enum _name : _type
enum DD : NSUInteger DD;
enum DD : NSUInteger {
    DD1,
    DD2,
    DD3,
};

//#define NS_ENUM(...) CF_ENUM(__VA_ARGS__)
typedef NS_ENUM(NSUInteger, EE) {
    EE1,
    EE2,
    EE3,
};

typedef CF_ENUM(NSUInteger, FF) {
    FF1,
    FF2,
    FF3,
};

//#define NS_OPTIONS(_type, _name) CF_OPTIONS(_type, _name)
typedef NS_OPTIONS(NSUInteger, GG) {
    GG1 = 1 << 0,
    GG2 = 1 << 1,
    GG3 = 1 << 2,
};

typedef CF_OPTIONS(NSUInteger, HH) {
    HH1 = 1 << 0,
    HH2 = 1 << 1,
    HH3 = 1 << 2,
};

enum {
    II1,
    II2,
    II3,
};
typedef NSUInteger II;

//OS_ENUM 同DISPATCH_ENUM
DISPATCH_ENUM(JJ, NSUInteger, JJ1, JJ2);

@interface LCDBENUMExploreViewController ()

@property (weak, nonatomic) IBOutlet UIView *contentView;

@end

@implementation LCDBENUMExploreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)testEnum {
    NSUInteger a = AA1;//enum
    BB b = BB1;//typedef enum
    enum CC c = CC1;//OBJC_ENUM
    enum DD d = DD1;//同OBJC_ENUM
    EE e = EE1;//type NS_ENUM
    FF f = FF1;//CF_ENUM
    GG g = GG1;//NS_OPTIONS
    HH h = HH1;//CF_OPTIONS
    II;//enum + typedef
    JJ_t j = JJ1;//DISPATCH_ENUM
}

#pragma mrk - Debug
- (UIView *)logAnchorView {
    return self.contentView;
}

@end
