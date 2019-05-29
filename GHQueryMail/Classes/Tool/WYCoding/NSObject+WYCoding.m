//
//  NSObject+WYCoding.m
//  WYArchiver
//
//  Created by 李卫友 on 2017/4/10.
//  Copyright © 2017年 李卫友. All rights reserved.
//

#import "NSObject+WYCoding.h"
#import "WYProperty.h"


static const char WYAllowedCodingPropertyNamesKey = '\0';
static const char WYIgnoredCodingPropertyNamesKey = '\0';


static NSMutableDictionary *allowedCodingPropertyNamesDict_;
static NSMutableDictionary *ignoredCodingPropertyNamesDict_;

@implementation NSObject (WYCoding)


+ (void)load
{
    allowedCodingPropertyNamesDict_ = [NSMutableDictionary dictionary];
    ignoredCodingPropertyNamesDict_ = [NSMutableDictionary dictionary];
}

+ (NSMutableDictionary *)dictForKey:(const void *)key
{
    @synchronized (self) {
        if (key == &WYAllowedCodingPropertyNamesKey) return allowedCodingPropertyNamesDict_;
        if (key == &WYIgnoredCodingPropertyNamesKey) return ignoredCodingPropertyNamesDict_;
        return nil;
    }
}

/**
 归档对象
 
 @param encoder encoder
 */
- (void)wy_encode:(NSCoder *)encoder
{
    Class clazz = [self class];
    
    NSArray *allowedCodingPropertyNames = [clazz WY_totalAllowedCodingPropertyNames];
    NSArray *ignoredCodingPropertyNames = [clazz WY_totalIgnoredCodingPropertyNames];
    BOOL ignore = [clazz wy_ignoreSuperNames];
    [clazz wy_enumeratePropertiesIgnoreSuperClassPropertyNames:ignore enumeration:^(WYProperty *property, BOOL *stop) {
        
        // 检测是否被忽略
        if (allowedCodingPropertyNames.count && ![allowedCodingPropertyNames containsObject:property.name]) return;
        if ([ignoredCodingPropertyNames containsObject:property.name]) return;
        
        id value = [property valueForObject:self];
        if (value == nil) return;
        
        /**
         //开始存档对象 存档的数据都会存储到NSMutableData中 会调用对象的`encodeWithCoder`方法
         [archiver encodeObject:object forKey:key];
         */
        if (property.name.length) {
            [encoder encodeObject:value forKey:property.name];

        }
    }];
}
/**
 解档对象
 
 对象的`initWithCoder`方法会调用该方法
 @param decoder decoder
 */
- (void)wy_decode:(NSCoder *)decoder
{
    Class clazz = [self class];
    
    NSArray *allowedCodingPropertyNames = [clazz WY_totalAllowedCodingPropertyNames];
    NSArray *ignoredCodingPropertyNames = [clazz WY_totalIgnoredCodingPropertyNames];
    BOOL ignore = [clazz wy_ignoreSuperNames];
    
    [clazz wy_enumeratePropertiesIgnoreSuperClassPropertyNames:ignore enumeration:^(WYProperty *property, BOOL *stop) {
        
        // 检测是否被忽略
        if (allowedCodingPropertyNames.count && ![allowedCodingPropertyNames containsObject:property.name]) return;
        if ([ignoredCodingPropertyNames containsObject:property.name]) return;
        
        id value = [decoder decodeObjectForKey:property.name];
        if (value == nil) {
            return ;
        }
        
        [property setValue:value forObject:self];
    }];
}


/**
 是否忽略归档父类

 @return 是否忽略
 */
+ (BOOL)wy_ignoreSuperNames
{
    SEL selector = @selector(wy_ignoreCodingSuperClassPropertyNames);
    if ([self respondsToSelector:selector]) {
        
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        BOOL ignore = [self performSelector:selector];
#pragma clang diagnostic pop
        
        return ignore;
    }
    return NO;
}
/**
 *  这个数组中的属性名将会被忽略：不进行归档
 */
+ (NSMutableArray *)WY_totalIgnoredCodingPropertyNames
{
    return [self wy_totalObjectsWithSelector:@selector(wy_ignoredCodingPropertyNames) key:&WYIgnoredCodingPropertyNamesKey];
}

+ (NSMutableArray *)WY_totalAllowedCodingPropertyNames
{
    return [self wy_totalObjectsWithSelector:@selector(wy_allowedCodingPropertyNames) key:&WYAllowedCodingPropertyNamesKey];
}

+ (NSMutableArray *)wy_totalObjectsWithSelector:(SEL)selector key:(const char *)key
{
    NSMutableArray *array = [self dictForKey:key][NSStringFromClass(self)];
    if (array) return array;
    
    // 创建、存储
    [self dictForKey:key][NSStringFromClass(self)] = array = [NSMutableArray array];
    
    if ([self respondsToSelector:selector]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        NSArray *subArray = [self performSelector:selector];
#pragma clang diagnostic pop
        if (subArray) {
            [array addObjectsFromArray:subArray];
        }
    }
    
    [self wy_enumerateAllClasses:^(__unsafe_unretained Class c, BOOL *stop) {
        NSArray *subArray = objc_getAssociatedObject(c, key);
        [array addObjectsFromArray:subArray];
    }];
    return array;
}
@end
