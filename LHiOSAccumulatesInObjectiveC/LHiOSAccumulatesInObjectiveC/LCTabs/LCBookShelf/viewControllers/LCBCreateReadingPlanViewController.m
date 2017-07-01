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
#import "LCDatePickerView.h"
#import "LCTimeHelper.h"

@interface LCBCreateReadingPlanViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *bookImageView;
@property (weak, nonatomic) IBOutlet UILabel *bookTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *bookPageCountLabel;
@property (nonatomic, strong) LCBook *book;

@property (weak, nonatomic) IBOutlet UILabel *readingStartPageLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalPageLabel;
@property (weak, nonatomic) IBOutlet UISlider *readingStartPageSlider;

@property (weak, nonatomic) IBOutlet UILabel *startTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *endTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *durationTimeLabel;

@property (weak, nonatomic) IBOutlet UILabel *maxDayLabel;
@property (weak, nonatomic) IBOutlet UISlider *durationTimeSlider;

@property (weak, nonatomic) IBOutlet UILabel *maxAveragePageCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *averageReadingPageLabel;
@property (weak, nonatomic) IBOutlet UISlider *readPagePerDaySlider;

@property (nonatomic, strong) NSDate *startDate; //计划开始时间
@property (nonatomic, strong) NSDate *endDate; //计划结束是假
@property (nonatomic, assign) NSInteger startReadingPage;//从第几页开始阅读
@property (nonatomic, assign) NSInteger totalPage;

@end

@implementation LCBCreateReadingPlanViewController

////阅读起始页数：0
//- (void)updateReadingStartPageLabel:(NSInteger)page {
//    self.readingStartPageLabel.text = [NSString stringWithFormat:@"计划阅读起始页：%zd", page];
//}

////2017-07-01
//- (void)updateStartTimeLabel {
//    self.startTimeLabel.text = [LCTimeHelper yyMMddFromDate:self.startDate];
//}
//
////2017-07-02
//- (void)updateEndTimeLabel {
//    self.endTimeLabel.text = [LCTimeHelper yyMMddFromDate:self.endDate];
//}
//
//计划持续天数：22
- (void)updateDuratingTimeLabel {
    self.durationTimeLabel.text = [NSString stringWithFormat:@"计划持续天数：%zd", [self timeDuration]];
}

//平均每天阅读页数：18
- (void)updateAverageReadingPageLabel {
    NSInteger needReadPage = self.totalPage - self.startReadingPage;
    NSInteger average = (NSInteger)(needReadPage / [self timeDuration]);
    self.averageReadingPageLabel.text = [NSString stringWithFormat:@"平均每天阅读页数：%zd", average];
}

//辅助方法，计算计划时间长度
- (NSInteger)timeDuration {
    return [LCTimeHelper daysDuratinFromStartDate:self.startDate endDate:self.endDate];
}

//辅助方法，计算本次计划要阅读的书页数
- (NSInteger)pageDuration {
    return self.book.pages - self.startReadingPage;
}

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
        self.title = [NSString stringWithFormat:@"阅读计划：%@", book.title];
        [self.bookImageView lc_setImageWithURLString:book.image];
        self.bookTitleLabel.text = book.title;
        self.bookPageCountLabel.text = [NSString stringWithFormat:@"页数：%zd", book.pages];
        self.totalPage = book.pages;
        self.totalPageLabel.text = [NSString stringWithFormat:@"%zd", book.pages];
        self.startDate = [NSDate date];
        self.endDate = [LCTimeHelper tomorrow];
        self.readingStartPageSlider.maximumValue = self.book.pages;
        self.startReadingPage = 0;
    }
}

- (IBAction)readingStartPageSliderValueChanged:(UISlider *)sender {
    self.startReadingPage = (NSInteger)sender.value;
}

- (IBAction)durationTimeSliderValueChanged:(UISlider *)sender {
    NSInteger days = (NSInteger)sender.value;
    self.endDate = [LCTimeHelper dateFromOriginDate:self.startDate daysOffset:days];
    self.readPagePerDaySlider.value = [self pageDuration] / days;
    [self updateDuratingTimeLabel];
    [self updateAverageReadingPageLabel];
    NSLog(@"总阅读持续天数：%zd", days);
}

- (IBAction)readPagePerDaySliderValueChanged:(UISlider *)sender {
    NSInteger pages = (NSInteger)sender.value;
    NSInteger days = [self pageDuration] / pages;
    self.endDate = [LCTimeHelper dateFromOriginDate:self.startDate daysOffset:days];
    [self updateDuratingTimeLabel];
    [self updateAverageReadingPageLabel];
    NSLog(@"平均每天阅读页数：%zd", pages);
}

- (IBAction)selectStartTimeAction:(id)sender {
    [LCDatePickerView showPickerViewWithTitle:@"选择开始时间" completionBlock:^(NSDate *selectedDate) {
        self.startDate = selectedDate;
    }];
}

- (IBAction)selectEndTimeAction:(id)sender {
    [LCDatePickerView showPickerViewWithTitle:@"选择结束时间" completionBlock:^(NSDate *selectedDate) {
        self.endDate = selectedDate;
    }];
}

-(NSString *)leftItemText {
    return @"取消";
}

-(NSString *)rightItemText {
    return @"保存";
}

- (void)saveReadingPlan {
    LCBookReadingPlan *plan = [[LCBookReadingPlan alloc] initWithContext:self.book.managedObjectContext];
    plan.book = self.book;
    plan.startTime = [LCTimeHelper timeIntervalFromDate:self.startDate];
    plan.endTime = [LCTimeHelper timeIntervalFromDate:self.endDate];
    plan.startPage = (int64_t)self.readingStartPageSlider.value;
    NSError *error;
    [plan.managedObjectContext save:&error];
    if (error) {
        NSLog(@"保存图书阅读计划信息失败");
    }
}

#pragma mark -
#pragma mark - LCSectionHeaderViewDelegate
- (void)sectionHeaderView:(LCSectionHeaderView *)sectionHeaderView tappedOnLeftButton:(UIButton *)leftButton {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)sectionHeaderView:(LCSectionHeaderView *)sectionHeaderView tappedOnRightButton:(UIButton *)rightButton {
    [self saveReadingPlan];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - lazy loads
- (void)setStartDate:(NSDate *)startDate {
    _startDate = startDate;
    self.startTimeLabel.text = [LCTimeHelper yyMMddFromDate:startDate];
}

- (void)setEndDate:(NSDate *)endDate {
    _endDate = endDate;
    self.endTimeLabel.text = [LCTimeHelper yyMMddFromDate:endDate];
}

- (void)setStartReadingPage:(NSInteger)startReadingPage {
    _startReadingPage = startReadingPage;
    self.readingStartPageLabel.text = [NSString stringWithFormat:@"计划阅读起始页：%zd", startReadingPage];
    NSInteger pageDuration = [self pageDuration];
    self.readPagePerDaySlider.maximumValue = pageDuration;
    self.durationTimeSlider.maximumValue = pageDuration;
    self.maxDayLabel.text = [NSString stringWithFormat:@"%zd", pageDuration];
    self.maxAveragePageCountLabel.text = [NSString stringWithFormat:@"%zd", pageDuration];
    if ([self timeDuration] > pageDuration) {
        self.endDate = [LCTimeHelper dateFromOriginDate:self.startDate daysOffset:pageDuration];
        self.durationTimeSlider.value = pageDuration;
        self.readPagePerDaySlider.value = 1;
    }
}

@end
