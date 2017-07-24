//
//  LCDCFloatView.m
//  LHiOSAccumulatesInObjectiveC
//
//  Created by lihui on 2017/7/21.
//  Copyright © 2017年 Lihux. All rights reserved.
//

#import "LCDCFloatView.h"

@implementation LCDCFloatView


- (void)drawRect:(CGRect)rect {
    NSLog(@"重绘");
    CGSize size = self.bounds.size;
    CGFloat width = size.width, height = size.height;
    CGFloat axisY = height / 2;
    CGPoint start = CGPointMake(0, axisY), end = CGPointMake(width, axisY);
    CGContextRef context = UIGraphicsGetCurrentContext();
    //设置画布的基本属性
    CGContextSetLineWidth(context, 1);
    CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
    
    //画x轴
    CGContextMoveToPoint(context, start.x, start.y);
    CGContextAddLineToPoint(context, end.x, end.y);
    //箭头
    CGFloat anchorSize = 5;
    CGContextAddLineToPoint(context, end.x - anchorSize, end.y - anchorSize);
    CGContextMoveToPoint(context, end.x, end.y);
    CGContextAddLineToPoint(context, end.x - anchorSize, end.y + anchorSize);
    CGContextStrokePath(context);
    CGContextSetStrokeColorWithColor(context, [UIColor yellowColor].CGColor);
    CGFloat dotHeight = 4, leftGap = 5, rightGap = 15, usedWidth = width - leftGap - rightGap;
    
    if (self.isFloatDot) {//绘制浮点表示，尾数和阶码占用的位数比值为1:1~1:3
        //http://lihux.me/2017/07/16/Computer-System-A-Pragrammer-s-Perspective-CH2/
        if (self.bitCount < 4) {//符号位、阶码和尾数至少各用[1,2,1]位表示：[s,e,M].length >= 4
            return;
        }
        //画dot线
        //float = (-1)^s * (2^e - bias) * M
        NSInteger ePart = self.ePart, mPart = self.mPart;
        NSInteger baseE = pow(2, ePart), baseM = pow(2, mPart);
        NSInteger bias = pow(2, ePart-1) - 1;
        NSInteger maxRegularE = baseE - 2 - bias, minRegularE = 1 - bias;
        float maxRegularM = 1 + 1 - (1 / (float)baseM);
        float maxRegularValue = maxRegularM * pow(2, maxRegularE), minRegularValue = - maxRegularValue;
        CGFloat axisLength = maxRegularValue - minRegularValue;
        CGFloat oldTextOffset = -50;
        if (1) {
            //先用黄色绘制非规格化的数据集合（-1,1)
            NSInteger unRegularE = 1 - bias;//为了平滑过渡，非规格化E的偏移调整成 -bias + 1
            CGFloat unRegularEValue = pow(2, unRegularE);
            for (NSInteger i = 0; i < baseM; i ++) {
                CGFloat value = (i / (baseM - 1.0)) * unRegularEValue;
//                NSLog(@"非规格化的浮点数：%lf", value);
                //draw +value
                CGFloat ratio = (axisLength - maxRegularValue + value) / axisLength;
                CGFloat x = leftGap + usedWidth * ratio, y = axisY - dotHeight * (i == 0 ? 2 : 1);
                CGContextMoveToPoint(context, x, axisY);
                CGContextAddLineToPoint(context, x, y);
                //draw -value
                ratio = (axisLength - maxRegularValue - value) / axisLength;
                x = leftGap + usedWidth * ratio;
                y = axisY - dotHeight * (i == 0 ? 2 : 1);
                CGContextMoveToPoint(context, x, axisY);
                CGContextAddLineToPoint(context, x, y);
                if (i == 0) {
                    [@"0.0" drawAtPoint:CGPointMake(x - 3, y - 12) withAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:9], NSForegroundColorAttributeName: [UIColor yellowColor]}];
                }
            }
            CGContextStrokePath(context);
            CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
            for (NSInteger e = minRegularE; e <= maxRegularE; e ++) {
                for (NSInteger m = 0; m < baseM; m ++) {
                    CGFloat mValue = 1 + (CGFloat)m / (baseM - 1);
                    CGFloat value = mValue * pow(2, e);
//                    NSLog(@"规格化的浮点数：%lf", value);
                    CGFloat ratio = (axisLength - maxRegularValue + value) / axisLength;
                    BOOL isVIPPoint = NO;
                    if (m == 0 && e >= 0) {//逢整数值BMW5系加长
                        isVIPPoint = YES;
                    }
                    if (e == maxRegularE && m == baseM - 1) {//前后边界值BMW5系加长
                        isVIPPoint = YES;
                    }
                    CGFloat x = leftGap + usedWidth * ratio, y = axisY - dotHeight * (isVIPPoint ? 2 : 1);
                    CGContextMoveToPoint(context, x, axisY);
                    CGContextAddLineToPoint(context, x, y);
                    CGPoint textPoint = CGPointMake(x - 3, y - 10);
                    if (isVIPPoint) {
                        oldTextOffset = textPoint.x;
                        NSString *text = [NSString stringWithFormat:@"%.2f", value];
                        [text drawAtPoint:CGPointMake(x - 3, y - 12) withAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:9], NSForegroundColorAttributeName: [UIColor whiteColor]}];
                    }
                    ratio = (axisLength - maxRegularValue - value) / axisLength;
                    x = leftGap + usedWidth * ratio;
                    CGContextMoveToPoint(context, x, axisY);
                    CGContextAddLineToPoint(context, x, y);
                    textPoint = CGPointMake(x - 3, y - 10);
                    if (isVIPPoint) {
                        oldTextOffset = textPoint.x;
                        NSString *text = [NSString stringWithFormat:@"%.1f", value];
                        [text drawAtPoint:CGPointMake(x - 3, y - 12) withAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:9], NSForegroundColorAttributeName: [UIColor whiteColor]}];
                    }
                    
                }
            }
        }
    } else {//绘制定点表示
        //画dot线
        NSInteger leftPart = self.bitCount / 2; //定点表述实数，取二进制序列的左半个作为整数部分，补码表示；有半个作为小数部分，小数点在中间1111.1001
        NSInteger rightPart = self.bitCount - leftPart;
        NSInteger maxInteger = powf(2, leftPart - 1) - 1;
        NSInteger maxDot = pow(2, rightPart) - 1;
        NSInteger minInteger = - maxInteger - 1;
        CGFloat axisLength = maxInteger - minInteger;
        CGFloat oldTextOffset = -50;
        for (NSInteger i = minInteger; i <= maxInteger; i ++) {
            for (NSInteger j = 0; j < maxDot; j ++) {
                CGFloat dotValue = j / (CGFloat)maxDot;
                CGFloat value = i + dotValue;
                CGFloat ratio = (axisLength - maxInteger + value) / axisLength;
                CGFloat x = leftGap + usedWidth *ratio, y = axisY - dotHeight * (j == 0 ? 2 : 1);
                CGContextMoveToPoint(context, x, axisY);
                CGPoint textPoint = CGPointMake(x - 3, y - 10);
                CGFloat textMinGap = 18;
                if (j == 0 && textPoint.x - oldTextOffset > textMinGap) {
                    oldTextOffset = textPoint.x;
                    NSString *text = [NSString stringWithFormat:@"%zd", i];
                    [text drawAtPoint:CGPointMake(x - 3, y - 12) withAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:9], NSForegroundColorAttributeName: [UIColor whiteColor]}];
                }
                CGContextAddLineToPoint(context, x, y);
            }
        }
    }
    CGContextStrokePath(context);
}

- (void)drawText:(NSString *)text {
    
}

- (void)setBitCount:(NSInteger)bitCount {
    _bitCount = bitCount;
    if (bitCount < 4) {
        return;
    }
    NSInteger valuePart = bitCount - 1;
    NSInteger ePart = 2, mPart = valuePart - ePart;
    if ((valuePart / 4) > 2) {
        ePart = 0.25 * valuePart;
        mPart = valuePart - ePart;
    }
    self.ePart = ePart;
    self.mPart = mPart;
    [self setNeedsDisplay];
}

@end
