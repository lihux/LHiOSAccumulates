//
//  LCBCreateReadingPlanViewController.m
//  LHiOSAccumulatesInObjectiveC
//
//  Created by 李辉 on 2017/6/27.
//  Copyright © 2017年 Lihux. All rights reserved.
//

#import "LCBCreateReadingPlanViewController.h"

#import "LCBookShelf+CoreDataModel.h"
#import "UIImageView+LCURL.h"

@interface LCBCreateReadingPlanViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *bookImageView;
@property (weak, nonatomic) IBOutlet UILabel *bookTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *bookPageCountLabel;
@property (nonatomic, strong) LCBook *book;
@property (weak, nonatomic) IBOutlet UILabel *readingStartPageCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalCountLabel;

@property (weak, nonatomic) IBOutlet UISlider *pageCountSlider;
@property (weak, nonatomic) IBOutlet UISlider *timeDurationSlider;
@property (weak, nonatomic) IBOutlet UISlider *readPagePerDaySlider;

@end

@implementation LCBCreateReadingPlanViewController

+ (instancetype)createReadingPlanViewControllerForBook:(LCBook *)book {
    LCBCreateReadingPlanViewController *vc = [LCBCreateReadingPlanViewController loadViewControllerFromStoryboard:@"LCBookShelf"];
    vc.book = book;
    return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
}

- (void)configUI {
    if (self.book) {
        LCBook *book = self.book;
        self.book.title = [NSString stringWithFormat:@"阅读计划：%@", book.title];
        [self.bookImageView lc_setImageWithURLString:book.image];
        self.bookTitleLabel.text = book.title;
        self.bookPageCountLabel.text = [NSString stringWithFormat:@"页数：%zd", book.pages];
        self.readingStartPageCountLabel.text = [NSString stringWithFormat:@"从第%zd页开始阅读", book.pages];
        self.pageCountSlider.minimumValue = 0;
        self.pageCountSlider.maximumValue = book.pages;
    }
}

- (IBAction)pageCountSliderValueChanged:(UISlider *)sender {
    NSInteger startPage = (NSInteger)sender.value;
    self.readingStartPageCountLabel.text = [NSString stringWithFormat:@"从第%zd页开始阅读", startPage];
}

- (IBAction)readPagePerDaySliderValueChanged:(UISlider *)sender {
}

- (IBAction)timeDurationSliderValueChanged:(UISlider *)sender {
}

- (IBAction)selectStartTimeAction:(id)sender {
}

- (IBAction)selectEndTimeAction:(id)sender {
}

@end
