//
//  IOMaiDetailsCell.h
//  GHQueryMail
//
//  Created by zhaozhiwei on 2019/4/23.
//  Copyright © 2019年 GHome. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class IOMaiDetailsModel;
@interface IOMaiDetailsCell : UITableViewCell
@property (nonatomic , strong) IOMaiDetailsModel *maiDetailsModel;

- (void)setLineStatusShow;
- (void)setLineStatusHidden;

@end

NS_ASSUME_NONNULL_END
