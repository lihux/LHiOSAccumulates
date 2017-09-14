//
//  LCDBNSProxyViewController.m
//  LHiOSAccumulatesInObjectiveC
//
//  Created by 李辉 on 2017/9/14.
//  Copyright © 2017年 Lihux. All rights reserved.
//

#import "LCDBNSProxyViewController.h"

#import "LCDBDealerProxy.h"


/**
 个人理解：其实没必要非要继承自NSProxy，继承普通的NSObject也是可以的，这里的关键其实是利用了runtime的消息发射机制 by lihux
 
 参考文章：
 1. http://www.jianshu.com/p/8e700673202b
 2. http://blog.sunnyxx.com/2014/08/24/objc-duck/
 
 */
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
