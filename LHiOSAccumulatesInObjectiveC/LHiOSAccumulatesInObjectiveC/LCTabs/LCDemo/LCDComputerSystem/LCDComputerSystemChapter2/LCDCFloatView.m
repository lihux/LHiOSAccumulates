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
    CGContextSetLineWidth(context, 2);
    CGContextSetStrokeColorWithColor(context, [UIColor yellowColor].CGColor);
    
    //画x轴
    CGContextMoveToPoint(context, start.x, start.y);
    CGContextAddLineToPoint(context, end.x, end.y);
    //箭头
    CGFloat anchorSize = 5;
    CGContextAddLineToPoint(context, end.x - anchorSize, end.y - anchorSize);
    CGContextMoveToPoint(context, end.x, end.y);
    CGContextAddLineToPoint(context, end.x - anchorSize, end.y + anchorSize);
    
    //画dot线
    NSInteger leftPart = self.bitCount / 2;
    NSInteger rightPart = self.bitCount - leftPart;
    NSInteger maxInteger = powf(2, leftPart - 1) - 1;
    NSInteger minInteger = - maxInteger - 1;
    CGFloat axisLength = maxInteger - minInteger;
    CGFloat dotHeight = 4, usedWidth = width - 15;
    for (NSInteger i = minInteger; i <= maxInteger; i ++) {
        CGFloat ratio = (axisLength - maxInteger + i) / axisLength;
        CGContextMoveToPoint(context, usedWidth * ratio, axisY);
        CGContextAddLineToPoint(context, usedWidth * ratio, axisY - dotHeight);
    }
    
    CGContextStrokePath(context);
}

- (void)setBitCount:(NSInteger)bitCount {
    _bitCount = bitCount;
    [self setNeedsDisplay];
}

@end
