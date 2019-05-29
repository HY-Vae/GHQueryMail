//
//  CacheHelper.m
//  XFSSalesApp
//
//  Created by mac on 2018/6/1.
//  Copyright © 2018年 http://www.xinfangsheng.com. All rights reserved.
//

#import "CacheHelper.h"

@implementation CacheHelper
+ (instancetype)sharedManager {
    static CacheHelper *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}


- (void)saveDataWithObject: (id)object key: (NSString *)key
            cacheCallBack : (CacheCallBack)cacheCallBack {
    BOOL success = NO;
    NSString *filePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist",key]];
    success = [NSKeyedArchiver archiveRootObject:object toFile:filePath];
    if (cacheCallBack) {
        cacheCallBack(success);
    }
}
- (id)readDataWithKey: (NSString *)Key {
    NSString *filePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist",Key]];
    NSObject *object = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
    return object;
}

- (void)deleteDataWithKey: (NSString *)Key {

    NSString *filePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist",Key]];

    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager removeItemAtPath:filePath error:nil];
}

@end

