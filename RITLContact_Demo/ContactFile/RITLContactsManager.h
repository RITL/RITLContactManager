//
//  YContactsManager.h
//  YAddressBookDemo
//
//  Created by YueWen on 16/5/6.
//  Copyright © 2016年 YueWen. All rights reserved.
//

#import <Foundation/Foundation.h>


@class RITLContactObject;
@protocol CNKeyDescriptor;


NS_ASSUME_NONNULL_BEGIN



/**
 请求联系人对象的方式,no implementation
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
 想要获得的键值描述，详见NSString+RITLContactFile.m 或者 CNContact.h,默认为RITLContactAllKeys
 */
@property (nonatomic, copy)NSArray <id<CNKeyDescriptor>> * descriptors NS_AVAILABLE_IOS(9_0);


/**
 通讯录发生变化进行的回调，返回更新完毕的RITLContactObject对象数组
 */
@property (nonatomic, copy)void(^contactDidChange)(NSArray<RITLContactObject *>*);


/**
 *  RITLContactsManager单例
 */
//+(instancetype)sharedInstance __deprecated_msg("singlecase is not implementation now,please use [[RITLContactsManager alloc] init]");


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
@interface RITLContactsManager (RITLAddContact)

/**
 向通讯录里添加联系人,目前使用AddressBook会出现问题

 @param contact 添加的联系人
 */
- (void)addContact:(RITLContactObject *)contact NS_AVAILABLE_IOS(9_0);


@end


NS_ASSUME_NONNULL_END


