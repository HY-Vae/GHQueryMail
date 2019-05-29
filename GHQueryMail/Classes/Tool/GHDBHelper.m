//
//  GHDBHelper.m
//  GHPasswordManager-OC
//
//  Created by zhaozhiwei on 2019/2/28.
//  Copyright © 2019年 GHome. All rights reserved.
//

#import "GHDBHelper.h"
#import <objc/runtime.h>

@interface GHDBHelper()
@property (nonatomic, retain) FMDatabaseQueue *dbQueue;

@end
@implementation GHDBHelper

static GHDBHelper *_instance = nil;

+ (instancetype)shareInstance {
    static dispatch_once_t onceToken ;
    dispatch_once(&onceToken, ^{
        _instance = [[super allocWithZone:NULL] init] ;
    }) ;
    
    return _instance;
}

+ (NSString *)dbPathWithDirectoryName:(NSString *)directoryName
{
    NSString *docsdir = [NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSFileManager *filemanage = [NSFileManager defaultManager];
    if (directoryName == nil || directoryName.length == 0) {
        docsdir = [docsdir stringByAppendingPathComponent:@"JZGBD"];
    } else {
        docsdir = [docsdir stringByAppendingPathComponent:directoryName];
    }
    BOOL isDir;
    BOOL exit =[filemanage fileExistsAtPath:docsdir isDirectory:&isDir];
    if (!exit || !isDir) {
        [filemanage createDirectoryAtPath:docsdir withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSString *dbpath = [docsdir stringByAppendingPathComponent:@"jzgdb.sqlite"];
    return dbpath;
}

+ (NSString *)jzgdbPath
{
    return [self dbPathWithDirectoryName:nil];
}

- (FMDatabaseQueue *)dbQueue
{
    if (_dbQueue == nil) {
        _dbQueue = [[FMDatabaseQueue alloc] initWithPath:[self.class jzgdbPath]];
    }
    return _dbQueue;
}

- (BOOL)changeDBWithDirectoryName:(NSString *)directoryName
{
    if (_instance.dbQueue) {
        _instance.dbQueue = nil;
    }
    _instance.dbQueue = [[FMDatabaseQueue alloc] initWithPath:[GHDBHelper dbPathWithDirectoryName:directoryName]];
    
    int numClasses;
    Class *classes = NULL;
    numClasses = objc_getClassList(NULL,0);
    
    if (numClasses >0 )
    {
        classes = (__unsafe_unretained Class *)malloc(sizeof(Class) * numClasses);
        numClasses = objc_getClassList(classes, numClasses);
        for (int i = 0; i < numClasses; i++) {
            if (class_getSuperclass(classes[i]) == [GHDBHelper class]){
                id class = classes[i];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
                [class performSelector:@selector(createTable) withObject:nil];
#pragma clang diagnostic pop
            }
        }
        free(classes);
    }
    
    return YES;
}

+ (id)allocWithZone:(struct _NSZone *)zone
{
    return [GHDBHelper shareInstance];
}

- (id)copyWithZone:(struct _NSZone *)zone
{
    return [GHDBHelper shareInstance];
}

#if ! __has_feature(objc_arc)
- (oneway void)release
{
    
}

- (id)autorelease
{
    return _instance;
}

- (NSUInteger)retainCount
{
    return 1;
}
#endif
@end
