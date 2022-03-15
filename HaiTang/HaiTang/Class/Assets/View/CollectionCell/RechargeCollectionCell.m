//
//  RechargeCollectionCell.m
//  HaiTang
//
//  Created by 吴紫颖 on 2021/2/4.
//  Copyright © 2021 zy. All rights reserved.
//

#import "RechargeCollectionCell.h"

@interface RechargeCollectionCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imgViewIcon;
@property (weak, nonatomic) IBOutlet UIButton *btnClose;

@end

@implementation RechargeCollectionCell
#pragma mark - Event Response
- (IBAction)onBtnCloseEvent:(UIButton *)sender {
    if (self.onDeleteBlock) {
        self.onDeleteBlock();
    }
}

- (void)setViewWithModel:(id)model {
    if (model && [model isKindOfClass:[NSString class]]) {
        NSString *imageName = model;
        self.imgViewIcon.image = nil;
        if ([imageName isEqualToString:kCameraImageName]) {
            self.imgViewIcon.image = [UIImage imageNamed:kCameraImageName];
            self.btnClose.hidden = YES;
        } else {
            [self.imgViewIcon setImageURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", SERVER_URL, imageName]]];
            self.btnClose.hidden = NO;
        }
    }
}

@end
