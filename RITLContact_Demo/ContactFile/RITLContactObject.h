//
//  YContactObject.h
//  YAddressBookDemo
//
//  Created by YueWen on 16/5/6.
//  Copyright © 2016年 YueWen. All rights reserved.
//

@import Foundation;
@import AddressBook;
@import UIKit;

@class RITLContactNameObject;
@class RITLContactPhoneObject;
@class RITLContactJobObject;
@class RITLContactEmailObject;
@class RITLContactAddressObject;
@class RITLContactBrithdayObject;
@class RITLContactInstantMessageObject;
@class RITLContactRelatedNamesObject;
@class RITLContactSocialProfileObject;

NS_ASSUME_NONNULL_BEGIN

/**
 联系人的类型
 */
typedef NS_ENUM(NSUInteger,RITLContactType)
{
    RITLContactTypePerson = 0,         /**<个人联系人*/
    RITLContactTypeOrigination = 1,    /**<公司联系人*/
    RITLContactTypeUnknown = 2,        /**<类型未知*/
};


/**
 *  联系人对象
 */
NS_CLASS_AVAILABLE_IOS(7_0) @interface RITLContactObject : NSObject
/**
 对象的标志位
 */
@property (nonatomic, copy) NSString * identifier NS_AVAILABLE_IOS(9_0);
/**
 *  联系人的姓名对象
 */
@property (nonatomic, strong)RITLContactNameObject * nameObject;
/**
 是否存在多个电话
 */
@property (nonatomic, assign, readonly) BOOL hasMulitPhone;
/**
 *  联系人的电话对象
 */
@property (nonatomic, copy)NSArray <RITLContactPhoneObject *> * phoneObject;
/**
 *  联系人的类型
 */
@property (nonatomic, assign)RITLContactType type;
/**
 *  联系人的头像
 */
@property (nonatomic, strong)UIImage * headImage;
/**
 *  联系人的工作对象
 */
@property (nonatomic, strong)RITLContactJobObject * jobObject;
/**
 *  联系人的邮箱地址
 */
@property (nonatomic, copy) NSArray <RITLContactEmailObject *> * emailAddresses;
/**
 *  联系人的生日对象
 */
@property (nonatomic, strong)RITLContactBrithdayObject * brithdayObject;
/**
 *  备注
 */
@property (nonatomic, copy) NSString * note;
/**
 *  创建日期
 */
@property (nonatomic, strong) NSDate * creationDate NS_DEPRECATED_IOS(7_0, 9_0);
/**
 *  最近一次修改的时间
 */
@property (nonatomic, strong) NSDate * modificationDate NS_DEPRECATED_IOS(7_0, 9_0);
/**
 *  联系人的地址对象
 */
@property (nonatomic, copy) NSArray <RITLContactAddressObject *> * addresses;
/**
 *  联系人的即时工具
 */
@property (nonatomic, copy) NSArray <RITLContactInstantMessageObject *> * instantMessage;
/**
 *  联系人的关联对象
 */
@property (nonatomic, copy) NSArray <RITLContactRelatedNamesObject *> * relatedNames;
/**
 *  联系人的社交简介
 */
@property (nonatomic, copy) NSArray <RITLContactSocialProfileObject *> * socialProfiles;


@end










/**
 *  联系人的名字信息
 */
NS_CLASS_AVAILABLE_IOS(2_0) @interface RITLContactNameObject : NSObject
/**
 *  姓名
 */
@property (nonatomic, copy)NSString * name;
/**
 *  昵称
 */
@property (nonatomic, copy) NSString * nickName;
/**
 *  名字
 */
@property (nonatomic, copy) NSString * givenName;
/**
 *  姓氏
 */
@property (nonatomic, copy) NSString * familyName;
/**
 *  英文名字中间存的信仰缩写字母(X·Y·Z的Y)
 */
@property (nonatomic, copy) NSString * middleName;
/**
 *  名字的前缀
 */
@property (nonatomic, copy) NSString * namePrefix;
/**
 *  名字的后缀
 */
@property (nonatomic, copy) NSString * nameSuffix;

#pragma 以下属性是语音属性
/**
 *  名字的拼音或音标
 */
@property (nonatomic, copy) NSString * phoneticGivenName;
/**
 *  姓氏的拼音或音标
 */
@property (nonatomic, copy) NSString * phoneticFamilyName;
/**
 *  中间名的拼音或音标
 */
@property (nonatomic, copy) NSString * phoneticMiddleName;
/**
 公司名字拼音
 */
@property (nonatomic, copy) NSString * phoneticOrganizationName NS_AVAILABLE_IOS(10_0);

@end










/**
 *  联系人的工作对象
 */
NS_CLASS_AVAILABLE_IOS(2_0) @interface RITLContactJobObject : NSObject
/**
 *  公司(组织)
 */
@property (nonatomic, copy) NSString * organizationName;
/**
 *  部门
 */
@property (nonatomic, copy) NSString * departmentName;
/**
 *  职位
 */
@property (nonatomic, copy) NSString * jobTitle;

@end








/**
 *  联系人的Email对象
 */
NS_CLASS_AVAILABLE_IOS(2_0) @interface RITLContactEmailObject : NSObject
/**
 *  邮件的描述(如住宅、iCloud..)
 */
@property (nonatomic, copy)NSString * emailTitle;
/**
 *  邮件的地址(如....@iCloud.cn)
 */
@property (nonatomic, copy)NSString * emailAddress;

@end










/**
 *  联系人的电话对象
 */
NS_CLASS_AVAILABLE_IOS(2_0) @interface RITLContactPhoneObject : NSObject
/**
 *  电话描述(如住宅，工作..)
 */
@property (nonatomic, copy)NSString * phoneTitle;
/**
 *  电话号码
 */
@property (nonatomic, copy)NSString * phoneNumber;


@end










/**
 *  联系人的地址信息
 */
NS_CLASS_AVAILABLE_IOS(2_0) @interface RITLContactAddressObject : NSObject

/**
 *  地址的标签(比如住宅、工作...)
 */
@property (nonatomic, copy)NSString * addressTitle;

/**
 *  街道
 */
@property (nonatomic, copy)NSString * street;

/**
 *  城市
 */
@property (nonatomic, copy)NSString * city;

/**
 *  省(州)
 */
@property (nonatomic, copy)NSString * state;

/**
 *  邮编
 */
@property (nonatomic, copy)NSString * postalCode;

/**
 *  国家
 */
@property (nonatomic, copy)NSString * country;

/**
 *  ISO国家编号
 */
@property (nonatomic, copy)NSString * ISOCountryCode;
/**
 地址的描述字符串，eg 中国 山东 潍坊 XX 261800
 */
@property (nonatomic, copy)NSString * formattedAddress NS_AVAILABLE_IOS(9_0);

@end










/**
 *  联系人的生日对象
 */
NS_CLASS_AVAILABLE_IOS(2_0) @interface RITLContactBrithdayObject : NSObject
/**
 *  生日日历的识别码
 */
@property (nonatomic, strong) NSDate * brithdayDate;


/******************农历生日的属性*****************/

/**
 *  农历生日的标志位,比如“chinese”
 */
@property (nonatomic, copy) NSString * calendar;
/**
 *  纪元
 */
@property (nonatomic, assign) NSInteger era;
/**
 *  年份,六十组干支纪年的索引数，比如12年为壬辰年，为循环的29,此数字为29
 */
@property (nonatomic, assign) NSInteger year;
/**
 *  月份
 */
@property (nonatomic, assign) NSInteger month;
/**
 *  是否是闰月
 */
@property (nonatomic, assign, getter=isLeapMonth) BOOL leapMonth;
/**
 *  日期
 */
@property (nonatomic, assign)NSInteger day;

@end










/**
 *  联系人的即时通信对象
 */
NS_CLASS_AVAILABLE_IOS(2_0) @interface RITLContactInstantMessageObject : NSObject

/**
 标识符
 */
@property (nonatomic, copy, nullable)NSString * identifier NS_AVAILABLE_IOS(9_0);
/**
 *  服务名称(如QQ)
 */
@property (nonatomic, copy)NSString * service;
/**
 *  服务账号(如QQ号)
 */
@property (nonatomic, copy)NSString * userName;

@end










/**
 *  联系人的关联对象
 */
NS_CLASS_AVAILABLE_IOS(2_0) @interface RITLContactRelatedNamesObject : NSObject

/**
 标志符
 */
@property (nonatomic, copy)NSString * identifier NS_AVAILABLE_IOS(9_0);
/**
 *  关联的标签(如friend)
 */
@property (nonatomic, copy)NSString * relatedTitle;
/**
 *  关联的名称(如联系人姓名)
 */
@property (nonatomic, copy)NSString * relatedName;

@end






/**
 *  联系人的社交简介对象
 */
NS_CLASS_AVAILABLE_IOS(7_0) @interface RITLContactSocialProfileObject : NSObject

/**
 标识符
 */
@property (nonatomic, copy)NSString * identifier NS_AVAILABLE_IOS(9_0);
/**
 *  社交简介(如sinaweibo)
 */
@property (nonatomic, copy)NSString * socialProfileTitle;
/**
 *  社交地址(123456)
 */
@property (nonatomic, copy)NSString * socialProFileAccount;
/**
 *  社交链接的地址(按照上面两项自动为http://weibo.com/n/123456)
 */
@property (nonatomic, copy)NSString * socialProFileUrl;

@end




/**
 将联系人分组排序的类
 */
@interface RITLContactSortManager : NSObject


/**
 按照默认的keyPath分成A~#的数组

 @param contactObjects 存放RITLContactObject对象的数组

 @return 处理完毕数组
 */
+(NSArray<NSArray <RITLContactObject * > *> *)defaultHandleContactObject:(NSArray <RITLContactObject *> *)contactObjects;




/**
 将存放RITLContactObject对象的数组按照keyPath分成A~#的数组

 @param contactObjects     存放RITLContactObject对象的数组
 @param keyPath            分组的依据
 @param sortInGroupkeyPath 组内排序依据

 @return 处理完毕的数组
 */
+(NSArray<NSArray <RITLContactObject * > *> *)handleContactObjects:(NSArray <RITLContactObject *> *)contactObjects
                                                 groupingByKeyPath:(NSString *)keyPath
                                                sortInGroupKeyPath:(NSString *)sortInGroupkeyPath;

@end


NS_ASSUME_NONNULL_END
