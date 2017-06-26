//
//  LCSDefaultOpenPageSettingViewController.m
//  LHiOSAccumulatesInObjectiveC
//
//  Created by 李辉 on 2017/6/26.
//  Copyright © 2017年 Lihux. All rights reserved.
//

#import "LCSDefaultOpenPageSettingViewController.h"

#import "LCConstantDefines.h"

@interface LCSDefaultOpenPageSettingViewController ()

@property (weak, nonatomic) IBOutlet UISegmentedControl *tabBarSelectSegmentedControl;

@end

@implementation LCSDefaultOpenPageSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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

@end
