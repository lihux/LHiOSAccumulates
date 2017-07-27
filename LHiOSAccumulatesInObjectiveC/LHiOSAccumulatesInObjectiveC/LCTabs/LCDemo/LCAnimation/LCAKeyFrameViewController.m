//
//  LCAKeyFrameViewController.m
//  LHiOSAccumulatesInObjectiveC
//
//  Created by 李辉 on 2017/7/27.
//  Copyright © 2017年 Lihux. All rights reserved.
//

#import "LCAKeyFrameViewController.h"

#define LCA_Point_Value(x, y) ([NSValue valueWithCGPoint:CGPointMake(x, y)])

@interface LCAKeyFrameViewController ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *centerXConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *centerYConstraint;
@property (nonatomic, assign) NSTimeInterval animationTime;

@end

@implementation LCAKeyFrameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.animationTime = 4;
}

- (IBAction)segmentValueChanged:(UISegmentedControl *)sender {
    NSInteger count = sender.selectedSegmentIndex + 3;
    NSArray *pointValues = [self pointArrayForCount:count];
    count = pointValues.count;
    CGPoint startPoint = [[pointValues firstObject] CGPointValue];
    self.centerXConstraint.constant = startPoint.x;
    self.centerYConstraint.constant = startPoint.y;
    NSInteger animationCounts = count + 1;
    [UIView animateWithDuration:0.5 animations:^{
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        [UIView animateKeyframesWithDuration:self.animationTime delay:0 options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
            for (NSInteger i = 0; i < animationCounts; i ++) {
                NSInteger j = i % count;
                double start = i / (double)animationCounts, duration = 1 / (double)animationCounts;
                CGPoint point = [[pointValues objectAtIndex:j] CGPointValue];
                self.centerXConstraint.constant = point.x;
                self.centerYConstraint.constant = point.y;
                [UIView addKeyframeWithRelativeStartTime:start relativeDuration:duration animations:^{
                    [self.view layoutIfNeeded];
                }];
            }
        } completion:^(BOOL finished) {
            NSLog(@"动画完成");
        }];
    }];
}

- (NSArray <NSValue *>*) pointArrayForCount:(NSInteger)count {
    switch (count) {
        case 3:
            return [self trianglePoints];
            break;
        case 4:
            return [self squarePoints];
            break;
        case 5:
            return [self pentagon];
            break;
        case 6:
            return [self hexagon];
            break;
            
        default:
            break;
    }
    return [self trianglePoints];
}

- (NSArray <NSValue *>*)trianglePoints {
    return @[LCA_Point_Value(0, -100),
             LCA_Point_Value(86.6, 50),
             LCA_Point_Value(-86.6, 50)];
}

- (NSArray <NSValue *>*)squarePoints {
    return @[LCA_Point_Value(0, -100),
             LCA_Point_Value(100, 0),
             LCA_Point_Value(0, 100),
             LCA_Point_Value(-100, 0)];
}

- (NSArray <NSValue *>*)pentagon {
    return @[LCA_Point_Value(0, -100),
             LCA_Point_Value(95.11, -30.9),
             LCA_Point_Value(58.78, 80.9),
             LCA_Point_Value(-58.78, 80.9),
             LCA_Point_Value(-95.11, -30.9)];
}

- (NSArray <NSValue *>*)hexagon {
    return @[LCA_Point_Value(0, -100),
             LCA_Point_Value(86.6, -50),
             LCA_Point_Value(86.6, 50),
             LCA_Point_Value(0, 100),
             LCA_Point_Value(-86.6, 50),
             LCA_Point_Value(-86.6, -50)];
}

@end
