//
//  UIView+LHAutoLayout.m
//  jiaxiaozhijia-ios
//
//  Created by 李辉 on 2017/5/5.
//
//

#import "UIView+LHAutoLayout.h"

@implementation UIView (LHAutoLayout)

- (void)insertSubviewUsingDefaultLayoutConstraints:(UIView *)view atIndex:(NSInteger)index {
    [self insertSubview:view atIndex:index];
    [self addDefaultConstraintsForSubView:view];
}

- (void)insertSubviewUsingDefaultLayoutConstraints:(UIView *)view aboveSubview:(UIView *)siblingSubview {
    [self insertSubview:view aboveSubview:siblingSubview];
    [self addDefaultConstraintsForSubView:view];
}

- (void)insertSubviewUsingDefaultLayoutConstraints:(UIView *)view belowSubview:(UIView *)siblingSubview {
    [self insertSubview:view belowSubview:siblingSubview];
    [self addDefaultConstraintsForSubView:view];
}

- (void)addSubviewUsingDefaultLayoutConstraints:(UIView *)view {
    [self addSubview:view];
    [self addDefaultConstraintsForSubView:view];
}

- (void)addDefaultConstraintsForSubView:(UIView *)view {
    view.translatesAutoresizingMaskIntoConstraints = NO;
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[view]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(view)]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[view]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(view)]];
}

- (void)addSubview:(UIView *)view withLayoutInfo:(LHLayoutInfo)info {
    if (!view) {
        return;
    }
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

- (NSLayoutConstraint *)lh_widthConstraint {
    for (NSLayoutConstraint *constraint in self.constraints) {
        if (constraint.firstItem == self && constraint.firstAttribute == NSLayoutAttributeWidth) {
            return constraint;
        }
    }
    return nil;
}

- (NSLayoutConstraint *)lh_heightConstraint {
    for (NSLayoutConstraint *constraint in self.constraints) {
        if (constraint.firstItem == self && constraint.firstAttribute == NSLayoutAttributeHeight) {
            return constraint;
        }
    }
    return nil;
}

@end
