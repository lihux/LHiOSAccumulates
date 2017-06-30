//
//  LCDatePickerView.m
//  LHiOSAccumulatesInObjectiveC
//
//  Created by 李辉 on 2017/6/28.
//  Copyright © 2017年 Lihux. All rights reserved.
//

#import "LCDatePickerView.h"

#import "UIView+LHAutoLayout.h"
#import "UIColor+helper.h"
#import "LCLihuxHelper.h"
#import "UILabel+lihuxStyle.h"

@interface LCDatePickerView ()

@property (nonatomic, copy) LCDatePickerCompletionBlock completionBlock;
@property (nonatomic, strong) UIDatePicker *datePicker;
@property (nonatomic, strong) NSLayoutConstraint *datePickerBottomConstraint;
@property (nonatomic, assign) CGFloat datePickerViewHeight;
@property (nonatomic, strong) UIVisualEffectView *blurView;
@property (nonatomic, strong) UILabel *titleLabel;
@end

@implementation LCDatePickerView

+ (void)showPickerViewWithTitle:(NSString *)title completionBlock:(LCDatePickerCompletionBlock) completionBlock {
    LCDatePickerView *pickerView = [[LCDatePickerView alloc] init];
    pickerView.completionBlock = completionBlock;
    pickerView.titleLabel.text = title;
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubviewUsingDefaultLayoutConstraints:pickerView];
    pickerView.datePickerBottomConstraint.constant = 0;
    [UIView animateWithDuration:0.35 animations:^{
        pickerView.blurView.alpha = 0.8;
        [pickerView setNeedsLayout];
    }];
}

- (instancetype)init {
    if (self = [super init]) {
        [self customUI];
    }
    return self;
}

- (void)customUI {
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleRegular];
    UIVisualEffectView *blurView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    blurView.alpha = 0;
    [self addSubviewUsingDefaultLayoutConstraints:blurView];
    self.blurView = blurView;
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelSelectDate)];
    [self addGestureRecognizer:tap];
    
    self.datePickerViewHeight = 234;
    
    UIView *containerView= [[UIView alloc] init];
    [LCLihuxHelper makeLihuxStyleOfView:containerView];
    containerView.backgroundColor = LihuxContentBackgroundColor;
    [self addSubview:containerView withLayoutInfo:LHLayoutInfoMake(LHLayoutNone, 0, -self.datePickerViewHeight, 0, LHLayoutNone, self.datePickerViewHeight)];
    
    [containerView addSubview:self.datePicker withLayoutInfo:LHLayoutInfoMake(LHLayoutNone, 0, 0, 0, LHLayoutNone, self.datePickerViewHeight - 44)];
    UILabel *titleLabel = [UILabel lihuxStyleLabelWithTag:17];
    self.titleLabel = titleLabel;
    [containerView addSubview:titleLabel withLayoutInfo:LHLayoutInfoMake(0, 0, LHLayoutNone, 0, LHLayoutNone, 44)];
    
    UIButton *cancelButton = [[UIButton alloc] init];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    cancelButton.tag = 14;
    [cancelButton addTarget:self action:@selector(cancelSelectDate) forControlEvents:UIControlEventTouchUpInside];
    [containerView addSubview:cancelButton withLayoutInfo:LHLayoutInfoMake(0, 0, LHLayoutNone, LHLayoutNone, 64, 44)];
    
    UIButton *doneButton = [[UIButton alloc] init];
    [doneButton setTitle:@"确定" forState:UIControlStateNormal];
    doneButton.tag = 14;
    [doneButton addTarget:self action:@selector(doneSelectDate) forControlEvents:UIControlEventTouchUpInside];
    [containerView addSubview:doneButton withLayoutInfo:LHLayoutInfoMake(0, LHLayoutNone, LHLayoutNone, 0, 64, 44)];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.tag = kLCNonLihuxStyleViewTag;
    lineView.backgroundColor = LihuxStyleColor;
    [containerView addSubview:lineView withLayoutInfo:LHLayoutInfoMake(44, 0, LHLayoutNone, 0, LHLayoutNone, 1)];
    
    for (NSLayoutConstraint *constraint in self.constraints) {
        if (constraint.constant == -self.datePickerViewHeight) {
            self.datePickerBottomConstraint = constraint;
            break;
        }
    }
}

#pragma mark - actions
- (void)cancelSelectDate {
    if (self.completionBlock) {
        self.completionBlock(nil);
        self.completionBlock = nil;
    }
    [self dismiss];
}

- (void)doneSelectDate {
    if (self.completionBlock) {
        NSDate *date = self.datePicker.date;
        self.completionBlock(date);
        self.completionBlock = nil;
    }
    [self dismiss];
}

- (void)dismiss {
    self.datePickerBottomConstraint.constant = -self.datePickerViewHeight;
    [UIView animateWithDuration:0.35 animations:^{
        [self setNeedsLayout];
        self.blurView.alpha = 0;
        self.backgroundColor = [UIColor colorWithHex:0xFFFFFF alpha:0];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark - lazy load
- (UIDatePicker *)datePicker {
    if (_datePicker) {
        return _datePicker;
    }
    _datePicker = [[UIDatePicker alloc] init];
    _datePicker.datePickerMode = UIDatePickerModeDate;
    _datePicker.tag = kLCNonLihuxStyleViewTag;
    //tricky to do this: https://stackoverflow.com/questions/20875054/change-uidatepicker-font-color
    [_datePicker setValue:[UIColor whiteColor] forKey:@"textColor"];
    if ([_datePicker respondsToSelector:sel_registerName("setHighlightsToday:")]) {
    }
    _datePicker.backgroundColor = LihuxContentBackgroundColor;
    return _datePicker;
}

@end
