//
//  PendingOrderSellTableCell.m
//  HaiTang
//
//  Created by 吴紫颖 on 2020/10/13.
//  Copyright © 2020 zy. All rights reserved.
//

#import "PendingOrderSellTableCell.h"

#import "NewModel.h"
#import "BaseTableModel.h"

@interface PendingOrderSellTableCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imgViewSelect;
@property (weak, nonatomic) IBOutlet UIImageView *imgViewIcon;
@property (weak, nonatomic) IBOutlet UILabel *lbTitle;
@property (weak, nonatomic) IBOutlet UILabel *lbSubTitle;

@end

@implementation PendingOrderSellTableCell
#pragma mark - Super Class
- (void)setViewWithModel:(id)model {
    if (model && [model isKindOfClass:[BaseTableModel class]]) {
        BaseTableModel *tableModel = model;
        self.imgViewIcon.image = [UIImage imageNamed:tableModel.imageName];
        self.lbTitle.text = tableModel.title;
        
        if (tableModel.content && [tableModel.content count]) {
            NewModel *newModel = tableModel.content[0];
            self.lbSubTitle.text = newModel.idcard;
        } else {
            self.lbSubTitle.text = NSLocalizedString(@"前往绑定", nil);
        }        
    }
}

#pragma mark - Setter & Getter
- (void)setIsCellSelected:(BOOL)isCellSelected {
    _isCellSelected = isCellSelected;
    if (isCellSelected) {
        self.imgViewSelect.image = [UIImage imageNamed:@"zctk-wxz-1"];
    } else {
        self.imgViewSelect.image = [UIImage imageNamed:@"zctk-wxz-2"];
    }
}

- (void)setSelectModel:(NewModel *)selectModel {
    _selectModel = selectModel;
    if (selectModel != nil) {
        self.lbSubTitle.text = selectModel.idcard;
    }
}

@end
