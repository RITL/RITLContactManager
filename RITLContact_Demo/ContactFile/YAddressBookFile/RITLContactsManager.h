//
//  YContactsManager.h
//  YAddressBookDemo
//
//  Created by YueWen on 16/5/6.
//  Copyright © 2016年 YueWen. All rights reserved.
//

#import <Foundation/Foundation.h>


@class YContactObject;


NS_ASSUME_NONNULL_BEGIN

/**
 *  请求通讯录所有联系人的Manager
 */
@interface RITLContactsManager : NSObject

/**
 *  YAddressBookManager单例
 */
+(instancetype)sharedInstance;

/**
 *  请求所有的联系人,按照添加人的时间顺序
 *
 *  @param completeBlock 完成的回调
 */
- (void)requestContactsComplete:(void (^)(NSArray <YContactObject *> *))completeBlock;


@end







/**
 *  手动进行联系人数据添加类目
 */
@interface RITLContactsManager (YCodingHandle)


- (void)codingAddPersonToAddressBook;


@end


NS_ASSUME_NONNULL_END


