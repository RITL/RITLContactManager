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
 针对addressBook进行请求数据的类
 */
NS_CLASS_DEPRECATED_IOS(2_0, 9_0,"") @interface RITLAddressBookContactManager : NSObject


/**
 获得单例对象

 @return RITLAddressBookContactManager单例对象
 */
+(instancetype)sharedInstance;



/**
 *  请求所有的联系人,按照添加人的时间顺序
 *
 *  @param completeBlock 完成的回调
 */
- (void)requestContactsComplete:(void (^)(NSArray <RITLContactObject *> *))completeBlock;


@end

NS_ASSUME_NONNULL_END
