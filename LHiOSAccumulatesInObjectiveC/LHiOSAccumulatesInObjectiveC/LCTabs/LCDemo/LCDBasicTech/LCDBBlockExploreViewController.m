//
//  LCDBBlockExploreViewController.m
//  LHiOSAccumulatesInObjectiveC
//
//  Created by lihui on 2017/6/17.
//  Copyright © 2017年 Lihux. All rights reserved.
//

#import "LCDBBlockExploreViewController.h"

typedef void(^LCDBCompletionBlock)(BOOL);

@interface LCDBBlockExploreViewController ()

@property (weak, nonatomic) IBOutlet UIView *contentView;

@end

@implementation LCDBBlockExploreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSInteger aa = 1;
    NSInteger *bb = &aa;
    NSString *cc = @"hello";
    __block NSString *dd = [NSString stringWithFormat:@"%@", cc];
    NSArray *ee = @[@1, @2];
    NSMutableArray *ff = [NSMutableArray arrayWithArray:ee];
    [self log:[NSString stringWithFormat:@"地址信息是：aa: %lld, bb: %lld, cc: %lld, dd: %lld, ee: %lld, ff: %lld", &aa, &bb, &cc, &dd, &ee, &ff]];
    [self testBlock:^(BOOL finished) {
        NSInteger aaa = aa;
        NSInteger *bbb = bb;
        NSInteger bbbb = *bb;
        NSArray *eee = ee;
        
        NSString *ddd = dd;
        dd = @"周杰伦";
        NSLog(@"ddd:%@,dd:%@,&ddd:%lld,&dd:%lld", ddd, dd , &ddd, &dd);
        NSNumber *fff = [ff objectAtIndex:1];
        if (finished) {
            [self log:@"block被调用"];
        }
    }];
}
- (UIView *)logAnchorView {
    return self.contentView;
}

- (void)testBlock:(LCDBCompletionBlock)block {
    if (block) {
        block(YES);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
