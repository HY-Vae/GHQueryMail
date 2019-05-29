//
//  IOPhoneModel.h
//  GHQueryMail
//
//  Created by zhaozhiwei on 2019/4/23.
//  Copyright © 2019年 GHome. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface IOPhoneModel : NSObject

@property (nonatomic , copy) NSString *name;
@property (nonatomic , copy) NSString *phone;

- (NSArray *)getData;
@end

NS_ASSUME_NONNULL_END
