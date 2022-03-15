//
//  BaseCollectionViewCell.h
//  iShop
//
//  Created by It's my laptop on 2018/8/9.
//  Copyright © 2018年 帝辰科技. All rights reserved.
// 基类CollectionViewCell

#import <UIKit/UIKit.h>

@interface BaseCollectionViewCell : UICollectionViewCell

+ (instancetype)cellWithCollectionView:(UICollectionView *)collectionView withIdentifier:(NSString *)identifier withIndexPath:(NSIndexPath *)indexPath;
+ (instancetype)cellWithCollectionView:(UICollectionView *)collectionView withIndexPath:(NSIndexPath *)indexPath;
+ (instancetype)cellWithNibCollectionView:(UICollectionView *)collectionView withIndexPath:(NSIndexPath *)indexPath;

- (void)setupCell;
- (void)setupSubViews;
- (void)setViewWithModel:(id)model;

@end
