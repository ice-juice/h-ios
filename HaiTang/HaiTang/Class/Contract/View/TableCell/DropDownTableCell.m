//
//  DropDownTableCell.m
//  HaiTang
//
//  Created by 吴紫颖 on 2020/10/23.
//  Copyright © 2020 zy. All rights reserved.
//

#import "DropDownTableCell.h"

#import "SymbolModel.h"
#import "RecordSubModel.h"

@interface DropDownTableCell ()
@property (weak, nonatomic) IBOutlet UILabel *lbTitle;

@end

@implementation DropDownTableCell
#pragma mark - Super Class
- (void)setViewWithModel:(id)model {
    if (model && [model isKindOfClass:[SymbolModel class]]) {
        SymbolModel *symbolModel = model;
        self.lbTitle.text = symbolModel.symbols;
    } else if (model && [model isKindOfClass:[RecordSubModel class]]) {
        RecordSubModel *subModel = model;
        self.lbTitle.text = subModel.sources;
    } else if (model && [model isKindOfClass:[NSString class]]) {
        self.lbTitle.text = model;
    }
}

@end
