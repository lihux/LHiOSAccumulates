//
//  LCAnimationKeyPathPathView.m
//  LHiOSAccumulatesInObjectiveC
//
//  Created by 李辉 on 2017/7/27.
//  Copyright © 2017年 Lihux. All rights reserved.
//

#import "LCAnimationKeyPathPathView.h"

@implementation LCAnimationKeyPathPathView

- (void)drawRect:(CGRect)rect {
    if (![self.delegate respondsToSelector:@selector(pointsForCount:)]) {
        return;
    }
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGContextSetLineWidth(context, 2);
    NSArray *colors = @[[UIColor whiteColor],
                        [UIColor yellowColor],
                        [UIColor blueColor],
                        [UIColor cyanColor],
                        [UIColor greenColor]];
    for (NSInteger i = 3; i < 7; i ++) {
        NSArray *points = [self.delegate pointsForCount:i];
        NSInteger count = points.count;
        UIColor *strokeColor = colors[i % colors.count];
        NSLog(@"选中的颜色是：%@", strokeColor);
        CGContextSetStrokeColorWithColor(context, strokeColor.CGColor);
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:[self transferedPoint:[points[0] CGPointValue]]];
        for (NSInteger j = 1; j <= count; j ++) {
            [path addLineToPoint:[self transferedPoint:[points[ j % count] CGPointValue]]];
        }
        [path stroke];
//        CGContextStrokePath(context);
    }
    CGContextRestoreGState(context);
}

- (CGPoint)transferedPoint:(CGPoint)point {
    CGPoint temp = CGPointMake(point.x + self.bounds.size.width / 2, point.y + self.bounds.size.height / 2);
    NSLog(@"转换后的位置：x = %lf, y = %lf", temp.x, temp.y);
    return temp;
}

@end
