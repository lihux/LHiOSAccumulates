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
    testStructSize();
}

@end

void testStructSize(void) {
    struct House {
        char c;
        int i;
    };
    struct House arr[10];
    for (int i = 0; i < 10; i ++) {
        printf("\nstruct House arr[%d] address = %p, arr[%d].i address = %p\n", i, &arr[i], i, &arr[i].i);
    }
    printf("House的长度是：%lu, 数组的长度是：%lu", sizeof(struct House), sizeof(arr));
}
