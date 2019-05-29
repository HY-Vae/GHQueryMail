//
//  IOPhoneCell.h
//  GHQueryMail
//
//  Created by zhaozhiwei on 2019/4/23.
//  Copyright © 2019年 GHome. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class IOPhoneModel;
@interface IOPhoneCell : UITableViewCell
@property (nonatomic , strong) IOPhoneModel *phoneModel;
@end

NS_ASSUME_NONNULL_END
