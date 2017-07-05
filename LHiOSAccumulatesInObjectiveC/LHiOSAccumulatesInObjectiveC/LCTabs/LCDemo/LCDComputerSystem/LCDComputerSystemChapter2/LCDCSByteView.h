//
//  LCDCSByteView.h
//  LHiOSAccumulatesInObjectiveC
//
//  Created by lihui on 2017/6/29.
//  Copyright © 2017年 Lihux. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LCDCSBitButton;

typedef NS_ENUM(NSUInteger, LCDCSByteOffset) {
    LCDCSByteOffset0 = 0,
    LCDCSByteOffset1,
    LCDCSByteOffset2,
    LCDCSByteOffset3,
    LCDCSByteOffset4,
    LCDCSByteOffset5,
    LCDCSByteOffset6,
    LCDCSByteOffset7,
};

@interface LCDCSByteView : UIView

@property (nonatomic, copy) NSArray <LCDCSBitButton *> *bitButtons;

- (void)fillByteWithShort:(short)shortValue Offset:(LCDCSByteOffset)offset;
- (void)fillByteWithInt8:(int8_t)int8Value Offset:(LCDCSByteOffset)offset;
- (void)fillByteWithInt16:(int16_t)int16Value Offset:(LCDCSByteOffset)offset;
- (void)fillByteWithInt32:(int32_t)int32Value Offset:(LCDCSByteOffset)offset;
- (void)fillByteWithInt64:(int32_t)int64Value Offset:(LCDCSByteOffset)offset;
- (void)fillByteWithfloat:(float)floatValue Offset:(LCDCSByteOffset)offset;//float == Float32
- (void)fillByteWithDouble:(double)doubleValue Offset:(LCDCSByteOffset)offset;//double == Float64
- (void)fillByteWithFloat96:(Float96)int8Value Offset:(LCDCSByteOffset)offset; //UnimplementRigh Now

@end
