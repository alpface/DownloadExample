//
//  NSObject+IvarList.h
//  Boobuz
//
//  Created by xiaoyuan on 2017/7/11.
//  Copyright © 2017年 erlinyou.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (IvarList)

- (NSDictionary *)toDictionary;

/// 将调用者对象的所有成员属性转换为字典，包含@'interface'下声明的属性(属性名前面的'_'已去除)
- (NSDictionary *)allIvarToDictionary;

/// 将调用者对象的所有成员属性转换为字典，不包含@'interface'下声明的属性
- (NSDictionary *)alLPropertyToDictonary;

+ (NSString *)dictionaryToJson:(id)dicOrArr;

- (NSString *)JSONString;

@end
