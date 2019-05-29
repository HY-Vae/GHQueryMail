//
//  IOMaiDetailsModel.h
//  GHQueryMail
//
//  Created by zhaozhiwei on 2019/4/23.
//  Copyright © 2019年 GHome. All rights reserved.
//

#import "GHDBModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface IOMaiDetailsModel : GHDBModel
@property (nonatomic , copy) NSString *time;
@property (nonatomic , copy) NSString *status;
@property (nonatomic , strong) NSIndexPath *indexPath;

@end

NS_ASSUME_NONNULL_END
