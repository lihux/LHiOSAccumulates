//
//  LCDBNSProxyViewController.m
//  LHiOSAccumulatesInObjectiveC
//
//  Created by 李辉 on 2017/9/14.
//  Copyright © 2017年 Lihux. All rights reserved.
//

#import "LCDBNSProxyViewController.h"

#import "LCDBDealerProxy.h"

@interface LCDBNSProxyViewController ()

@property (nonatomic, strong) LCDBDealerProxy *dealer;

@end

@implementation LCDBNSProxyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dealer = [LCDBDealerProxy dealerInstance];
}

- (IBAction)didTapOnBuyBookButton:(id)sender {
    [self log:[self.dealer purchaseBookWithTitle:@"深入理解计算机系统（第三版）"]];
}

- (IBAction)didTapOnBuyClothesButton:(id)sender {
    [self log:[self.dealer purchaseClothesWithSize:LCDBClothesSizeMedium]];
}

@end
