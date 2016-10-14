//
//  CNMutableContact+RITLContactFile.h
//  RITLContact_Demo
//
//  Created by YueWen on 2016/10/14.
//  Copyright © 2016年 YueWen. All rights reserved.
//

#import <Contacts/Contacts.h>

@class RITLContactNameObject;
@class RITLContactPhoneObject;
@class RITLContactJobObject;
@class RITLContactEmailObject;
@class RITLContactAddressObject;
@class RITLContactInstantMessageObject;
@class RITLContactSocialProfileObject;

NS_ASSUME_NONNULL_BEGIN

@interface CNMutableContact (RITLContactFile)


//name

/**
 姓名对象的便利赋值方法

 @param nameObject 赋值的RITLContactNameObject对象
 */
- (void)nameWithNameObject:(RITLContactNameObject *)nameObject;


//phone

/**
 电话对象的便利赋值方法

 @param phoneObjects 赋值的[RITLContactPhoneObject]()
 */
- (void)phoneWithPhoneObjects:(NSArray<RITLContactPhoneObject *> *)phoneObjects;


//job

/**
 工作对象的便利赋值方法

 @param jobObject 赋值的RITLContactJobObject
 */
- (void)jobWithJobObjects:(RITLContactJobObject *)jobObject;


//emails

/**
 邮件对象的便利赋值方法

 @param emailObjects 赋值的[RITLContactEmailObject]()
 */
- (void)emailWithEmailObjects:(NSArray <RITLContactEmailObject *> *)emailObjects;


//address

/**
 地址对象的便利赋值方法

 @param addressObjects 赋值的[RITLContactAddressObject]()
 */
- (void)addressWithAddressObjects:(NSArray <RITLContactAddressObject *> *)addressObjects;


//instant

/**
 即时通讯对象的便利赋值方法

 @param instantObjects 赋值的[RITLContactInstantMessageObject]()
 */
- (void)instantWithInstantObjects:(NSArray <RITLContactInstantMessageObject *> *)instantObjects;


//social

/**
 社交对象的便利赋值方法

 @param socialObjects 赋值的[RITLContactSocialProfileObject]对象
 */
- (void)socialProfileWithSocialObjects:(NSArray <RITLContactSocialProfileObject *> *)socialObjects;


@end


@interface CNMutablePostalAddress (RITLContactFile)


/**
 根据RITLContactAddressObject对象生成的便利构造器

 @param addressObject RITLContactAddressObject对象

 @return 创建完毕的CNPostalAddress对象
 */
+ (instancetype)postalAddress:(RITLContactAddressObject *)addressObject;

@end


NS_ASSUME_NONNULL_END
