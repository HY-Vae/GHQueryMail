//
//  WYProperty.h
//  WYArchiver
//
//  Created by 李卫友 on 2017/4/10.
//  Copyright © 2017年 李卫友. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

/**
 *  遍历所有类的block（父类）
 */
typedef void (^WYClassesEnumeration)(Class c, BOOL *stop);

@interface WYProperty : NSObject
/** 属性 */
@property (nonatomic , assign) objc_property_t property;
/** 成员属性的名称 */
@property (nonatomic , copy) NSString *name;

/** 成员属性来源于哪个类（可能是父类） */
@property (nonatomic, assign) Class srcClass;
/**
 设置成员变量的值

 @param value 值
 @param object object
 */
- (void)setValue:(id)value forObject:(id)object;

/**
 获取成员变量的值

 @param object object
 @return value
 */
- (id)valueForObject:(id)object;

/**
 通过成员属性生成WYProperty对象

 @param property 属性
 @return 自身对象
 */
+ (instancetype)cachePropertyWithProprty:(objc_property_t)property;
@end

/**
 *  遍历成员变量用的block
 *
 *  @param property 成员的包装对象
 *  @param stop   YES代表停止遍历，NO代表继续遍历
 */
typedef void (^WYPropertiesEnumeration)(WYProperty *property, BOOL *stop);



@interface NSObject (WYProperty)
/**
 遍历所有的成员

 @param enumeration 遍历器
 */

+ (void)wy_enumeratePropertiesIgnoreSuperClassPropertyNames:(BOOL)ignore  enumeration:(WYPropertiesEnumeration)enumeration;

+ (void)wy_enumerateAllClasses:(WYClassesEnumeration)enumeration;
@end

@interface WYFoundation : NSObject

+ (BOOL)isClassFromFoundation:(Class)c;
@end
