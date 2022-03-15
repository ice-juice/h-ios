//
//  FiatOrderDetailTextCell.m
//  HaiTang
//
//  Created by 吴紫颖 on 2020/10/12.
//  Copyright © 2020 zy. All rights reserved.
//

#import "FiatOrderDetailTextCell.h"

#import "FiatOrderDetailTableModel.h"

@interface FiatOrderDetailTextCell ()
@property (weak, nonatomic) IBOutlet UILabel *lbTitle;
@property (weak, nonatomic) IBOutlet UILabel *lbSubTitle;
@property (weak, nonatomic) IBOutlet UIButton *btnCopy;
@property (weak, nonatomic) IBOutlet UIImageView *imgViewQRCode;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *subTitleTralingLayout;
@property (weak, nonatomic) IBOutlet UIImageView *imgViewArrow;

@end

@implementation FiatOrderDetailTextCell
#pragma mark - Event Response
- (IBAction)onBtnWithCopyEvent:(UIButton *)sender {
    //复制
    [JYToastUtils showShortWithStatus:NSLocalizedString(@"复制成功", nil)];
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = self.lbSubTitle.text;
}

#pragma mark - Super Class
- (void)setViewWithModel:(id)model {
    if (model && [model isKindOfClass:[FiatOrderDetailTableModel class]]) {
        FiatOrderDetailTableModel *tableModel = model;
        self.lbTitle.text = NSLocalizedString(tableModel.title, nil);
        self.lbSubTitle.text = NSLocalizedString(tableModel.subTitle, nil);
        if (tableModel.cellType == FiatOrderDetailCellTypeText) {
            self.subTitleTralingLayout.constant = 15;
            self.btnCopy.hidden = YES;
            self.imgViewQRCode.hidden = YES;
            self.imgViewArrow.hidden = YES;
        } else if (tableModel.cellType == FiatOrderDetailCellTypeTextAndCopy) {
            self.subTitleTralingLayout.constant = 36;
            self.btnCopy.hidden = NO;
            self.imgViewQRCode.hidden = YES;
            self.imgViewArrow.hidden = YES;
        } else if (tableModel.cellType == FiatOrderDetailCellTypeImage) {
            self.subTitleTralingLayout.constant = 0;
            self.btnCopy.hidden = YES;
            self.imgViewQRCode.hidden = NO;
            self.imgViewArrow.hidden = YES;
        } else {
            self.btnCopy.hidden = YES;
            self.imgViewQRCode.hidden = YES;
            self.imgViewArrow.hidden = NO;
            self.subTitleTralingLayout.constant = 32;
            self.lbSubTitle.textColor = kRGB(0, 102, 237);
        }
    }
}

@end
