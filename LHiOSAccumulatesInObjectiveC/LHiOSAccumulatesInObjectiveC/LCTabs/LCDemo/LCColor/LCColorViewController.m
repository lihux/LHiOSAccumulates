//
//  LCColorViewController.m
//  LHiOSAccumulatesInObjectiveC
//
//  Created by lihui on 2017/7/6.
//  Copyright © 2017年 Lihux. All rights reserved.
//

#import "LCColorViewController.h"

#import "LCColorCollectionViewCell.h"

@interface LCColorViewController () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, assign) NSInteger colorCount;
@property (nonatomic, assign) NSInteger colorOffset;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, assign) BOOL isLoading;
@property (nonatomic, assign) BOOL isRandomOn;

@end

@implementation LCColorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.colorCount = 0x1000000;
    [self.collectionView reloadData];
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
}
#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.colorCount - self.colorOffset;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    LCColorCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([LCColorCollectionViewCell class]) forIndexPath:indexPath];
    cell.tag = self.isRandomOn;
    cell.colorIndex = indexPath.row + self.colorOffset;
    return cell;
}

- (IBAction)sliderValueChanged:(UISlider *)sender {
    self.colorOffset = (NSInteger)sender.value;
    self.infoLabel.text = [NSString stringWithFormat:@"色值偏移：%06lx", (long)self.colorOffset];
    [self.collectionView reloadData];
}

- (IBAction)switchBarValueChanged:(UISwitch *)sender {
    BOOL randomOn = !sender.on;
    if (self.isRandomOn != randomOn) {
        self.isRandomOn = randomOn;
        [self.collectionView reloadData];
    }
}

- (void)reloadData {
    if (!self.isLoading) {
        self.isLoading = YES;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.collectionView reloadData];
            self.isLoading = NO;
        });
    }
}

@end
