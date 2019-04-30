//
//  LCViewController.h
//  LHiOSAccumulatesInObjectiveC
//
//  Created by lihui on 2017/4/26.
//  Copyright © 2017年 Lihux. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "LCSectionHeaderView.h"
#import "UIColor+helper.h"
#import "LCLihuxHelper.h"

/**
 NOTE && IMPORTANT:继承自LCViewController的所有子类，都将遵从一下两个规则：
 1. 必须要将所有子View包含在一个container View中，也即VC的顶级View，
 只有一个(VC.view.subviews.count == 1)，如果不设置，在页面加载的时候，NSAssert会直接挂掉APP，如果需要添加日志系统，还必须要将这个View的tag设置成为`kLCNeedShowDebugLogViewTag（9999）`；
 2.LCViewController会对所有的子View进行lihux Style风格的样式调整，具体而言就是：让背景颜色透明，所有的字体设置为白色，如果你有子View不想采取这种风格设置，
 请将其tag设置为`kLCNonLihuxStyleViewTag（-9999）`
 
 因为logView的添加，会依赖于一个锚点view，通常这个anchor view会是工作区所有子内容的container view，（这样便于掌控全局），理想状态下的锚点view和log view
 的布局关系应该是各占一半空间，横屏时左右布局、竖屏时上下布局，如下所示：
 
 竖屏时：                       横屏时：
 **********************        ***********************************
 *                    *        *                *                *
 *                    *        *                *                *
 *    anchor view     *        *                *                *
 *                    *        *                *                *
 *                    *        *  anchor view   *    log view    *
 *                    *        *                *                *
 **********************        *                *                *
 *                    *        *                *                *
 *                    *        *                *                *
 *      log view      *        ***********************************
 *                    *
 *                    *
 *                    *
 **********************
 
 通常你可以让基类来为你的anchor view添加适配横竖屏时候的布局信息，那么你就可以重写此方法，返回YES，来告知基类为你提供的anchor view重写设置相对于父view（通常是
 viewController的顶级view）的布局约束，当然如果你自己已经处理了横竖屏这种情况，那么就可以不重写此方法（默认返回NO）
 
 @return 是否对anchor view进行布局，默认为YES。
 */

@interface LCViewController : UIViewController <LCSectionHeaderViewDelegate>

/**
 将新的log信息append到textView中显示出来

 @param log 新增的log信息
 */
- (void)log:(NSString *)log;


/**
 清理textView显示的log信息
 */
- (void)cleanLog;


/**
 子类重载用于提供log输出的新旧log的显示顺序，一般而言，正序输出是酱紫的：越新的log就在越下面
 old old old log
 old old log
 old log
 log
 而逆序输出则刚好想法：越新的log会显示在越上方
 log
 old log
 old old log
 old old old log
 @return YES 则表示逆序，NO表示要顺序展示，默认为YES
 */
- (BOOL)isShowLogReverse;


/**
 子类重载用于log输出是否自动填充分段标识“*********lihux.me*********”

 @return YES表示自动填充，NO表示不自动填充，默认是YES
 */
- (BOOL)isShowSegment;

/**
 便利方法，从storyboard中加载当前VC，要求的条件是当前VC的Identifier必须和类名完全一致才行
 
 @param storyboardName 从哪个storyboard加载这个VC
 @return 返回一个加载出来的VC，or nil if failed
 */
+ (instancetype)loadViewControllerFromStoryboard:(NSString *)storyboardName;

- (NSString *)leftItemText;

- (NSString *)rightItemText;

@end
