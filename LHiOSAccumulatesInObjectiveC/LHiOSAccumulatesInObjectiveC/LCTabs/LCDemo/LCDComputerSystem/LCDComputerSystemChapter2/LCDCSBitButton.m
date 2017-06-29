//
//  LCDCSBitButton.m
//  LHiOSAccumulatesInObjectiveC
//
//  Created by lihui on 2017/6/29.
//  Copyright © 2017年 Lihux. All rights reserved.
//

#import "LCDCSBitButton.h"

#import "UIColor+helper.h"


@implementation LCDCSBitButton

- (void)awakeFromNib {
    [super awakeFromNib];
    self.layer.cornerRadius = 4;
    self.clipsToBounds = YES;
}

- (void)setBit:(BOOL)bit {
    self.backgroundColor = bit ? [UIColor colorWithHex:0xFF0000] : [UIColor colorWithHex:0x00FF00];
    [self setTitle:[NSString stringWithFormat:@"%zd", bit] forState:UIControlStateNormal];
}

- (void)fillBitWithShort:(short)shortValue Power:(LCDCSBitPower)power {
}

- (void)fillBitWithInt8:(int8_t)int8Value Power:(LCDCSBitPower)power {
}

- (void)fillBitWithInt16:(int16_t)int16Value Power:(LCDCSBitPower)power {
}

- (void)fillBitWithInt32:(int32_t)int32Value Power:(LCDCSBitPower)power {
}

- (void)fillBitWithInt64:(int32_t)int64Value Power:(LCDCSBitPower)power {
}

- (void)fillBitWithfloat:(float)floatValue Power:(LCDCSBitPower)power {//float == Float32
}

- (void)fillBitWithDouble:(double)doubleValue Power:(LCDCSBitPower)power {//double == Float64
}

- (void)fillBitWithFloat96:(Float96)int8Value Power:(LCDCSBitPower)power { //UnimplementRigh Now
}

@end
