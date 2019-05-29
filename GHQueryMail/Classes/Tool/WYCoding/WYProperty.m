//
//  WYProperty.m
//  WYArchiver
//
//  Created by 李卫友 on 2017/4/10.
//  Copyright © 2017年 李卫友. All rights reserved.
//

#import "WYProperty.h"

@implementation WYProperty
+ (instancetype)cachePropertyWithProprty:(objc_property_t)property
{
    WYProperty *propertyObj = objc_getAssociatedObject(self, property);
    if (propertyObj == nil) {
        propertyObj = [[self  alloc] init];
        propertyObj.property = property;
        objc_setAssociatedObject(self, property, propertyObj, OBJC_ASSOCIATION_RETAIN);
    }
    return propertyObj;
}
- (void)setProperty:(objc_property_t)property
{
    _property = property;
    
    _name = @(property_getName(property));
}

/** 设置成员变量的值 */
- (void)setValue:(id)value forObject:(id)object
{
    
    if (value == nil) return;
    [object setValue:value forKey:self.name];
}

- (id)valueForObject:(id)object
{
    
    return [object valueForKey:self.name];
}

@end



static const char WYCachedPropertiesKey = '\0';
static const char WYIgnoreCachedPropertiesKey = '\0';
@implementation NSObject (WYProperty)


static NSMutableDictionary *cachedPropertiesDict_;
static NSMutableDictionary *ignoreCachedPropertiesDict_;

+ (void)load
{
    
    cachedPropertiesDict_ = [NSMutableDictionary dictionary];
    ignoreCachedPropertiesDict_ = [NSMutableDictionary dictionary];
}

+ (NSMutableDictionary *)dictForKey:(const void *)key
{
    @synchronized (self) {
        if (key == &WYCachedPropertiesKey) return cachedPropertiesDict_;
        if (key == &WYIgnoreCachedPropertiesKey) return ignoreCachedPropertiesDict_;
        return nil;
    }
}
+ (void)enumerateProperties:(NSMutableArray *)cacheArray class:(Class)clazz
{
    if (cacheArray == nil) {
        cacheArray = [NSMutableArray array];
    }
    unsigned int outCount = 0;
    
    objc_property_t *properties = class_copyPropertyList(clazz, &outCount);
    
    for (unsigned int i = 0; i < outCount; i++) {
        
        WYProperty *property = [WYProperty cachePropertyWithProprty:properties[i]];
        
        if ([WYFoundation isClassFromFoundation:property.srcClass]) {
            continue;
        }
        
        property.srcClass = clazz;
        
        [cacheArray addObject:property];
    }
    
    free(properties);
}
+ (NSMutableArray *)properties:(BOOL)ignoreSuper
{
    
    NSMutableArray *cachedProperties = [self dictForKey:&WYCachedPropertiesKey][NSStringFromClass(self)];
    BOOL ignore = [[self dictForKey:&WYIgnoreCachedPropertiesKey][NSStringFromClass(self)] boolValue];
    if (ignore == ignoreSuper) {
        if (cachedProperties == nil) {
            cachedProperties = [NSMutableArray array];
            [self wy_enumerateClass:^(__unsafe_unretained Class c, BOOL *stop) {
                
                [self enumerateProperties:cachedProperties class:c];
            }];
            
            [self dictForKey:&WYCachedPropertiesKey][NSStringFromClass(self)] = cachedProperties;
        }

    }
    else {
        if (ignoreSuper) {//忽略父类
            cachedProperties = [NSMutableArray array];
            [self enumerateProperties:cachedProperties class:self];
            
            [self dictForKey:&WYCachedPropertiesKey][NSStringFromClass(self)] = cachedProperties;
            
            [self dictForKey:&WYIgnoreCachedPropertiesKey][NSStringFromClass(self)] = @(ignoreSuper);
        }
        
        else {//不忽略父类
            cachedProperties = [NSMutableArray array];
            [self wy_enumerateClass:^(__unsafe_unretained Class c, BOOL *stop) {
                
                [self enumerateProperties:cachedProperties class:c];
            }];
            
            [self dictForKey:&WYCachedPropertiesKey][NSStringFromClass(self)] = cachedProperties;

            [self dictForKey:&WYIgnoreCachedPropertiesKey][NSStringFromClass(self)] = @(ignoreSuper);
        }
    }
    return cachedProperties;
}
+ (void)wy_enumerateClass:(WYClassesEnumeration)enumeration
{
    // 1.没有block就直接返回
    if (enumeration == nil) return;
    
    // 2.停止遍历的标记
    BOOL stop = NO;
    
    // 3.当前正在遍历的类
    Class c = self;
    
    // 4.开始遍历每一个类
    while (c && !stop) {
        // 4.1.执行操作
        enumeration(c, &stop);
        
        // 4.2.获得父类
        c = class_getSuperclass(c);
        
        if ([WYFoundation isClassFromFoundation:c]) break;
    }
}

+ (void)wy_enumerateAllClasses:(WYClassesEnumeration)enumeration
{
    // 1.没有block就直接返回
    if (enumeration == nil) return;
    
    // 2.停止遍历的标记
    BOOL stop = NO;
    
    // 3.当前正在遍历的类
    Class c = self;
    
    // 4.开始遍历每一个类
    while (c && !stop) {
        // 4.1.执行操作
        enumeration(c, &stop);
        
        // 4.2.获得父类
        c = class_getSuperclass(c);
    }
}
+ (void)wy_enumeratePropertiesIgnoreSuperClassPropertyNames:(BOOL)ignore  enumeration:(WYPropertiesEnumeration)enumeration
{
    NSArray *properties = [self properties:ignore];
    
    BOOL stop = NO;
    
    for (WYProperty* pro in properties ) {
        enumeration(pro, &stop);
        if (stop) {
            break;
        }
    }
}

@end


#import <CoreData/CoreData.h>

static NSSet *foundationClasses_;
@implementation WYFoundation

+ (NSSet *)foundationClasses
{
    if (foundationClasses_ == nil) {
        // 集合中没有NSObject，因为几乎所有的类都是继承自NSObject，具体是不是NSObject需要特殊判断
        foundationClasses_ = [NSSet setWithObjects:
                              [NSURL class],
                              [NSDate class],
                              [NSValue class],
                              [NSData class],
                              [NSError class],
                              [NSArray class],
                              [NSDictionary class],
                              [NSString class],
                              [NSAttributedString class], nil];
    }
    return foundationClasses_;
}

+ (BOOL)isClassFromFoundation:(Class)c
{
    if (c == [NSObject class] || c == [NSManagedObject class]) return YES;
    
    __block BOOL result = NO;
    [[self foundationClasses] enumerateObjectsUsingBlock:^(Class foundationClass, BOOL *stop) {
        if ([c isSubclassOfClass:foundationClass]) {
            result = YES;
            *stop = YES;
        }
    }];
    return result;
}
@end
