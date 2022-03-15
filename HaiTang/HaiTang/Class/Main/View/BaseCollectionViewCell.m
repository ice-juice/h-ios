//
//  BaseCollectionViewCell.m
//  iShop
//
//  Created by It's my laptop on 2018/8/9.
//  Copyright © 2018年 帝辰科技. All rights reserved.
//

#import "BaseCollectionViewCell.h"

@implementation BaseCollectionViewCell

+ (instancetype)cellWithCollectionView:(UICollectionView *)collectionView withIdentifier:(NSString *)identifier withIndexPath:(NSIndexPath *)indexPath {
    id cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    if (!cell) {
        cell = [[self alloc] init];
        [cell setupCell];
        [cell setupSubViews];
    }
    return cell;
}

+ (instancetype)cellWithCollectionView:(UICollectionView *)collectionView withIndexPath:(NSIndexPath *)indexPath {
    NSString *reuseId = NSStringFromClass([self class]);
    id cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseId forIndexPath:indexPath];
    if (!cell) {
        cell = [[self alloc] init];
        [cell setupCell];
        [cell setupSubViews];
    }
    return cell;
}

+ (instancetype)cellWithNibCollectionView:(UICollectionView *)collectionView withIndexPath:(NSIndexPath *)indexPath {
    NSString *reuseId = NSStringFromClass([self class]);
    
    id cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseId forIndexPath:indexPath ];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil] lastObject];
    }
    [cell setupCell];
    [cell setupSubViews];
    
    return cell;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupCell];
        [self setupSubViews];
    }
    return self;
}

// 子类重写该方法，设置Cell样式
- (void)setupCell
{
    
}

// 子类重写该方法，设置View
- (void)setupSubViews
{
    
}


// 子类重写该方法，设置View数据
- (void)setViewWithModel:(id)model
{
    
}

@end
