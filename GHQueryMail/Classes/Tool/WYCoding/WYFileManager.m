//
//  WYFileManager.m
//  WYArchiver
//
//  Created by 李卫友 on 2017/4/21.
//  Copyright © 2017年 李卫友. All rights reserved.
//

#import "WYFileManager.h"


static NSMutableDictionary *wyFilePathDict_;

@implementation WYFileManager

+ (void)load
{
    wyFilePathDict_ = [NSMutableDictionary dictionary];
}

/**
 获取沙盒路径下Document目录
 
 @return filePath
 */
+ (NSString *)getDocumentFilePath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);//第一个常量NSDocumentDirectory表示正在查找沙盒Document目录的路径（如果参数为NSCachesDirectory则表示沙盒Cache目录），第二个常量NSUserDomainMask表明我们希望将搜索限制在应用的沙盒内；
    NSString *documentFilePath = paths.firstObject;//因为每一个应用只有一个Documents目录，所以这里取第一个和最后一个数据都是一样的
    return documentFilePath;
}
/**
 获取沙盒路径下cache文件夹路径
 
 @return filePath
 */
+ (NSString *)getCacheFilePath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    return paths.firstObject;
}

/**
 获取沙盒路径下tmp目录
 
 @return filePath
 */
+ (NSString *)getTmpFilePath
{
    NSString *tmpPath = NSTemporaryDirectory();
    return tmpPath;
}

/**
 保存文件到指定目录 默认路径为`Document`目录下的`key`文件夹
 
 @param object object
 @param key key
 */
+ (void)setCustomObject:(NSObject *)object forKey:(NSString *)key
{
    if (key == nil) { return; }
    NSString *documentFile = [self getDocumentFilePath];
    NSString *file = [documentFile stringByAppendingPathComponent:key];
    [self setCustomObject:object forKey:key filePath:file];
    
}

/**
 保存文件
 
 @param object 保存的对象·
 @param key 保存的key
 @param filePath 保存的文件路径
 */
+ (void)setCustomObject:(NSObject *)object forKey:(NSString *)key filePath:(NSString *)filePath
{
    if (filePath == nil || key == nil) { return; }
    //新建一块可变数据区(临时存储空间，以便随后写入文件，或者存放从磁盘读取的文件内容)
    NSMutableData *data = [NSMutableData data];
    //将数据区连接到NSKeyedArchiver对象
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    
    //开始存档对象 存档的数据都会存储到NSMutableData中 会调用对象的`encodeWithCoder`方法
    [archiver encodeObject:object forKey:key];
    
    //结束存档
    [archiver finishEncoding];
    
    //将存档的数据写入文件
    [data writeToFile:filePath atomically:YES];

    //存储路径
    wyFilePathDict_[key] = filePath;
}

/**
 获取保存对象的存储路径呢

 @param key 存储时的key
 @return 路径
 */
+ (NSString *)getCustomObjectFilePathWithKey:(NSString *)key
{
    if (![key isKindOfClass:[NSString class]]) {
        
        return nil;
    }
    
    return wyFilePathDict_[key];
}

/**
 获取保存在本地Document目录下的自定义对象
 
 @param key key
 @return object
 */
+ (id)getCustomObjectWithKey:(NSString *)key
{
    if (key == nil) { return nil; }
    NSString *documentFile = [self getDocumentFilePath];
    NSString *file = [documentFile stringByAppendingPathComponent:key];
    return [self getCustomObjectWithKey:key filePath:file];
}


/**
 获取保存在本地的自定义对象
 
 @param key 保存对象的key
 @param filePath 保存对象的路径
 @return object
 */
+ (id)getCustomObjectWithKey:(NSString *)key filePath:(NSString *)filePath
{
    if (key == nil || filePath == nil) { return nil; }
    
    
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    //反归档对象 会调用对象的`initWithCoder`方法
    id obj =  [unarchiver decodeObjectForKey:key];
    
    [unarchiver finishDecoding];
    return obj;
}
static dispatch_queue_t wy_clearCacheQueue() {
    
    return dispatch_queue_create("com.wy.clearCache", DISPATCH_QUEUE_SERIAL);
}

/**
 清除沙河路径的文件

 @param path 文件路径
 @param completion 完成之后的回调
 */
+ (void)clearCacheWithFilePath:(NSString *)path completion:(void(^)(BOOL result, NSError *error))completion
{
    
    NSFileManager *manager = [NSFileManager  defaultManager];
    
    if (![manager fileExistsAtPath:path]) {
        if (completion) {
            completion(YES, nil);
        }
        return ;
    }
    dispatch_async(wy_clearCacheQueue(), ^{
        NSError *error = nil;
         BOOL result = [manager removeItemAtPath:path error:&error];
        [manager createDirectoryAtPath:path
                withIntermediateDirectories:YES
                                 attributes:nil
                                      error:NULL];

        
        if (completion) {
            completion(result, error);
        }
    });
}

static dispatch_queue_t wy_calculateFileSizeQueue() {
    static dispatch_queue_t wy_calculateFileSizeQueue;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        wy_calculateFileSizeQueue = dispatch_queue_create("wy_calculateFileSizeQueue", DISPATCH_QUEUE_CONCURRENT);
    });
    
    return wy_calculateFileSizeQueue;
}

/**
 计算文件大小

 @param filePath 文件路径
 @param fileSize 文件大小
 */
+ (void )calculateFileSizeWithFilePath:(NSString *)filePath fileSize:(void(^)(unsigned long long size))fileSize
{
    
    // 总大小
    __block unsigned long long size = 0;
    NSFileManager *manager = [NSFileManager defaultManager];
    
    BOOL isDir = NO;
    BOOL exist = [manager fileExistsAtPath:filePath isDirectory:&isDir];
    
    // 判断路径是否存在
    if (!exist) {
        if (fileSize) {
            fileSize(size);
        }
        return;
    }
    
    
    //计算文件大小属于耗时操作,如果文件比较大,那么在主线程用此方法会卡住主线程,造成用户体验很差;所以,调用此方法应该放在子线程
    dispatch_async(wy_calculateFileSizeQueue(), ^{
        
        if (isDir) { // 是文件夹
            NSDirectoryEnumerator *enumerator = [manager enumeratorAtPath:filePath];
            for (NSString *subPath in enumerator) {
                NSString *fullPath = [filePath stringByAppendingPathComponent:subPath];
                size += [manager attributesOfItemAtPath:fullPath error:nil].fileSize;
                
            }
        }else{ // 是文件
            size += [manager attributesOfItemAtPath:filePath error:nil].fileSize;
        }

        dispatch_async(dispatch_get_main_queue(), ^{
            if (fileSize) {
                fileSize(size);
            }
        });
    });
}

/**
 计算文件大小

 @param filePath 文件路径
 @param fileSize 文件大小
 */
+ (void)fileSizeWithFilePath:(NSString *)filePath fileSize:(void(^)(NSString * size))fileSize
{
    // 总大小
    __block unsigned long long size = 0;
    __block NSString *sizeText = nil;
    // 文件管理者
    NSFileManager *mgr = [NSFileManager defaultManager];
    
    // 文件属性
     NSDictionary *attrs = [mgr attributesOfItemAtPath:filePath error:nil];
    // 如果这个文件或者文件夹不存在,或者路径不正确直接返回0;
    if (attrs == nil) {
        if (fileSize) {
            fileSize(sizeText);
        }
        return;
    }
    
    dispatch_async(wy_calculateFileSizeQueue(), ^{
        if ([attrs.fileType isEqualToString:NSFileTypeDirectory]) { // 如果是文件夹
            // 获得文件夹的大小  == 获得文件夹中所有文件的总大小
            NSDirectoryEnumerator *enumerator = [mgr enumeratorAtPath:filePath];
            for (NSString *subpath in enumerator) {
                // 全路径
                NSString *fullSubpath = [filePath stringByAppendingPathComponent:subpath];
                // 累加文件大小
                size += [mgr attributesOfItemAtPath:fullSubpath error:nil].fileSize;
                
                if (size >= pow(10, 9)) { // size >= 1GB
                    sizeText = [NSString stringWithFormat:@"%.2fGB", size / pow(10, 9)];
                } else if (size >= pow(10, 6)) { // 1GB > size >= 1MB
                    sizeText = [NSString stringWithFormat:@"%.2fMB", size / pow(10, 6)];
                } else if (size >= pow(10, 3)) { // 1MB > size >= 1KB
                    sizeText = [NSString stringWithFormat:@"%.2fKB", size / pow(10, 3)];
                } else { // 1KB > size
                    sizeText = [NSString stringWithFormat:@"%lluB", size];
                }
                
            }
        } else { // 如果是文件
            size = attrs.fileSize;
            if (size >= pow(10, 9)) { // size >= 1GB
                sizeText = [NSString stringWithFormat:@"%.2fGB", size / pow(10, 9)];
            } else if (size >= pow(10, 6)) { // 1GB > size >= 1MB
                sizeText = [NSString stringWithFormat:@"%.2fMB", size / pow(10, 6)];
            } else if (size >= pow(10, 3)) { // 1MB > size >= 1KB
                sizeText = [NSString stringWithFormat:@"%.2fKB", size / pow(10, 3)];
            } else { // 1KB > size
                sizeText = [NSString stringWithFormat:@"%lluB", size];
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
           
            if (fileSize) {
                fileSize(sizeText);
            }
        });
    });
}

@end
