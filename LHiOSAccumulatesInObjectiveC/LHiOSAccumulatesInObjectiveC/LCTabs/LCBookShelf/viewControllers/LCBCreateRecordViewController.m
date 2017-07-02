//
//  LCBCreateRecordViewController.m
//  LHiOSAccumulatesInObjectiveC
//
//  Created by lihui on 2017/7/2.
//  Copyright © 2017年 Lihux. All rights reserved.
//

#import "LCBCreateRecordViewController.h"

#import "LCBookShelf+CoreDataModel.h"

@interface LCBCreateRecordViewController ()

@property (nonatomic, strong) LCBookReadingPlan *plan;
@end

@implementation LCBCreateRecordViewController

+ (instancetype)createRecordViewControllerForReadingPlan:(LCBookReadingPlan *)plan {
    LCBCreateRecordViewController *vc = [LCBCreateRecordViewController loadViewControllerFromStoryboard:@"  LCBookShelf"];
    vc.plan = plan;
    return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

@end
