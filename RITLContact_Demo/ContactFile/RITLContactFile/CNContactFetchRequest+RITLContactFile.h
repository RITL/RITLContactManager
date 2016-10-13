//
//  CNContactFetchRequest+RITLContactFile.h
//  RITLContact_Demo
//
//  Created by YueWen on 2016/10/11.
//  Copyright © 2016年 YueWen. All rights reserved.
//

#import <Contacts/Contacts.h>

NS_ASSUME_NONNULL_BEGIN

@interface CNContactFetchRequest (RITLContactFile)


/**
 获得联系人所有key的请求的便利初始化方法

 @return CNContactFetchRequest对象
 */
+(CNContactFetchRequest *)descriptorForAllKeys;

@end



NS_ASSUME_NONNULL_END
