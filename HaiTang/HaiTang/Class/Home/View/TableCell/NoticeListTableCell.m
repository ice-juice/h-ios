//
//  NoticeListTableCell.m
//  HaiTang
//
//  Created by 吴紫颖 on 2020/10/10.
//  Copyright © 2020 zy. All rights reserved.
//

#import "NoticeListTableCell.h"

#import "NewModel.h"

@interface NoticeListTableCell ()
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *lbTitle;
@property (weak, nonatomic) IBOutlet UILabel *lbTime;

@end

@implementation NoticeListTableCell
#pragma mark - Super Class
- (void)setupSubViews {
    self.bgView.layer.cornerRadius = 8;
}

- (void)setViewWithModel:(id)model {
    if (model && [model isKindOfClass:[NewModel class]]) {
        NewModel *newModel = model;
        self.lbTitle.text = newModel.title;
        self.lbTime.text = newModel.createTime;
    }
}

@end
