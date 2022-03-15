//
//  PaymentMethodTableCell.m
//  HaiTang
//
//  Created by 吴紫颖 on 2020/10/29.
//  Copyright © 2020 zy. All rights reserved.
//

#import "PaymentMethodTableCell.h"

#import "NewModel.h"

@interface PaymentMethodTableCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imgViewIcon;
@property (weak, nonatomic) IBOutlet UILabel *lbTitle;
@property (weak, nonatomic) IBOutlet UIView *bgView;

@end

@implementation PaymentMethodTableCell
#pragma mark - Super Class
- (void)setupSubViews {
    self.bgView.layer.cornerRadius = 2;
    self.bgView.layer.borderColor = kRGB(236, 236, 236).CGColor;
    self.bgView.layer.borderWidth = 0.5;
}

- (void)setViewWithModel:(id)model {
    if (model && [model isKindOfClass:[NewModel class]]) {
        NewModel *newModel = model;
        self.lbTitle.text = [NSString stringWithFormat:@"%@ %@", newModel.name, newModel.idcard];
        self.imgViewIcon.image = [UIImage imageNamed:newModel.imgName];
    }
}

#pragma mark - Setter & Getter
- (void)setIsSelected:(BOOL)isSelected {
    if (isSelected) {
        _isSelected = isSelected;
        if (isSelected) {
            self.bgView.layer.borderColor = kRGB(0, 102, 237).CGColor;
        } else {
            self.bgView.layer.borderColor = kRGB(236, 236, 236).CGColor;
        }
    }
}

@end
