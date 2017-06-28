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

@end

@implementation LCBCreateReadingPlanViewController

+ (instancetype)createReadingPlanViewControllerForBook:(LCBook *)book {
    LCBCreateReadingPlanViewController *vc = [LCBCreateReadingPlanViewController loadViewControllerFromStoryboard:@"LCBookShelf"];
    vc.book = book;
    return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)configUI {
    if (self.book) {
        LCBook *book = self.book;
        [self.bookImageView lc_setImageWithURLString:book.image];
        self.bookTitleLabel.text = book.title;
        self.bookPageCountLabel.text = [NSString stringWithFormat:@"页数：%zd", book.pages];
    }
}

@end
