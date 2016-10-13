//
//  NSString+RITLContactFile.h
//  RITLContact_Demo
//
//  Created by YueWen on 2016/10/12.
//  Copyright © 2016年 YueWen. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol CNKeyDescriptor;

@interface NSString (RITLContactFile)

/**
 获得联系人所有描述姓名键的便利方法

 @return 存放姓名描述姓名键的便利方法
 */
+ (NSArray <id <CNKeyDescriptor>> *)RITLContactNameKeys;



/**
 获得所有联系人的所有键的便利方法

 @return 存放所有联系人所有键的便利方法
 */
+ (NSArray <id<CNKeyDescriptor>> *)RITLContactAllKeys;

@end


NS_ASSUME_NONNULL_END
