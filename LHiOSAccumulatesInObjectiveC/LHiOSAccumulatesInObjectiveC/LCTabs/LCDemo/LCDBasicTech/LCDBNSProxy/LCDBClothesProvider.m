//
//  LCDBClothesProvider.m
//  LHiOSAccumulatesInObjectiveC
//
//  Created by 李辉 on 2017/9/14.
//  Copyright © 2017年 Lihux. All rights reserved.
//

#import "LCDBClothesProvider.h"

@interface LCDBClothesProvider () <LCDBClothesProviderProtocol>

@end

@implementation LCDBClothesProvider

- (NSString *)purchaseClothesWithSize:(LCDBClothesSize )size {
    NSString *sizeStr;
    switch (size) {
        case LCDBClothesSizeLarge:
            sizeStr = @"large size";
            break;
        case LCDBClothesSizeMedium:
            sizeStr = @"medium size";
            break;
        case LCDBClothesSizeSmall:
            sizeStr = @"small size";
            break;
        default:
            break;
    }
    return [NSString stringWithFormat:@"主人你好：我已帮你买好了 %@的衣服，喜欢吗😍", sizeStr];
}

@end
