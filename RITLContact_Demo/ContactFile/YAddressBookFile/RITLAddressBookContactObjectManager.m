//
//  YContactObjectManager.m
//  YAddressBookDemo
//
//  Created by YueWen on 16/5/6.
//  Copyright © 2016年 YueWen. All rights reserved.
//

#import "RITLAddressBookContactObjectManager.h"
#import "RITLContactObject.h"
#import <objc/runtime.h>

static NSString * const RITLAddressBookContactsManager;

@implementation RITLAddressBookContactObjectManager

+(ABRecordRef)recordRef
{
    return (__bridge ABRecordRef)(objc_getAssociatedObject(self, &RITLAddressBookContactsManager));
}

+(void)setRecordRef:(ABRecordRef)recordRef
{
    objc_setAssociatedObject(self, &RITLAddressBookContactsManager, (__bridge id)(recordRef), OBJC_ASSOCIATION_ASSIGN);
}

-(void)dealloc
{
    objc_removeAssociatedObjects(self);
}

#pragma mark - public Function

+(RITLContactObject *)contantObject:(ABRecordRef)recordRef
{
    //设置当前的值
    self.recordRef = recordRef;
    
    //初始化一个YContactObject对象
    RITLContactObject * contactObject = [[RITLContactObject alloc]init];
    
    //KVC赋值
//    [contactObject setValue:[NSValue valueWithPointer:recordRef] forKey:@"recordRefValue"];
    
    //姓名对象
    contactObject.nameObject = [self __contactNameProperty];
    
    //类型
    contactObject.type = [self __contactTypeProperty];
    
    //头像
    contactObject.headImage = [self __contactHeadImagePropery];
    
    //电话对象
    contactObject.phoneObject = [self __contactPhoneProperty];
    
    //工作对象
    contactObject.jobObject = [self __contactJobProperty];
    
    //邮件对象
    contactObject.emailAddresses = [self __contactEmailProperty];
    
    //地址对象
    contactObject.addresses = [self __contactAddressProperty];
    
    //生日对象
    contactObject.brithdayObject = [self __contactBrithdayProperty];
    
    //即时通信对象
    contactObject.instantMessage = [self __contactMessageProperty];
    
    //关联对象
    contactObject.relatedNames = [self __contactRelatedNamesProperty];
    
    //社交简介
    contactObject.socialProfiles = [self __contactSocialProfilesProperty];
    
    //备注
    contactObject.note = [self __contactProperty:kABPersonNoteProperty];                                  //备注
    
    //创建时间
    contactObject.creationDate = [self __contactDateProperty:kABPersonCreationDateProperty];              //创建日期
    
    //最近一次修改的时间
    contactObject.modificationDate = [self __contactDateProperty:kABPersonModificationDateProperty];      //最近一次修改的时间
    
    return contactObject;
}



#pragma mark - private function

/**
 *  根据属性key获得NSString
 *
 *  @param property 属性key
 *
 *  @return 字符串的值
 */
+ (NSString *)__contactProperty:(ABPropertyID) property
{
    return (__bridge NSString *)(ABRecordCopyValue(self.recordRef, property));
}


/**
 *  根据属性key获得NSDate
 *
 *  @param property 属性key
 *
 *  @return NSDate对象
 */
+ (NSDate *)__contactDateProperty:(ABPropertyID) property
{
    return (__bridge NSDate *)(ABRecordCopyValue(self.recordRef, property));
}



/**
 *  获得姓名的相关属性
 */
+ (RITLContactNameObject *)__contactNameProperty
{
    
    RITLContactNameObject * nameObject = [[RITLContactNameObject alloc]init];
    
    nameObject.givenName = [self __contactProperty:kABPersonFirstNameProperty];                   //名字
    nameObject.familyName = [self __contactProperty:kABPersonLastNameProperty];                   //姓氏
    nameObject.middleName = [self __contactProperty:kABPersonMiddleNameProperty];                 //名字中的信仰名称
    nameObject.namePrefix = [self __contactProperty:kABPersonPrefixProperty];                     //名字前缀
    nameObject.nameSuffix = [self __contactProperty:kABPersonSuffixProperty];                     //名字后缀
    nameObject.nickName = [self __contactProperty:kABPersonNicknameProperty];                     //名字昵称
    nameObject.phoneticGivenName = [self __contactProperty:kABPersonFirstNamePhoneticProperty];   //名字的拼音音标
    nameObject.phoneticFamilyName = [self __contactProperty:kABPersonLastNamePhoneticProperty];   //姓氏的拼音音标
    nameObject.phoneticMiddleName = [self __contactProperty:kABPersonMiddleNamePhoneticProperty]; //英文信仰缩写字母的拼音音标
    
    return nameObject;
}


/**
 *  获得工作的相关属性
 */
+ (RITLContactJobObject *)__contactJobProperty
{
    RITLContactJobObject * jobObject = [[ RITLContactJobObject alloc]init];
    
    jobObject.organizationName = [self __contactProperty:kABPersonOrganizationProperty]; //公司(组织)名称
    jobObject.departmentName = [self __contactProperty:kABPersonDepartmentProperty];     //部门
    jobObject.jobTitle = [self __contactProperty:kABPersonJobTitleProperty];             //职位
    
    return jobObject;
}




/**
 *  获得Email对象的数组
 */
+ (NSArray <RITLContactEmailObject *> *)__contactEmailProperty
{
    //获取多值属性
    ABMultiValueRef values = ABRecordCopyValue(self.recordRef, kABPersonEmailProperty);
    
    //外传数组
    NSMutableArray <RITLContactEmailObject *> * emails = [NSMutableArray arrayWithCapacity:ABMultiValueGetCount(values)];
    
    //遍历添加
    for (NSInteger i = 0; i < ABMultiValueGetCount(values); i++)
    {
        RITLContactEmailObject * emailObject = [[RITLContactEmailObject alloc]init];
        
        emailObject.emailTitle = (__bridge NSString *)(ABAddressBookCopyLocalizedLabel(ABMultiValueCopyLabelAtIndex(values, i)));  //邮件描述
        emailObject.emailAddress = (__bridge NSString *)(ABMultiValueCopyValueAtIndex(values, i));                                 //邮件地址
        //添加
        [emails addObject:emailObject];
    }
    
    //释放资源
    CFRelease(values);
    
    return [NSArray arrayWithArray:emails];
}





/**
 *  获得Address对象的数组
 */
+ (NSArray <RITLContactAddressObject *> *)__contactAddressProperty
{
    //获取多指属性
    ABMultiValueRef values = ABRecordCopyValue(self.recordRef, kABPersonAddressProperty);
    
    //外传数组
    NSMutableArray <RITLContactAddressObject *> * addresses = [NSMutableArray arrayWithCapacity:ABMultiValueGetCount(values)];
    
    //遍历添加
    for (NSInteger i = 0; i < ABMultiValueGetCount(values); i++)
    {
        RITLContactAddressObject * addressObject = [[RITLContactAddressObject alloc]init];
        
        //赋值
        addressObject.addressTitle = (__bridge NSString *)ABAddressBookCopyLocalizedLabel((ABMultiValueCopyLabelAtIndex(values, i)));                    //地址标签
        
        //获得属性字典
        NSDictionary * dictionary = (__bridge NSDictionary *)ABMultiValueCopyValueAtIndex(values, i);
        
        //开始赋值
        addressObject.country = [dictionary valueForKey:(__bridge NSString *)kABPersonAddressCountryKey];               //国家
        addressObject.city = [dictionary valueForKey:(__bridge NSString *)kABPersonAddressCityKey];                     //城市
        addressObject.state = [dictionary valueForKey:(__bridge NSString *)kABPersonAddressStateKey];                   //省(州)
        addressObject.street = [dictionary valueForKey:(__bridge NSString *)kABPersonAddressStreetKey];                 //街道
        addressObject.postalCode = [dictionary valueForKey:(__bridge NSString *)kABPersonAddressZIPKey];                //邮编
        addressObject.ISOCountryCode = [dictionary valueForKey:(__bridge NSString *)kABPersonAddressCountryCodeKey];    //ISO国家编号
        
        //添加数据
        [addresses addObject:addressObject];
    }
    
    //释放资源
    CFRelease(values);
    
    return [NSArray arrayWithArray:addresses];
    
}





/**
 *  获得电话号码对象数组
 */
+ (NSArray <RITLContactPhoneObject *> *)__contactPhoneProperty
{
    //获得电话号码的多值对象
    ABMultiValueRef values = ABRecordCopyValue(self.recordRef, kABPersonPhoneProperty);
    
    //外传数组
    NSMutableArray <RITLContactPhoneObject *> * phones = [NSMutableArray arrayWithCapacity:ABMultiValueGetCount(values)];
    

    for (NSInteger i = 0; i < ABMultiValueGetCount(values); i++)
    {
        RITLContactPhoneObject * phoneObject = [[RITLContactPhoneObject alloc]init];
        
        //开始赋值
        phoneObject.phoneTitle = (__bridge NSString *)ABAddressBookCopyLocalizedLabel(ABMultiValueCopyLabelAtIndex(values, i)); //电话描述(如住宅、工作..)
        phoneObject.phoneNumber = (__bridge NSString *)ABMultiValueCopyValueAtIndex(values, i);                                 //电话号码
         
        //添加数据
        [phones addObject:phoneObject];
    }
    
    //释放资源
    CFRelease(values);

    return [NSArray arrayWithArray:phones];
}




/**
 *  获得联系人的头像图片
 */
+ (UIImage *)__contactHeadImagePropery
{
    //首先判断是否存在头像
    if (ABPersonHasImageData(self.recordRef) == false)//没有头像，返回nil
    {
        return nil;
    }
    
    //开始获得头像信息
    NSData * imageData = (__bridge NSData *)(ABPersonCopyImageData(self.recordRef));
    
    //获得头像原图
//    NSData * imageData = CFBridgingRelease(ABPersonCopyImageDataWithFormat(self.recordRef, kABPersonImageFormatOriginalSize));
    
    return [UIImage imageWithData:imageData];
}




/**
 *  获得生日的相关属性
 */
+ (RITLContactBrithdayObject *)__contactBrithdayProperty
{
    //实例化对象
    RITLContactBrithdayObject * brithdayObject = [[RITLContactBrithdayObject alloc]init];
    
    //生日的日历
    brithdayObject.brithdayDate = [self __contactDateProperty:kABPersonBirthdayProperty];         //生日的时间对象
    
    //获得农历日历属性的字典
    NSDictionary * brithdayDictionary = (__bridge NSDictionary *)(ABRecordCopyValue(self.recordRef, kABPersonAlternateBirthdayProperty));
    
    //农历日历的属性，设置为农历属性的时候，此字典存在数值
    if (brithdayDictionary != nil)
    {
        
        brithdayObject.calendar = [brithdayDictionary valueForKey:@"calendar"];                                 //农历生日的标志位,比如“chinese”
        
        //农历生日的相关存储属性
        brithdayObject.era = [(NSNumber *)[brithdayDictionary valueForKey:@"era"] integerValue];                //纪元
        brithdayObject.year = [(NSNumber *)[brithdayDictionary valueForKey:@"year"] integerValue];              //年份,六十组干支纪年的索引数，比如12年为壬辰年，为循环的29,此数字为29

        brithdayObject.month = [(NSNumber *)[brithdayDictionary valueForKey:@"month"] integerValue];            //月份
        brithdayObject.leapMonth = [(NSNumber *)[brithdayDictionary valueForKey:@"isLeapMonth"] boolValue];     //是否是闰月
        brithdayObject.day = [(NSNumber *)[brithdayDictionary valueForKey:@"day"] integerValue];                //日期
        
    }

    //返回对象
    return brithdayObject;
}




/**
 *  获得联系人类型信息
 */
+ (RITLContactType)__contactTypeProperty
{
    //获得类型属性
    CFNumberRef typeIndex = ABRecordCopyValue(self.recordRef, kABPersonKindProperty);
    
    //表示是公司联系人
    if (CFNumberCompare(typeIndex, kABPersonKindOrganization, nil) == kCFCompareEqualTo)
    {
        //释放资源
        CFRelease(typeIndex);
        
        return RITLContactTypeOrigination;
    }
    
    return RITLContactTypePerson;
}



/**
 *  获得即时通信账号相关信息
 */
+ (NSArray <RITLContactInstantMessageObject *> *)__contactMessageProperty
{
    //获取数据字典
    ABMultiValueRef messages = ABRecordCopyValue(self.recordRef, kABPersonInstantMessageProperty);
    
    //存放数组
    NSMutableArray <RITLContactInstantMessageObject *> * instantMessages = [NSMutableArray arrayWithCapacity:ABMultiValueGetCount(messages)];
    
    //遍历获取值
    for (NSInteger i = 0; i < ABMultiValueGetCount(messages); i++)
    {
        //获取属性字典
        NSDictionary * messageDictionary = CFBridgingRelease(ABMultiValueCopyValueAtIndex(messages, i));
        
        //实例化
        RITLContactInstantMessageObject * instantMessageObject = [[RITLContactInstantMessageObject alloc]init];
        
        instantMessageObject.service = [messageDictionary valueForKey:@"service"];          //服务名称(如QQ)
        instantMessageObject.userName = [messageDictionary valueForKey:@"username"];        //服务账号(如QQ号)
        
        //添加
        [instantMessages addObject:instantMessageObject];
    }

    return [NSArray arrayWithArray:instantMessages];
}



/**
 *  获得联系人的关联人信息
 */
+ (NSArray <RITLContactRelatedNamesObject *> *)__contactRelatedNamesProperty
{
    //获得多值属性
    ABMultiValueRef names = ABRecordCopyValue(self.recordRef, kABPersonRelatedNamesProperty);
    
    //存放数组
    NSMutableArray <RITLContactRelatedNamesObject *> * relatedNames = [NSMutableArray arrayWithCapacity:ABMultiValueGetCount(names)];
    
    //遍历赋值
    for (NSInteger i = 0; i < ABMultiValueGetCount(names); i++)
    {
        //初始化
        RITLContactRelatedNamesObject * relatedName = [[RITLContactRelatedNamesObject alloc]init];
        
        //赋值
        relatedName.relatedTitle = CFBridgingRelease(ABAddressBookCopyLocalizedLabel(ABMultiValueCopyLabelAtIndex(names, i))); //关联的标签(如friend)
        relatedName.relatedName = CFBridgingRelease(ABMultiValueCopyValueAtIndex(names, i));                                    //关联的名称(如联系人姓名)
        
        //添加
        [relatedNames addObject:relatedName];
    }
    
    return [NSArray arrayWithArray:relatedNames];
}



/**
 *  获得联系人的社交简介信息
 */
+ (NSArray <RITLContactSocialProfileObject *> *)__contactSocialProfilesProperty
{
    //获得多值属性
    ABMultiValueRef profiles = ABRecordCopyValue(self.recordRef, kABPersonSocialProfileProperty);
    
    //外传数组
    NSMutableArray <RITLContactSocialProfileObject *> * socialProfiles = [NSMutableArray arrayWithCapacity:ABMultiValueGetCount(profiles)];
    
    //遍历取值
    for (NSInteger i = 0; i < ABMultiValueGetCount(profiles); i++)
    {
        //初始化对象
        RITLContactSocialProfileObject * socialProfileObject = [[RITLContactSocialProfileObject alloc]init];
        
        //获取属性值
        NSDictionary * profileDictionary = CFBridgingRelease(ABMultiValueCopyValueAtIndex(profiles, i));
        
        //开始赋值
        socialProfileObject.socialProfileTitle = [profileDictionary valueForKey:@"service"];    //社交简介(如sinaweibo)
        socialProfileObject.socialProFileAccount = [profileDictionary valueForKey:@"username"]; //社交地址(如123456)
        socialProfileObject.socialProFileUrl = [profileDictionary valueForKey:@"url"];          //社交链接的地址(按照上面两项自动为http://weibo.com/n/123456)
        
        //添加
        [socialProfiles addObject:socialProfileObject];   
    }
    return [NSArray arrayWithArray:socialProfiles];
}
@end



@implementation RITLAddressBookContactObjectManager (ABRecordRef)

+(ABRecordRef)recordRef:(RITLContactObject *)contactObject
{
    //实例化ABRecordRef
    ABRecordRef recordRef = ABPersonCreate();

    //set value
    [self __nameObject:recordRef object:contactObject];
    [self __contactType:recordRef object:contactObject];
    [self __headImage:recordRef object:contactObject];
    [self __contactPhone:recordRef object:contactObject];
    [self __contactJob:recordRef object:contactObject];
    [self __contactEmail:recordRef object:contactObject];
    [self __contactAddress:recordRef object:contactObject];
    [self __contactBrithday:recordRef object:contactObject];
    
    return recordRef;
}



/**
 添加姓名属性

 @param recordRef   ABRecordRef数据
 @param contact     添加的RITLContactObject对象
 */
+ (BOOL)__nameObject:(ABRecordRef)recordRef object:(RITLContactObject *)contact
{
    CFErrorRef error = NULL;
    
    //获得名字对象
    RITLContactNameObject * nameObject = contact.nameObject;
    
    /*添加联系人姓名属性*/
    ABRecordSetValue(recordRef, kABPersonFirstNameProperty, (__bridge CFTypeRef)(nameObject.givenName), &error);       //名字
    ABRecordSetValue(recordRef, kABPersonLastNameProperty, (__bridge CFStringRef)(nameObject.familyName), &error);        //姓氏
    ABRecordSetValue(recordRef, kABPersonMiddleNameProperty,(__bridge CFStringRef)(nameObject.middleName), &error);        //名字中的信仰名称（比如Jane·K·Frank中的K
    ABRecordSetValue(recordRef, kABPersonPrefixProperty,(__bridge CFStringRef)(nameObject.namePrefix), &error);             //名字前缀
    ABRecordSetValue(recordRef, kABPersonSuffixProperty,(__bridge CFStringRef)(nameObject.nameSuffix), &error);             //名字后缀
    ABRecordSetValue(recordRef, kABPersonNicknameProperty,(__bridge CFStringRef)(nameObject.nickName), &error);            //名字昵称
    ABRecordSetValue(recordRef, kABPersonFirstNamePhoneticProperty,(__bridge CFStringRef)(nameObject.phoneticGivenName), &error);//名字的拼音音标
    ABRecordSetValue(recordRef, kABPersonLastNamePhoneticProperty,(__bridge CFStringRef)(nameObject.phoneticFamilyName), &error); //姓氏的拼音音标
    ABRecordSetValue(recordRef, kABPersonMiddleNamePhoneticProperty,(__bridge CFStringRef)(nameObject.phoneticMiddleName), &error); //英文信仰缩写字母的拼音音标
    
    return [self __errorExit:error];
}



/**
 添加类型属性

 @param recordRef ABRecordRef数据
 @param contact   添加的RITLContactObject对象
 */
+(BOOL)__contactType:(ABRecordRef)recordRef object:(RITLContactObject *)contact
{
    CFErrorRef error = NULL;
    
    CFNumberRef type = (contact.type == RITLContactTypePerson ? kABPersonKindPerson:kABPersonKindOrganization);
    
    /*添加联系人类型属性*/
    ABRecordSetValue(recordRef, kABPersonKindProperty, type, &error);      //设置为个人类型
    
    CFRelease(type);

    return [self __errorExit:error];
}


/**
 添加头像属性
 
 @param recordRef ABRecordRef数据
 @param contact   添加的RITLContactObject对象
 */
+(BOOL)__headImage:(ABRecordRef)recordRef object:(RITLContactObject *)contact
{
    CFErrorRef error = NULL;
    
    ABPersonSetImageData(recordRef, (__bridge CFDataRef)(UIImagePNGRepresentation(contact.headImage)),&error);//设置联系人头像
    
    return [self __errorExit:error];
}

/**
 添加电话属性
 
 @param recordRef ABRecordRef数据
 @param contact   添加的RITLContactObject对象
 */
+(BOOL)__contactPhone:(ABRecordRef)recordRef object:(RITLContactObject *)contact
{
    CFErrorRef error = NULL;
    ABMultiValueRef phoneMultiValue = ABMultiValueCreateMutable(kABMultiStringPropertyType);
    
    
    for (RITLContactPhoneObject * phoneObject in contact.phoneObject)
    {
        ABMultiValueIdentifier identifier;
        
        ABMultiValueAddValueAndLabel(phoneMultiValue, (__bridge CFStringRef)(phoneObject.phoneNumber), (__bridge CFStringRef)(phoneObject.phoneTitle), &identifier);//自定义标签
    }
    
    ABRecordSetValue(recordRef, kABPersonPhoneProperty, phoneMultiValue, &error);
    
    CFRelease(phoneMultiValue);
    
    return  [self __errorExit:error];
}

/**
 添加工作信息属性
 
 @param recordRef ABRecordRef数据
 @param contact   添加的RITLContactObject对象
 */
+(BOOL)__contactJob:(ABRecordRef)recordRef object:(RITLContactObject *)contact
{
    CFErrorRef error = NULL;
    
    ABRecordSetValue(recordRef, kABPersonOrganizationProperty, (__bridge CFStringRef)(contact.jobObject.organizationName), &error);//公司(组织)名称
    ABRecordSetValue(recordRef, kABPersonDepartmentProperty, (__bridge CFStringRef)(contact.jobObject.departmentName), &error);  //部门
    ABRecordSetValue(recordRef, kABPersonJobTitleProperty, (__bridge CFStringRef)(contact.jobObject.jobTitle), &error);    //职位
    
    return [self __errorExit:error];
}



/**
 添加Email信息属性
 
 @param recordRef ABRecordRef数据
 @param contact   添加的RITLContactObject对象
 */
+(BOOL)__contactEmail:(ABRecordRef)recordRef object:(RITLContactObject *)contact
{
    CFErrorRef error = NULL;
    
    //实例化多值属性
    ABMultiValueRef emailMultiValue = ABMultiValueCreateMutable(kABMultiStringPropertyType);

    
    for (RITLContactEmailObject * emailObject in contact.emailAddresses)
    {
        ABMultiValueIdentifier identifier;
        
        ABMultiValueAddValueAndLabel(emailMultiValue, (__bridge CFStringRef)(emailObject.emailAddress), (__bridge CFStringRef)(emailObject.emailTitle),&identifier);
    }

    //添加属性
    ABRecordSetValue(recordRef, kABPersonEmailProperty, emailMultiValue, &error);

    //释放资源
    CFRelease(emailMultiValue);
    
    return [self __errorExit:error];
}


/**
 添加地址信息属性
 
 @param recordRef ABRecordRef数据
 @param contact   添加的RITLContactObject对象
 */
+(BOOL)__contactAddress:(ABRecordRef)recordRef object:(RITLContactObject *)contact
{
    CFErrorRef error = NULL;
    
    ABMultiValueRef addressMultiValue = ABMultiValueCreateMutable(kABMultiDictionaryPropertyType);


    //初始化字典属性
    CFMutableDictionaryRef addressDictionaryRef = CFDictionaryCreateMutable(kCFAllocatorSystemDefault, 0, NULL, NULL);

    for (RITLContactAddressObject * addressObject in contact.addresses)
    {
        ABMultiValueIdentifier identifier;
        
        //进行添加
        CFDictionaryAddValue(addressDictionaryRef, kABPersonAddressCountryKey, (__bridge CFStringRef)(addressObject.country));      //国家
        CFDictionaryAddValue(addressDictionaryRef, kABPersonAddressCityKey, (__bridge CFStringRef)(addressObject.city));       //城市
        CFDictionaryAddValue(addressDictionaryRef, kABPersonAddressStateKey, (__bridge CFStringRef)(addressObject.state));    //省(区)
        CFDictionaryAddValue(addressDictionaryRef, kABPersonAddressStreetKey, (__bridge CFStringRef)(addressObject.street));      //街道
        CFDictionaryAddValue(addressDictionaryRef, kABPersonAddressZIPKey, (__bridge CFStringRef)(addressObject.postalCode));         //邮编
        CFDictionaryAddValue(addressDictionaryRef, kABPersonAddressCountryCodeKey, (__bridge CFStringRef)(addressObject.ISOCountryCode));    //ISO国家编码
        
        //添加属性
        ABMultiValueAddValueAndLabel(addressMultiValue, addressDictionaryRef, (__bridge CFStringRef)(addressObject.addressTitle), &identifier);
    }
    
    ABRecordSetValue(recordRef, kABPersonAddressProperty, addressMultiValue, &error);

    //释放资源
    CFRelease(addressMultiValue);
    
    return [self __errorExit:error];
}


/**
 添加生日信息属性
 
 @param recordRef ABRecordRef数据
 @param contact   添加的RITLContactObject对象
 */
+(BOOL)__contactBrithday:(ABRecordRef)recordRef object:(RITLContactObject *)contact
{
    CFErrorRef error = NULL;
    
    ABRecordSetValue(recordRef, kABPersonBirthdayProperty, (__bridge CFTypeRef)(contact.brithdayObject.brithdayDate), &error);
    
    return [self __errorExit:error];
}



/**
 错误数据通用处理

 @param error 错误数据

 @return 是否存在错误
 */
+ (BOOL)__errorExit:(CFErrorRef)error
{
    if (error != NULL)
    {
        NSLog(@"error = %@",error);
        CFRelease(error);
        return false;
    }
    
    return true;
}

@end
