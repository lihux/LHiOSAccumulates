//
//  LCViewController.h
//  LHiOSAccumulatesInObjectiveC
//
//  Created by lihui on 2017/4/26.
//  Copyright © 2017年 Lihux. All rights reserved.
//

#import <UIKit/UIKit.h>

static const NSInteger kLCSpecialViewTag = -9999;

@interface LCViewController : UIViewController

/**
 让码农变得更懒散的便利方法：
 让页面保持和APP统一的风格，具体而言就是：对view及其所有的subViews（递归到所有叶节点），设置其背景色透明，（如果控件含有文字）设置字体颜色为白色
 
 NOTICE:如果view(及其subViews)中有你不想被修改为默认风格的view，请将其tag设置为`kLCSpecialViewTag`，这样这个view及其所有的子view都不会被修改背景色和字体颜色
 @param view 需要设置lihuxStyle的子view的父view
 */
- (void)makeLihuxStyleOfView:(UIView *)view;

/**
 如果子类想添加一个通用的显示log输出的textView，需要重写此方法，返回一个作为锚点的view供textView布局使用。
 理想状态下，一个详情页，UI展示上可以分为工作区和log去，前者，是根据当前的技术要点，添加的定制化的、非通用的测试组件；后者
 则是通用的可以用作输出log和其他提示信息的窗口view。所以，这里建议：最好将工作区内的所有控件提供一个统一的containerView。

 同时，因为我们是支持横竖屏切换的，所以工作区的containerView最好还需提供定制化的横竖屏布局方案

 @return 返回一个座位布局通用log输出的锚点view，如果不想显示log输出的view，子类就不需重置此方法
 */
- (UIView *)logAnchorView;


/**
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
- (BOOL)needReLayoutAnchorView;


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
 @return YES 则表示逆序，NO表示要顺序展示，默认为NO
 */
- (BOOL)isShowLogReverse;


/**
 便利方法，从storyboard中加载当前VC，要求的条件是当前VC的Identifier必须和类名完全一致才行
 
 @param storyboardName 从哪个storyboard加载这个VC
 @return 返回一个加载出来的VC，or nil if failed
 */
+ (instancetype)loadViewControllerFromStoryboard:(NSString *)storyboardName;

@end
