//
//  LCC100BeautifulColorTableViewCell.m
//  LHiOSAccumulatesInObjectiveC
//
//  Created by lihui on 2017/7/7.
//  Copyright © 2017年 Lihux. All rights reserved.
//

#import "LCC100BeautifulColorTableViewCell.h"

#import "LCLihuxHelper.h"
#import "LCColorCombinationManger.h"

@interface LCC100BeautifulColorTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *colorImageView;

@end

@implementation LCC100BeautifulColorTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [LCLihuxHelper makeLihuxStyleOfView:self];
}
- (IBAction)didTapOnButton:(UIButton *)sender {
    NSInteger namedColorIndex = self.photoIndex * 4 + sender.tag;
    NSArray *colors = [LCColorCombinationManger sharedInstance].namedColors;
    if (colors.count > namedColorIndex) {
        [self.delegate colorTableViewCell:self didChoseNamedColor:colors[namedColorIndex]];
    }
}

-(void)setPhotoIndex:(NSInteger)photoIndex {
    _photoIndex = photoIndex;
    self.colorImageView.image = [UIImage imageNamed:[self imageName]];
}

- (NSString *)imageName {
    return [NSString stringWithFormat:@"100ColorCombinations%zd", self.photoIndex + 1];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
