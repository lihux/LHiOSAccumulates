//
//  LCViewController.h
//  LHiOSAccumulatesInObjectiveC
//
//  Created by lihui on 2017/4/26.
//  Copyright © 2017年 Lihux. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LCViewController : UIViewController


/**
 让码农变得更懒散的便利方法：
 让页面保持和APP统一的风格，具体而言就是：对parentView（但不包括parentView）的所有subViews（递归到所有叶节点），设置其背景色透明，（如果控件含有文字）设置字体颜色为白色

 NOTICE:如果subView中有你不想被修改为默认风格的view，请将其tag设置为小于0的数值（比如-1），这样这个view及其所有的子view都不会被修改背景色和字体颜色
 @param parentView 需要设置lihuxStyle的子view的父view
 */
- (void)makeLihuxStyleOfSubviewsFromParent:(UIView *)parentView;


/**
 如果子类想添加一个通用的显示log输出的textView，需要重写此方法，返回一个作为锚点的view供textView布局使用。
 理想状态下，一个详情页，UI展示上可以分为工作区和log去，前者，是根据当前的技术要点，添加的定制化的、非通用的测试组件；后者
 则是通用的可以用作输出log和其他提示信息的窗口view。所以，这里建议：最好将工作区内的所有控件提供一个统一的containerView。

 同时，因为我们是支持横竖屏切换的，所以工作区的containerView最好还需提供定制化的横竖屏布局方案

 @return 返回一个座位布局通用log输出的锚点view，如果不想显示log输出的view，子类就不需重置此方法
 */
- (UIView *)logAnchorView;

- (void)log:(NSString *)log;

@end
