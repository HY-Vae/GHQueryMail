//
//  IOSendMailCell.h
//  GHQueryMail
//
//  Created by zhaozhiwei on 2019/5/9.
//  Copyright © 2019年 GHome. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface IOSendMailCell : UITableViewCell
typedef void(^IOSendMailCellInputBlock)(NSString *str ,NSIndexPath *indexPath);
@property (nonatomic , strong) NSIndexPath *indexPath;
@property (nonatomic , copy) IOSendMailCellInputBlock inputBlock;

- (void)clearData;
@end

NS_ASSUME_NONNULL_END
