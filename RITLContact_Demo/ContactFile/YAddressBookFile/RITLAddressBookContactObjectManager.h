//
//  YContactObjectManager.h
//  YAddressBookDemo
//
//  Created by YueWen on 16/5/6.
//  Copyright © 2016年 YueWen. All rights reserved.
//

#import <Foundation/Foundation.h>
@import AddressBook;

@class YContactObject;

NS_ASSUME_NONNULL_BEGIN


@interface RITLAddressBookContactObjectManager : NSObject


/**
 *  根据ABRecordRef数据获得YContantObject对象
 *
 *  @param recordRef ABRecordRef对象
 *
 *  @return YContantObject对象
 */
+(YContactObject *)contantObject:(ABRecordRef)recordRef;



@end

NS_ASSUME_NONNULL_END
