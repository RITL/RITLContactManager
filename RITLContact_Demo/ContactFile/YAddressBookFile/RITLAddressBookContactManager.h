//
//  RITLAddressBookContactManager.h
//  RITLContact_Demo
//
//  Created by YueWen on 2016/10/11.
//  Copyright © 2016年 YueWen. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class RITLContactObject;


/**
 针对AddressBook.framework进行请求数据的类
 */
NS_CLASS_DEPRECATED_IOS(2_0, 9_0,"Use RITLContactManager instead") @interface RITLAddressBookContactManager : NSObject


/**
 发生变化的回调,返回更新后的数组
 */
@property (nonatomic, copy)void(^addressBookDidChange)(NSArray<RITLContactObject *>*) NS_DEPRECATED_IOS(2_0,9_0,"Use RITLContactManager instead");


/**
 请求所有的联系人,按照添加人的时间顺序

 @param completeBlock 获取到数据完成的回调
 @param defendBlock   没有权限进行的回调
 */
- (void)requestContactsComplete:(void (^)(NSArray <RITLContactObject *> *))completeBlock defendBlock:(void(^)(void)) defendBlock NS_DEPRECATED_IOS(2_0,9_0,"Use RITLContactManager instead");


@end

NS_ASSUME_NONNULL_END
