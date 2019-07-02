//
//  LCToutchImageView.m
//  LHiOSAccumulatesInObjectiveC
//
//  Created by 李辉 on 2019/7/2.
//  Copyright © 2019 Lihux. All rights reserved.
//

#import "LCToutchImageView.h"

@implementation LCToutchImageView

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@"\n\n%s",__func__);
    [super touchesBegan:touches withEvent:event];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@"\n\n%s",__func__);
    [super touchesEnded:touches withEvent:event];
}

-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@"\n\n%s",__func__);
    [super touchesMoved:touches withEvent:event];
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@"\n\n%s",__func__);
    [super touchesCancelled:touches withEvent:event];
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *view = [super hitTest:point withEvent:event];
    NSLog(@"\n\n%s: %@", __func__, view);
    return view;
}


@end
