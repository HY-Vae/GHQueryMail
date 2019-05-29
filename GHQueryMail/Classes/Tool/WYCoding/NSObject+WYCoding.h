//
//  NSObject+WYCoding.h
//  WYArchiver
//
//  Created by 李卫友 on 2017/4/10.
//  Copyright © 2017年 李卫友. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol WYCoding <NSObject>
@optional
/**
 *  这个数组中的属性名才会进行归档
 */
+ (NSArray *)wy_allowedCodingPropertyNames;
/**
 *  这个数组中的属性名将会被忽略：不进行归档
 */
+ (NSArray *)wy_ignoredCodingPropertyNames;

/**
 忽略归档父类的属性

 @return 是否忽略
 */
+ (BOOL)wy_ignoreCodingSuperClassPropertyNames;

@end
@interface NSObject (WYCoding)<WYCoding>

- (void)wy_encode:(NSCoder *)encoder;

- (void)wy_decode:(NSCoder *)decoder;
@end

#define WYCodingImplementation \
- (instancetype)initWithCoder:(NSCoder *)aDecoder\
{\
    if (self = [super init]) {\
        [self wy_decode:aDecoder];\
    }\
    return self;\
}\
- (void)encodeWithCoder:(NSCoder *)aCoder\
{\
    [self wy_encode:aCoder];\
}
