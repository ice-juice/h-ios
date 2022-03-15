//
//  SelectTimeTableCell.m
//  HaiTang
//
//  Created by 吴紫颖 on 2020/11/3.
//  Copyright © 2020 zy. All rights reserved.
//

#import "SelectTimeTableCell.h"

@interface SelectTimeTableCell ()
@property (weak, nonatomic) IBOutlet UILabel *lbTitle;

@end

@implementation SelectTimeTableCell
- (void)setViewWithModel:(id)model {
    if (model && [model isKindOfClass:[NSString class]]) {
        self.lbTitle.text = model;
    }
}

@end
