//
//  LCDCSBitButton.h
//  LHiOSAccumulatesInObjectiveC
//
//  Created by lihui on 2017/6/29.
//  Copyright © 2017年 Lihux. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, LCDCSBitPower) {
    LCDCSBitPower0 = 0,
    LCDCSBitPower1,
    LCDCSBitPower2,
    LCDCSBitPower3,
    LCDCSBitPower4,
    LCDCSBitPower5,
    LCDCSBitPower6,
    LCDCSBitPower7,
    LCDCSBitPower8,
    LCDCSBitPower9,
    LCDCSBitPower10,
    LCDCSBitPower11,
    LCDCSBitPower12,
    LCDCSBitPower13,
    LCDCSBitPower14,
    LCDCSBitPower15,
    LCDCSBitPower16,
    LCDCSBitPower17,
    LCDCSBitPower18,
    LCDCSBitPower19,
    LCDCSBitPower20,
    LCDCSBitPower21,
    LCDCSBitPower22,
    LCDCSBitPower23,
    LCDCSBitPower24,
    LCDCSBitPower25,
    LCDCSBitPower26,
    LCDCSBitPower27,
    LCDCSBitPower28,
    LCDCSBitPower29,
    LCDCSBitPower30,
    LCDCSBitPower31,
    LCDCSBitPower32,
    LCDCSBitPower33,
    LCDCSBitPower34,
    LCDCSBitPower35,
    LCDCSBitPower36,
    LCDCSBitPower37,
    LCDCSBitPower38,
    LCDCSBitPower39,
    LCDCSBitPower40,
    LCDCSBitPower41,
    LCDCSBitPower42,
    LCDCSBitPower43,
    LCDCSBitPower44,
    LCDCSBitPower45,
    LCDCSBitPower46,
    LCDCSBitPower47,
    LCDCSBitPower49,
    LCDCSBitPower50,
    LCDCSBitPower51,
    LCDCSBitPower52,
    LCDCSBitPower53,
    LCDCSBitPower54,
    LCDCSBitPower55,
    LCDCSBitPower56,
    LCDCSBitPower57,
    LCDCSBitPower58,
    LCDCSBitPower59,
    LCDCSBitPower60,
    LCDCSBitPower61,
    LCDCSBitPower62,
    LCDCSBitPower63,
};

@interface LCDCSBitButton : UIButton

@property (nonatomic, assign) BOOL bit;

- (void)fillBitWithShort:(short)shortValue Power:(LCDCSBitPower)power;
- (void)fillBitWithInt8:(int8_t)int8Value Power:(LCDCSBitPower)power;
- (void)fillBitWithInt16:(int16_t)int16Value Power:(LCDCSBitPower)power;
- (void)fillBitWithInt32:(int32_t)int32Value Power:(LCDCSBitPower)power;
- (void)fillBitWithInt64:(int32_t)int64Value Power:(LCDCSBitPower)power;
- (void)fillBitWithfloat:(float)floatValue Power:(LCDCSBitPower)power;//float == Float32
- (void)fillBitWithDouble:(double)doubleValue Power:(LCDCSBitPower)power;//double == Float64
- (void)fillBitWithFloat96:(Float96)int8Value Power:(LCDCSBitPower)power; //UnimplementRigh Now

//@property (nonatomic, assign)
@end
