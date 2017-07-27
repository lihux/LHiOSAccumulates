//
//  LCAKeyFrameViewController.m
//  LHiOSAccumulatesInObjectiveC
//
//  Created by 李辉 on 2017/7/27.
//  Copyright © 2017年 Lihux. All rights reserved.
//

#import "LCAKeyFrameViewController.h"

#import "LCAnimationKeyPathPathView.h"

#define LCA_Point_Value(x, y) ([NSValue valueWithCGPoint:CGPointMake(x, y)])

@interface LCAKeyFrameViewController () <LCAnimationKeyPathPathViewDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *centerXConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *centerYConstraint;
@property (nonatomic, assign) NSTimeInterval animationTime;
@property (nonatomic, assign) BOOL hasDoneFirstAnimation;
@property (weak, nonatomic) IBOutlet LCAnimationKeyPathPathView *containerView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segment;


@end

@implementation LCAKeyFrameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.animationTime = 4;
    self.containerView.delegate = self;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (!self.hasDoneFirstAnimation) {
        [self segmentValueChanged:self.segment];
    }
}

- (IBAction)segmentValueChanged:(UISegmentedControl *)sender {
    NSInteger count = sender.selectedSegmentIndex + 3;
    NSArray *pointValues = [self pointArrayForCount:count];
    count = pointValues.count;
    CGPoint startPoint = [[pointValues firstObject] CGPointValue];
    self.centerXConstraint.constant = startPoint.x;
    self.centerYConstraint.constant = startPoint.y;
    NSInteger animationCounts = count + 1;
    [UIView animateWithDuration:0.2 animations:^{
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

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
    [self.containerView setNeedsDisplay];
}

#pragma mark - LCAnimationKeyPathPathViewDelegate
- (NSArray *)pointsForCount:(NSInteger)count {
    return [self pointArrayForCount:count];
}

#pragma mark -

- (NSArray <NSValue *>*) pointArrayForCount:(NSInteger)count {
    NSArray *points = [self trianglePoints];
    switch (count) {
        case 3:
            points = [self trianglePoints];
            break;
        case 4:
            points = [self squarePoints];
            break;
        case 5:
            points = [self pentagon];
            break;
        case 6:
            points = [self hexagon];
            break;
            
        default:
            break;
    }
    return points;
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
