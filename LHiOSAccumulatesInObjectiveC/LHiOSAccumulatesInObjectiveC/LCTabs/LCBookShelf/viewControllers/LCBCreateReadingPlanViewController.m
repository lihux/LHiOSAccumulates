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
@property (weak, nonatomic) IBOutlet UILabel *readingStartPageCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalCountLabel;

@property (weak, nonatomic) IBOutlet UISlider *pageCountSlider;
@property (weak, nonatomic) IBOutlet UISlider *timeDurationSlider;
@property (weak, nonatomic) IBOutlet UISlider *readPagePerDaySlider;
@property (nonatomic, strong) NSCalendar *calendar;
@property (weak, nonatomic) IBOutlet UILabel *startTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *endTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *durationTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *averagePageLabel;
@property (weak, nonatomic) IBOutlet UILabel *maxDayLabel;
@property (weak, nonatomic) IBOutlet UILabel *maxAveragePageCountLabel;

@property (nonatomic, strong) NSDate *startDate; //计划开始时间
@property (nonatomic, strong) NSDate *endDate; //计划结束是假
@property (nonatomic, assign) NSInteger startReadingPage;//从第几页开始阅读
@property (nonatomic, assign) NSInteger durationDays;//计划持续时间
@property (nonatomic, assign) NSInteger averageReadingPageCount;

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
        self.title = [NSString stringWithFormat:@"阅读计划：%@", book.title];
        [self.bookImageView lc_setImageWithURLString:book.image];
        self.bookTitleLabel.text = book.title;
        self.bookPageCountLabel.text = [NSString stringWithFormat:@"页数：%zd", book.pages];
        self.totalCountLabel.text = [NSString stringWithFormat:@"%zd", book.pages];
        self.pageCountSlider.minimumValue = 0;
        self.pageCountSlider.maximumValue = book.pages;
        self.startDate = [NSDate date];
        self.endDate = [LCTimeHelper tomorrow];
        self.startReadingPage = 0;
    }
}

- (IBAction)pageCountSliderValueChanged:(UISlider *)sender {
    self.startReadingPage = (NSInteger)sender.value;
}

- (IBAction)readPagePerDaySliderValueChanged:(UISlider *)sender {
    self.averageReadingPageCount = (NSInteger)sender.value;
}

- (IBAction)timeDurationSliderValueChanged:(UISlider *)sender {
    
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
    plan.startPage = (int64_t)self.pageCountSlider.value;
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
- (NSCalendar *)calendar {
    if (_calendar) {
        return _calendar;
    }
    _calendar = [NSCalendar currentCalendar];
    return _calendar;
}

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
    self.readingStartPageCountLabel.text = [NSString stringWithFormat:@"计划起始页：%zd", startReadingPage];
    self.readPagePerDaySlider.maximumValue = self.book.pages - startReadingPage;
    NSInteger totoalReadingPages = self.book.pages - startReadingPage;
    self.maxDayLabel.text = [NSString stringWithFormat:@"%zd", totoalReadingPages];
    self.maxAveragePageCountLabel.text = [NSString stringWithFormat:@"%zd", totoalReadingPages];
}

- (void)setDurationDays:(NSInteger)durationDays {
    _durationDays = durationDays;
    self.durationTimeLabel.text = [NSString stringWithFormat:@"计划阅读持续天数: %zd", durationDays];
}

- (void)setAverageReadingPageCount:(NSInteger)averageReadingPageCount {
    _averageReadingPageCount = averageReadingPageCount;
    self.averagePageLabel.text = [NSString stringWithFormat:@"平均每天计划阅读页数：%zd", averageReadingPageCount];
}

@end
