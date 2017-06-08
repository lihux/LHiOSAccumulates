//
//  UIView+LHAutoLayout.m
//  jiaxiaozhijia-ios
//
//  Created by 李辉 on 2017/5/5.
//
//

#import "UIView+LHAutoLayout.h"

@implementation UIView (LHAutoLayout)

- (void)addSubviewUsingDeaultLayoutConstraints:(UIView *)view {
    if (!view) {
        return;
    }
    [self addSubview:view];
    view.translatesAutoresizingMaskIntoConstraints = NO;
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[view]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(view)]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[view]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(view)]];
}

- (void)addSubview:(UIView *)view withLayoutInfo:(LHLayoutInfo)info {
    [self addSubview:view];
    view.translatesAutoresizingMaskIntoConstraints = NO;
    [self layoutView:view constant:info.top name:NSLayoutAttributeTop];
    [self layoutView:view constant:info.left name:NSLayoutAttributeLeft];
    [self layoutView:view constant:info.bottom name:NSLayoutAttributeBottom];
    [self layoutView:view constant:info.right name:NSLayoutAttributeRight];
    [self layoutView:view constant:info.width name:NSLayoutAttributeWidth];
    [self layoutView:view constant:info.height name:NSLayoutAttributeHeight];
}

- (void)layoutView:(UIView *)view constant:(CGFloat)constant name:(NSLayoutAttribute)attribute {
    if (constant != LHLayoutNone) {
        NSString *vfl = nil;
        NSDictionary *metrics = @{@"constant": @(constant)};
        switch (attribute) {
            case NSLayoutAttributeTop:
                vfl = @"V:|-constant-[view]";
                break;
            case NSLayoutAttributeLeft:
                vfl = @"H:|-constant-[view]";
                break;
            case NSLayoutAttributeBottom:
                vfl = @"V:[view]-constant-|";
                break;
            case NSLayoutAttributeRight:
                vfl = @"H:[view]-constant-|";
                break;
            case NSLayoutAttributeWidth:
                vfl = @"H:[view(constant)]";
                break;
            case NSLayoutAttributeHeight:
                vfl = @"V:[view(constant)]";
                break;
                
            default:
                break;
        }
        if (vfl) {
            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:vfl options:0 metrics:metrics views:NSDictionaryOfVariableBindings(view)]];
        }
    }
}

@end
