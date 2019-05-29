//
//  CacheHelper.h
//  XFSSalesApp
//
//  Created by mac on 2018/6/1.
//  Copyright © 2018年 http://www.xinfangsheng.com. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^CacheCallBack)(BOOL result);
@interface CacheHelper : NSObject
@property (nonatomic , assign) NSInteger index;
+ (instancetype)sharedManager;

/** 存储数据 */
- (void)saveDataWithObject: (id)object key: (NSString *)key
            cacheCallBack : (CacheCallBack)cacheCallBack;
/** 读取数据 */
- (id)readDataWithKey: (NSString *)Key;
/** 删除数据 */
- (void)deleteDataWithKey: (NSString *)Key;


@end
