//
//  UIView+LHAutoLayout.h
//  jiaxiaozhijia-ios
//
//  Created by 李辉 on 2017/5/5.
//
//

#import <UIKit/UIKit.h>

typedef struct {
    CGFloat top;
    CGFloat left;
    CGFloat bottom;
    CGFloat right;
    CGFloat width;
    CGFloat height;
} LHLayoutInfo;

UIKIT_STATIC_INLINE  LHLayoutInfo LHLayoutInfoMake(CGFloat top, CGFloat left, CGFloat bottom, CGFloat right, CGFloat width, CGFloat height) {
    LHLayoutInfo info = {top, left, bottom, right, width, height};
    return info;
}

static const CGFloat LHLayoutNone = CGFLOAT_MAX;

@interface UIView (LHAutoLayout)

/**
 add a subview using layout constraints: @"H:|-0-[_tableView]-0-|" @"V:|-0-[_tableView]-0-|"
 
 @param view subview that will be added using default constraints:@"H:|-0-[_tableView]-0-|" @"V:|-0-[_tableView]-0-|"
 */
- (void)addSubviewUsingDefaultLayoutConstraints:(nonnull UIView *)view;


/**
 高效的添加一个view作为subView，同时设置其相对于父view的布局信息,布局基于VFL语言：http://commandshift.co.uk/blog/2013/01/31/visual-format-language-for-autolayout/
 目前仅支持(top, left, bottom, right, width, height)共6个维度的布局添加布局，这基本上覆盖了80%的业务需求，如需更复杂的布局，请直接添加
 
 @param view 需要添加的subView
 @param info 布局信息，根据需要可以提供上、左、下、右、宽、高六种布局信息，如果不需要添加的约束，info相应的字段可以用`LHLayoutNone`设置
 */
- (void)addSubview:(nonnull UIView *)view withLayoutInfo:(LHLayoutInfo)info;


/**
 便利方法，如果对一个View添加了定宽的约束，则尝试找到这个约束并予以返回
 
 @return 定宽的约束，不存在则返回nil
 */
- (nullable NSLayoutConstraint *)lh_widthConstraint;

/**
 便利方法，如果对一个View添加了定高的约束，则尝试找到这个约束并予以返回
 
 @return 定高的约束，不存在则返回nil
 */
- (nullable NSLayoutConstraint *)lh_heightConstraint;

@end
