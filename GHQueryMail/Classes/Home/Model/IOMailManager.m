//
//  IOMailManager.m
//  GHQueryMail
//
//  Created by zhaozhiwei on 2019/4/24.
//  Copyright © 2019年 GHome. All rights reserved.
//

#import "IOMailManager.h"
#import "IOMailModel.h"
#import "MJExtension.h"
#import "IOMaiDetailsModel.h"

@implementation IOMailManager

+ (instancetype)share{
    static dispatch_once_t t;
    static IOMailManager *recordManager = nil;
    dispatch_once(&t, ^{
        recordManager = [[IOMailManager alloc] init];
    });
    return recordManager;
}

- (BOOL)saveRecordWithDict: (NSDictionary *)dict {
    
    IOMailModel *model = [IOMailModel mj_objectWithKeyValues:dict];
//    bool exist = NO;
//    for (IOMailModel *m in [[IOMailManager share] getAllRecords]) {
//        if ([m.number isEqualToString:model.number]) {
//            exist = YES;
//        }
//    }
//    if (exist) {
       return [model saveOrUpdate];
//    }
//    return NO;
}


- (BOOL)deleteRecordWithIdentifier:(NSString *)identifier {
    if (!identifier || identifier.length == 0) {
        return NO;
    }
    NSString *sqlString = [NSString stringWithFormat:@"WHERE identifier = '%@'",identifier];
    return [IOMailModel deleteObjectsByCriteria:sqlString];
}

- (BOOL)deleteRecordWithKey:(NSString *)acount {
    if (!acount || acount.length == 0) {
        return NO;
    }
    NSString *sqlString = [NSString stringWithFormat:@"WHERE acount = '%@'",acount];
    return [IOMailModel deleteObjectsByCriteria:sqlString];
}

- (BOOL)deleteAllRecord{
    return [IOMailModel clearTable];
}

- (NSMutableArray *)getAllRecords{
    NSArray *arr = [IOMailModel findByCriteria:@"order by pk desc"];
    NSMutableArray *allArr = [[NSMutableArray alloc] initWithArray:arr];
    return allArr;
}

@end
