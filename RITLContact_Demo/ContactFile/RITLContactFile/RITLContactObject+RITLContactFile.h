//
//  RITLContactObject+RITLContactFile.h
//  RITLContact_Demo
//
//  Created by YueWen on 2016/10/11.
//  Copyright © 2016年 YueWen. All rights reserved.
//

#import "RITLContactObject.h"

NS_ASSUME_NONNULL_BEGIN

@class CNContact;
@class CNPostalAddress;

@interface NSObject (RITLContactFile)

- (void)contactObject:(CNContact *)contact NS_AVAILABLE_IOS(9_0);

@end

@interface RITLContactObject (RITLContactFile)

/**
 获得只存放电话号码的数组

 @return 存放电话号码的数组
 */
- (NSArray <NSString *> *)phones;

@end


@interface RITLContactNameObject (RITLContactFile)

@end


@interface RITLContactAddressObject (RITLContactFile)

/**
 针对CNPostalAddress进行模型转换

 @param cnAddressObject CNPostalAddress对象
 */
- (void)contactObject:(CNPostalAddress *)cnAddressObject;


@end

NS_ASSUME_NONNULL_END
