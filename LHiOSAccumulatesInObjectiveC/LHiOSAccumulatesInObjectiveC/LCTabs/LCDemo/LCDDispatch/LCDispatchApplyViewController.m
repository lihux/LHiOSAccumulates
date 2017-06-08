//
//  LCDispatchApplyViewController.m
//  LHiOSAccumulatesInObjectiveC
//
//  Created by lihui on 2017/4/26.
//  Copyright © 2017年 Lihux. All rights reserved.
//

#import "LCDispatchApplyViewController.h"
#import "LCUtilities.h"

@interface LCDispatchApplyViewController ()

@property (weak, nonatomic) IBOutlet UITextView *outputTextView;

@property (nonatomic, strong) NSMutableString *outputString;

@end

@implementation LCDispatchApplyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.outputString = [NSMutableString string];
    [self makeLihuxStyleOfSubviewsFromParent:self.view];
}

- (IBAction)didTapOnGoBackButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)didTapOnButton:(id)sender {
    UIButton *button = (UIButton *)sender;
    NSInteger tag = button.tag;
    button.tag = tag + 1;
    [self updateOutPutStringWithTag:tag];
    [button setTitle:[NSString stringWithFormat:@"点击触发dispatch_apply(%zd)次", tag + 1] forState:UIControlStateNormal];
}

- (void)updateOutPutStringWithTag:(NSInteger)tag {
    [self.outputString appendString:[NSString stringWithFormat:@"\n\n\n点击触发dispatch_apply(%zd)次", tag]];
    self.outputTextView.text = self.outputString;
    @weakify(self);
    dispatch_apply(tag, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(size_t index) {
        @strongify(self);
        NSString *content = [NSString stringWithFormat:@"\n并发%zd个中的第%zd此计算在线程%@上进行\n", tag, index, [NSThread currentThread]];
        [self.outputString appendString:content];//多线程同时写，可能会有问题
        NSLog(@"%@", content);
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    NSLog(@"我释放了");
}

@end
