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
    self.authorLabel.text = [(LCBookAuthor *)[book.authors anyObject] name];
    self.publisherLabel.text = book.publisher;
    self.priceLabel.text = book.price;
    [self.bookImageView lc_setImageWithURLString:book.image];
}

@end
