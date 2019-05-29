//
//  GHDBHelper.h
//  GHPasswordManager-OC
//
//  Created by zhaozhiwei on 2019/2/28.
//  Copyright © 2019年 GHome. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"

NS_ASSUME_NONNULL_BEGIN

@interface GHDBHelper : NSObject

@property (nonatomic, retain, readonly) FMDatabaseQueue *dbQueue;

+ (GHDBHelper *)shareInstance;

+ (NSString *)jzgdbPath;

- (BOOL)changeDBWithDirectoryName:(NSString *)directoryName;

@end

NS_ASSUME_NONNULL_END
