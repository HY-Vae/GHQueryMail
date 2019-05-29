//
//  IOHistoryCell.h
//  GHQueryMail
//
//  Created by zhaozhiwei on 2019/4/23.
//  Copyright © 2019年 GHome. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class IOMailModel;
@interface IOHistoryCell : UITableViewCell
@property (nonatomic , strong) IOMailModel *mailModel;
@end

NS_ASSUME_NONNULL_END
