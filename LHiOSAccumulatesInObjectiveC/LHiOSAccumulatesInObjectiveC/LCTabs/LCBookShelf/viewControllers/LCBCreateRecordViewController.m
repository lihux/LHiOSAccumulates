//
//  LCBCreateRecordViewController.m
//  LHiOSAccumulatesInObjectiveC
//
//  Created by lihui on 2017/7/2.
//  Copyright © 2017年 Lihux. All rights reserved.
//

#import "LCBCreateRecordViewController.h"

#import "LCBookShelf+CoreDataModel.h"
#import "UIView+LHAutoLayout.h"

@interface LCBCreateRecordViewController ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *progressViewWidthConstraint;
@property (weak, nonatomic) IBOutlet UILabel *progressInfoLabel;
@property (nonatomic, strong) LCBookReadingPlan *plan;
@property (nonatomic, strong) UIView *inputMaskView;
@property (weak, nonatomic) IBOutlet UITextField *finishPageTextField;

@end

@implementation LCBCreateRecordViewController

+ (instancetype)createRecordViewControllerForReadingPlan:(LCBookReadingPlan *)plan {
    LCBCreateRecordViewController *vc = [LCBCreateRecordViewController loadViewControllerFromStoryboard:@"LCBookShelf"];
    vc.plan = plan;
    return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"每天进步一点点";
    [self customUI];
}

- (void)customUI {
    [self.view addSubviewUsingDefaultLayoutConstraints:self.inputMaskView];
}

- (void)didTapOnInputMaskView {
    [self.finishPageTextField resignFirstResponder];
}

- (IBAction)didTapOnPageTextField:(id)sender {
    self.inputMaskView.hidden = NO;
}

#pragma mark - lazy load
- (UIView *)inputMaskView {
    if (_inputMaskView) {
        return _inputMaskView;
    }
    _inputMaskView = [[UIView alloc] init];
    _inputMaskView.backgroundColor = [UIColor clearColor];
    _inputMaskView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapOnInputMaskView)];
    [_inputMaskView addGestureRecognizer:tap];
    _inputMaskView.hidden = YES;
    return _inputMaskView;
}

@end
