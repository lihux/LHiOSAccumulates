//
//  DetailViewController.h
//  LHiOSAccumulatesInObjectiveC
//
//  Created by lihui on 16/1/7.
//  Copyright © 2016年 Lihux. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;
@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@end

