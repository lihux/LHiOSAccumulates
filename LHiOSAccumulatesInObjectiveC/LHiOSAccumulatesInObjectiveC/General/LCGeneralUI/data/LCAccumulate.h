//
//  LCAccumulate.h
//  LHiOSAccumulatesInObjectiveC
//
//  Created by lihui on 16/1/16.
//  Copyright © 2016年 Lihux. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 里面含有跳转到目的ViewController的三种用法：
 1.如果plistName不为空，则跳转到由plistName加载出来的数据源的目录页面，否则进入到2；
 2.如果storyboardName，则通过storyboard加载viewController(当然storyboardID也需要有值)，否则进入到3；
 3.如果storyboardID，则假定storyboardID就是viewController的类名，直接生成Class，进而调用new方法生成，否则进入到4；
 4.加载失败，返回空;
 */
@interface LCAccumulate : NSObject

@property (nonatomic, strong) NSString* title;
@property (nonatomic, strong) NSString* viewControllerTitle;
@property (nonatomic, strong) NSString* content;
@property (nonatomic, strong) NSString* plistName;
@property (nonatomic, strong) NSString* storyboardID;
@property (nonatomic, strong) NSString* storyboardName;
@property (nonatomic, strong) NSString* extraInfo;

- (instancetype)initWithDictionary:(NSDictionary *)dic;

@end
