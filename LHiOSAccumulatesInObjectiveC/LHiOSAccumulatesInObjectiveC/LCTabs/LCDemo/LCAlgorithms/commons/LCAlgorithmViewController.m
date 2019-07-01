//
//  LCAlgorithmViewController.m
//  LHiOSAccumulatesInObjectiveC
//
//  Created by lihui on 2019/5/27.
//  Copyright © 2019 Lihux. All rights reserved.
//

#import "LCAlgorithmViewController.h"

@interface LCAlgorithmViewController ()

@property (weak, nonatomic) IBOutlet UITextView *infoTextView;

@end

void testStructSize(void);

@implementation LCAlgorithmViewController

- (void)viewDidLoad {
    self.infoTextView.tag = kLCNeedShowDebugLogViewTag;//一定要在调用super之前调用
    [super viewDidLoad];
    self.infoTextView.text = self.accumulate.content;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    Class cls = NSClassFromString(self.accumulate.extraInfo);
    if (cls) {
        [cls new];
    }
}

@end
