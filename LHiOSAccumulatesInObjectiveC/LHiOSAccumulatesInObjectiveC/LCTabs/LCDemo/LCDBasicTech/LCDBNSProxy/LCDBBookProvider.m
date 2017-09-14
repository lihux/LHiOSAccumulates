//
//  LCDBBookProvider.m
//  LHiOSAccumulatesInObjectiveC
//
//  Created by 李辉 on 2017/9/14.
//  Copyright © 2017年 Lihux. All rights reserved.
//

#import "LCDBBookProvider.h"

@interface LCDBBookProvider () <LCDBBookProviderProtocol>

@end
@implementation LCDBBookProvider

- (NSString *)purchaseBookWithTitle:(NSString *)bookTitle{
    return [NSString stringWithFormat:@"主人你好：我已帮你买好了书 \"%@, 喜欢吗😆", bookTitle];
}

@end

