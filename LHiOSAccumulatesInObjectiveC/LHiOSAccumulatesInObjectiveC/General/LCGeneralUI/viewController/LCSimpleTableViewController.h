//
//  LCSimpleTableViewController.h
//  LHiOSAccumulatesInObjectiveC
//
//  Created by 李辉 on 2018/8/9.
//  Copyright © 2018年 Lihux. All rights reserved.
//

#import "LCViewController.h"

@interface LCSimpleTableViewController : LCViewController


/**
 子类必须重写此方法以构建UITableView的数据源，数据源应该返回的是一个字典，其中key是展示的内容，value是对应的调用方法

 @return 数据源字段
 */
- (NSDictionary *)buildData;

@end
