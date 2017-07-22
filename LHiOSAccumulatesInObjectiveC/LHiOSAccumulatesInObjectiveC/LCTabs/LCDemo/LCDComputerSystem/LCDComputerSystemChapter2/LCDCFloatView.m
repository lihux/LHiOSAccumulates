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
    CGContextSetStrokeColorWithColor(context, [UIColor yellowColor].CGColor);
    
    //画x轴
    CGContextMoveToPoint(context, start.x, start.y);
    CGContextAddLineToPoint(context, end.x, end.y);
    //箭头
    CGFloat anchorSize = 5;
    CGContextAddLineToPoint(context, end.x - anchorSize, end.y - anchorSize);
    CGContextMoveToPoint(context, end.x, end.y);
    CGContextAddLineToPoint(context, end.x - anchorSize, end.y + anchorSize);
    
    if (self.isFloatDot) {
        //画dot线
        NSInteger leftPart = self.bitCount / 2; //定点表述实数，取二进制序列的左半个作为整数部分，补码表示；有半个作为小数部分，小数点在中间1111.1001
        NSInteger rightPart = self.bitCount - leftPart;
        NSInteger maxInteger = powf(2, leftPart - 1) - 1;
        NSInteger maxDot = pow(2, rightPart) - 1;
        NSInteger minInteger = - maxInteger - 1;
        CGFloat axisLength = maxInteger - minInteger;
        CGFloat dotHeight = 4, leftGap = 5, rightGap = 15, usedWidth = width - leftGap - rightGap;
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
    } else {
        //画dot线
        NSInteger leftPart = self.bitCount / 2; //定点表述实数，取二进制序列的左半个作为整数部分，补码表示；有半个作为小数部分，小数点在中间1111.1001
        NSInteger rightPart = self.bitCount - leftPart;
        NSInteger maxInteger = powf(2, leftPart - 1) - 1;
        NSInteger maxDot = pow(2, rightPart) - 1;
        NSInteger minInteger = - maxInteger - 1;
        CGFloat axisLength = maxInteger - minInteger;
        CGFloat dotHeight = 4, leftGap = 5, rightGap = 15, usedWidth = width - leftGap - rightGap;
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

- (void)setBitCount:(NSInteger)bitCount {
    _bitCount = bitCount;
    [self setNeedsDisplay];
}

@end
