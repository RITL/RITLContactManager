//
//  YContactObjectManager.h
//  YAddressBookDemo
//
//  Created by YueWen on 16/5/6.
//  Copyright © 2016年 YueWen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AddressBook/AddressBook.h>

@class RITLContactObject;

NS_ASSUME_NONNULL_BEGIN


/**
 针对AddressBook.framework进行封装的类
 */
NS_CLASS_DEPRECATED_IOS(2_0, 9_0,"Use RITLContactObjectManager instead") @interface RITLAddressBookContactObjectManager : NSObject


/**
 *  根据ABRecordRef数据获得RITLContactObject对象
 *
 *  @param recordRef ABRecordRef对象
 *
 *  @return RITLContactObject对象
 */
+(RITLContactObject *)contantObject:(ABRecordRef)recordRef;




@end


@interface RITLAddressBookContactObjectManager (ABRecordRef)

/**
 根据RITLContactObject对象获得ABRecordRef数据,使用后请求手动管理ABRecordRef
 
 @param contactObject RITLContactObject对象
 
 @return ABRecordRef数据
 */
+(ABRecordRef)recordRef:(RITLContactObject *)contactObject;

@end

NS_ASSUME_NONNULL_END
