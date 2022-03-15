//
//  CollectionSettingsTableCell.m
//  HaiTang
//
//  Created by 吴紫颖 on 2020/10/15.
//  Copyright © 2020 zy. All rights reserved.
//

#import "CollectionSettingsTableCell.h"

#import "NewModel.h"

@interface CollectionSettingsTableCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imgViewIcon;
@property (weak, nonatomic) IBOutlet UILabel *lbAccount;
@property (weak, nonatomic) IBOutlet UILabel *lbPayName;

@end

@implementation CollectionSettingsTableCell
#pragma mark - Super Class
- (void)setViewWithModel:(id)model {
    if (model && [model isKindOfClass:[NewModel class]]) {
        NewModel *newModel = model;
        self.imageView.image = [UIImage imageNamed:newModel.img];
        self.lbAccount.text = newModel.idcard;
        if ([newModel.type isEqualToString:@"ALI_PAY"]) {
            self.lbPayName.text = NSLocalizedString(@"支付宝", nil);
            self.imgViewIcon.image = [UIImage imageNamed:@"zfb"];
        } else if ([newModel.type isEqualToString:@"WE_CHAT"]) {
            self.lbPayName.text = NSLocalizedString(@"微信", nil);
            self.imgViewIcon.image = [UIImage imageNamed:@"wx"];
        } else if ([newModel.type isEqualToString:@"BANK"]) {
            self.lbPayName.text = NSLocalizedString(@"银行卡", nil);
            self.imgViewIcon.image = [UIImage imageNamed:@"yhk"];
        } else {
            self.lbPayName.text = newModel.type;
        }
    }
}

@end
