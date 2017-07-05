//
//  LCDCSByteView.m
//  LHiOSAccumulatesInObjectiveC
//
//  Created by lihui on 2017/6/29.
//  Copyright © 2017年 Lihux. All rights reserved.
//

#import "LCDCSByteView.h"

#import "LCDCSBitButton.h"
#import "UIView+LHAutoLayout.h"

#define kLCDSByte 8
@implementation LCDCSByteView

- (void)fillByteWithShort:(short)shortValue Offset:(LCDCSByteOffset)offset {}
- (void)fillByteWithInt8:(int8_t)int8Value Offset:(LCDCSByteOffset)offset {}
- (void)fillByteWithInt16:(int16_t)int16Value Offset:(LCDCSByteOffset)offset {}
- (void)fillByteWithInt32:(int32_t)int32Value Offset:(LCDCSByteOffset)offset {}
- (void)fillByteWithInt64:(int32_t)int64Value Offset:(LCDCSByteOffset)offset {}
- (void)fillByteWithfloat:(float)floatValue Offset:(LCDCSByteOffset)offset {}
- (void)fillByteWithDouble:(double)doubleValue Offset:(LCDCSByteOffset)offset {}
- (void)fillByteWithFloat96:(Float96)int8Value Offset:(LCDCSByteOffset)offset {} //Unimplement Righ Now

- (NSArray<LCDCSBitButton *> *)bitButtons {
    if (_bitButtons) {
        return _bitButtons;
    }
    NSMutableArray *temp = [NSMutableArray arrayWithCapacity:kLCDSByte];
    for (int i = 0; i < kLCDSByte; i ++ ) {
        LCDCSBitButton *button = [[LCDCSBitButton alloc] init];
        button.tag = i;
        [temp addObject:button];
    }
    _bitButtons = temp;
    return _bitButtons;
}

-(void)layoutSubviews {
    CGFloat buttonGap = 2;
    CGFloat targetHeight = (self.frame.size.width - (buttonGap * 7)) / 8;
    NSLayoutConstraint *heightConstraint = [self lh_heightConstraint];
    if (heightConstraint) {
        heightConstraint.constant = targetHeight;
    }
}

@end
