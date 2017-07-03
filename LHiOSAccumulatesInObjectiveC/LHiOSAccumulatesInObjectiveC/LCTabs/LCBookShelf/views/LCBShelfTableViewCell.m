//
//  LCBShelfTableViewCell.m
//  LHiOSAccumulatesInObjectiveC
//
//  Created by 李辉 on 2017/6/22.
//  Copyright © 2017年 Lihux. All rights reserved.
//

#import "LCBShelfTableViewCell.h"

#import "LCLihuxHelper.h"
#import "LCBookShelf+CoreDataModel.h"
#import "UIImageView+LCURL.h"

@interface LCBShelfTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *bookImageView;
@property (weak, nonatomic) IBOutlet UILabel *bookTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;
@property (weak, nonatomic) IBOutlet UILabel *publisherLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIView *bottomLineView;

@property (weak, nonatomic) IBOutlet UIView *progressView;
@property (weak, nonatomic) IBOutlet UIView *buttonContainerView;
@property (weak, nonatomic) IBOutlet UIButton *planButton;
@property (weak, nonatomic) IBOutlet UIView *progressBackgroundView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *progressViewTailConstraints;

@end

@implementation LCBShelfTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [LCLihuxHelper makeLihuxStyleOfView:self];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

-(void)setBook:(LCBook *)book {
    _book = book;
    self.bookTitleLabel.text = book.title;
    self.bottomLineView.backgroundColor = LihuxStyleColor;
    self.authorLabel.text = [(LCBookAuthor *)[book.authors anyObject] name];
    self.publisherLabel.text = book.publisher;
    self.priceLabel.text = book.price;
    [self.bookImageView lc_setImageWithURLString:book.image];
    [self configPlanInfo:book.readingPlan];
}

- (void)configPlanInfo:(LCBookReadingPlan *)plan {
    BOOL hasPlan = plan ? YES : NO;
    self.progressView.hidden = !hasPlan;
    self.progressBackgroundView.hidden = !hasPlan;
    self.progressViewTailConstraints.constant = self.progressBackgroundView.bounds.size.width - 0;
    NSString *info = hasPlan ? @"在阅读中" : @"开始阅读";
    if (plan.readingRecords.count > 0) {
        //TODO:需要调整
    }
    [self.planButton setTitle:info forState:UIControlStateNormal];
}

- (IBAction)didTapOnPlanButton:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(planButtonDidTappedOnCell:)]) {
        [self.delegate planButtonDidTappedOnCell:self];
    }
}


@end
