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
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

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
    return self.colorCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    LCColorCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([LCColorCollectionViewCell class]) forIndexPath:indexPath];
    cell.colorIndex = indexPath.row;
    return cell;
}

@end
