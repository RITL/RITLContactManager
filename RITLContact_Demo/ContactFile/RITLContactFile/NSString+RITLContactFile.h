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
 获得联系人所有描述键的便利方法

 @return 存放姓名描述建的便利方法
 */
+ (NSArray <id <CNKeyDescriptor>> *)RITLContactNameKeys;

@end


NS_ASSUME_NONNULL_END
