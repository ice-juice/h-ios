//
//  PhoneCodeMainView.h
//  HaiTang
//
//  Created by 吴紫颖 on 2020/11/11.
//  Copyright © 2020 zy. All rights reserved.
//

#import "BaseTableView.h"

NS_ASSUME_NONNULL_BEGIN

@protocol PhoneCodeMainViewDelegate <BaseTableViewDelegate>
//选择手机区号
- (void)tableView:(UITableView *)tableView selectPhoneCode:(NSString *)code;

@end

@interface PhoneCodeMainView : BaseTableView

@end

NS_ASSUME_NONNULL_END
