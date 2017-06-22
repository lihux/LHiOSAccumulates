//
//  LCBShelfTableViewCell.m
//  LHiOSAccumulatesInObjectiveC
//
//  Created by 李辉 on 2017/6/22.
//  Copyright © 2017年 Lihux. All rights reserved.
//

#import "LCBShelfTableViewCell.h"

#import "LCBook+CoreDataClass.h"

@implementation LCBShelfTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

-(void)setBook:(LCBook *)book {
    _book = book;
}
@end
