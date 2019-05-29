//
//  IOMailManager.h
//  GHQueryMail
//
//  Created by zhaozhiwei on 2019/4/24.
//  Copyright © 2019年 GHome. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface IOMailManager : NSObject

/**
 *  删除某一条记录(通过唯一标识符)
 *
 *
 *  @return YES or NO
 */
- (BOOL)deleteRecordWithIdentifier:(NSString *)identifier;


/**
 *  单例
 *
 *  @return GHPasswordManager对象
 */
+ (instancetype)share;

/**
 *  添加一条记录
 *
 *
 *  @return YES or NO
 */
- (BOOL)saveRecordWithDict: (NSDictionary *)dict;

/**
 *  删除某一条记录(通过唯一标识符)
 *
 *
 *  @return YES or NO
 */
- (BOOL)deleteRecordWithKey:(NSString *)key;

/**
 *  删除所有记录
 *
 *
 *  @return YES or NO
 */
- (BOOL)deleteAllRecord;

/**
 *  获取设备所有登录记录
 *
 *
 */
- (NSMutableArray *)getAllRecords;
@end

NS_ASSUME_NONNULL_END
