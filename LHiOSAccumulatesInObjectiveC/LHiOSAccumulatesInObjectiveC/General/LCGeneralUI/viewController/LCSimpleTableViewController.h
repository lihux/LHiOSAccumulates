//
//  LCSimpleTableViewController.h
//  LHiOSAccumulatesInObjectiveC
//
//  Created by 李辉 on 2018/8/9.
//  Copyright © 2018年 Lihux. All rights reserved.
//

#import "LCViewController.h"


/**
 使用方法有两种：2选一，使用时可根据需要酌情选用
 1.重载buildDictionaryData，返回以内容和对应调用方法的键值对；
 2.同时重载buildArrayData和actionForIndex:前者返回内容，后者负责分发点击的事件处理；
 */
@interface LCSimpleTableViewController : LCViewController


/**
 子类必须重写此方法以构建UITableView的数据源，数据源应该返回的是一个字典，其中key是展示的内容，value是对应的调用方法

 @return 数据源字段
 */
- (NSDictionary *)buildDictionaryData;

/**
 子类重写此方法以构建UITableView的数据源，数据源应该返回的是一个数组，包含要展示的内容
 
 @return 数据源字段
 */
- (NSArray *)buildArrayData;

/**
 和buildArrayData方法组合使用，重载此方法，告知点击第index个cell的时候要干什么

 @param index 用户点击的cell的index
 */
- (void)actionForIndex:(NSInteger)index;

@end
