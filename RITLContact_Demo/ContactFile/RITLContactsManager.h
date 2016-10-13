//
//  YContactsManager.h
//  YAddressBookDemo
//
//  Created by YueWen on 16/5/6.
//  Copyright © 2016年 YueWen. All rights reserved.
//

#import <Foundation/Foundation.h>


@class RITLContactObject;


NS_ASSUME_NONNULL_BEGIN



/**
 请求联系人对象的方式
 */
typedef NS_ENUM(NSInteger,ContactsType)
{
    ContactsTypeDefault = 0,           /**<不拆分*/
    ContactsTypeSeparateByPhone = 1   /**<按照电话号码进行拆分*/
};


/**
 *  请求通讯录所有联系人的Manager
 */
@interface RITLContactsManager : NSObject

/**
 *  RITLContactsManager单例
 */
//+(instancetype)sharedInstance;


/**
 请求所有的联系人

 @param completeBlock 获取到数据完成的回调
 @param defendBlock   没有权限进行的回调
 */
- (void)requestContactsComplete:(void (^)(NSArray <RITLContactObject *> *))completeBlock defendBlock:(void(^)(void)) defendBlock;




/**
 请求所有的联系人

 @param contactType                  拆分方式
 @param completeBlock                获取到数据完成的回调
 @param defendBlock 没有权限进行的回调
 */
- (void)requestContactsType:(ContactsType)contactType Complete:(void (^)(NSArray<RITLContactObject *> * _Nonnull))completeBlock defendBlock:(void (^)(void))defendBlock;


@end







/**
 *  手动进行联系人数据添加类目
 */
@interface RITLContactsManager (YCodingHandle)


- (void)codingAddPersonToAddressBook;


@end


NS_ASSUME_NONNULL_END


