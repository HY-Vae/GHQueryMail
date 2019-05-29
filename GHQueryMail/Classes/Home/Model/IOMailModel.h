//
//  IOMailModel.h
//  GHQueryMail
//
//  Created by zhaozhiwei on 2019/4/23.
//  Copyright © 2019年 GHome. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GHDBModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface IOMailModel : GHDBModel

@property (nonatomic , copy) NSString *number;
@property (nonatomic , strong) NSArray *list;
@property (nonatomic , copy) NSString *deliverystatus;
@property (nonatomic , copy) NSString *issign;
@property (nonatomic , copy) NSString *expName;
@property (nonatomic , copy) NSString *expSite;
@property (nonatomic , copy) NSString *expPhone;
@property (nonatomic , copy) NSString *logo;

@end

NS_ASSUME_NONNULL_END
