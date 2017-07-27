//
//  LCSDefaultOpenPageSettingViewController.m
//  LHiOSAccumulatesInObjectiveC
//
//  Created by 李辉 on 2017/6/26.
//  Copyright © 2017年 Lihux. All rights reserved.
//

#import "LCSDefaultOpenPageSettingViewController.h"

#import "LCConstantDefines.h"
#import "UIView+LHAutoLayout.h"
#import "LCLihuxHelper.h"
#import "LCSDefaultOpenSaveManager.h"

@interface LCSDefaultOpenPageSettingViewController ()

@property (weak, nonatomic) IBOutlet UISwitch *floatRecordButtonSwith;
@property (weak, nonatomic) IBOutlet UISegmentedControl *tabBarSelectSegmentedControl;

@end

@implementation LCSDefaultOpenPageSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self customUI];
}

- (void)customUI {
    NSNumber *selectedTab = [[NSUserDefaults standardUserDefaults] objectForKey:kLCSSettingDefaultSelectTabKey];
    if (selectedTab) {
        NSInteger temp = selectedTab.integerValue;
        if (temp >= 0 && temp < 4) {
            self.tabBarSelectSegmentedControl.selectedSegmentIndex = temp;
        }
    }
}

- (IBAction)tabBarSelectValueChanged:(UISegmentedControl *)sender {
    [[NSUserDefaults standardUserDefaults] setObject:@(sender.selectedSegmentIndex) forKey:kLCSSettingDefaultSelectTabKey];
}

- (IBAction)floatRecordButtonSwithValueChanged:(UISwitch *)sender {
    if (sender.on) {
    }
}

- (IBAction)showUnfinishedButtonSwithValueChanged:(UISwitch *)sender {
    [[NSUserDefaults standardUserDefaults] setObject:@(sender.on) forKey:kLCSSettingDefaultSelectTabKey];
}

@end
