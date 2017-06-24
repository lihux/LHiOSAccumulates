//
//  LCBookViewController.m
//  LHiOSAccumulatesInObjectiveC
//
//  Created by lihui on 2017/6/24.
//  Copyright © 2017年 Lihux. All rights reserved.
//

#import "LCBookViewController.h"

#import "LCBookShelf+CoreDataModel.h"
#import "UIImageView+LCURL.h"

@interface LCBookViewController ()

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;
@property (weak, nonatomic) IBOutlet UILabel *publisherLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *introductionLabel;
@property (weak, nonatomic) IBOutlet UIImageView *bookImageView;

@end

@implementation LCBookViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self updateUI];
}

- (void)updateUI {
    LCBook *book = self.book;
    if (book) {
        self.title = book.title;
        self.titleLabel.text = book.title;
        self.authorLabel.text = [[book.authors anyObject] name];
        self.publisherLabel.text = book.publisher;
        self.priceLabel.text = book.price;
        self.introductionLabel.text = book.catalog;
        [self.bookImageView lc_setImageWithURLString:book.detailImage.large];
    }
}

- (void)setBook:(LCBook *)book {
    _book = book;
    self.title = book.title;
}

- (void)sectionHeaderView:(LCSectionHeaderView *)sectionHeaderView tappedOnLeftButton:(UIButton *)leftButton {
    [super sectionHeaderView:sectionHeaderView tappedOnLeftButton:leftButton];
}

#pragma mark - 子类继承设置
- (UIView *)lihuxStyleView {
    return self.containerView;
}

@end
