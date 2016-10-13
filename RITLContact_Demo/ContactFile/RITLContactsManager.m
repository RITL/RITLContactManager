//
//  YContactsManager.m
//  YAddressBookDemo
//
//  Created by YueWen on 16/5/6.
//  Copyright © 2016年 YueWen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RITLContactsManager.h"
#import "RITLContacts.h"

#ifdef ContactFrameworkIsAvailable
#import "RITLContactManager.h"
#else
#import "RITLAddressBookContactManager.h"
#endif



@interface RITLContactsManager ()

#ifndef ContactFrameworkIsAvailable
/**
 负责针对AddressBook进行数据请求的类
 */
@property (nonatomic, strong) RITLAddressBookContactManager * addressBookContactManager;

#else
/**
 负责针对Contact进行数据请求的类
 */
@property (nonatomic, strong) RITLContactManager * contactManager NS_AVAILABLE_IOS(9_0);

#endif

@end



@implementation RITLContactsManager


-(instancetype)init
{
    if (self = [super init])
    {
#ifndef ContactFrameworkIsAvailable
        if (!isAvailableContactFramework)
        {
          self.addressBookContactManager = [[RITLAddressBookContactManager alloc]init];
        }
#else
        self.contactManager = [[RITLContactManager alloc]init];
#endif
        
    }
    
    return self;
}


-(void)dealloc
{
    NSLog(@"%@ dealloc",NSStringFromClass([self class]));
}



#pragma mark - 请求通讯录
//请求通讯录
-(void)requestContactsComplete:(void (^)(NSArray<RITLContactObject *> * _Nonnull))completeBlock defendBlock:(nonnull void (^)(void))defendBlock
{
    [self requestContactsType:ContactsTypeDefault Complete:completeBlock defendBlock:defendBlock];
}


-(void)requestContactsType:(ContactsType)contactType Complete:(void (^)(NSArray<RITLContactObject *> * _Nonnull))completeBlock defendBlock:(void (^)(void))defendBlock
{

#ifndef ContactFrameworkIsAvailable
    
    if (!isAvailableContactFramework)
    {
        //change Block
        self.addressBookContactManager.addressBookDidChange = self.contactDidChange;
        
        //如果是addressBook
        [self.addressBookContactManager requestContactsComplete:^(NSArray<RITLContactObject *> * _Nonnull contacts) {
            
            completeBlock(contacts);
            
        } defendBlock:^{
            
            defendBlock();
            
        }];
    }
    
#else
    //如果是contact
    self.contactManager.descriptors = self.descriptors;
    self.contactManager.contactDidChange = self.contactDidChange;
    
    [self.contactManager requestContactsComplete:^(NSArray<RITLContactObject *> * _Nonnull contacts) {
        
        completeBlock(contacts);
        
    } defendBlock:^{
        
        defendBlock();
        
    }];
    
#endif
}

@end


@implementation RITLContactsManager (RITLAddContact)

-(void)addContact:(RITLContactObject *)contact
{
#ifndef ContactFrameworkIsAvailable
    [self.addressBookContactManager addContact:contact];
#else
    [self.contactManager addContact:contact];
#endif
}


///**
// *  添加联系人姓名属性
// */
//- (void)codingAddPersonToAddressBook
//{
//    //实例化一个Person数据
//    ABRecordRef person = ABPersonCreate();
//    ABAddressBookRef addressBook = ABAddressBookCreate();
//
//    //实例化一个CFErrorRef属性
//    CFErrorRef error = NULL;
//
//
//
//#pragma mark - 添加联系人姓名属性
//    /*添加联系人姓名属性*/
//    ABRecordSetValue(person, kABPersonFirstNameProperty, (__bridge CFStringRef)@"Wen", &error);       //名字
//    ABRecordSetValue(person, kABPersonLastNameProperty, (__bridge CFStringRef)@"Yue", &error);        //姓氏
//    ABRecordSetValue(person, kABPersonMiddleNameProperty,(__bridge CFStringRef)@"YW", &error);        //名字中的信仰名称（比如Jane·K·Frank中的K
//    ABRecordSetValue(person, kABPersonPrefixProperty,(__bridge CFStringRef)@"W", &error);             //名字前缀
//    ABRecordSetValue(person, kABPersonSuffixProperty,(__bridge CFStringRef)@"Y", &error);             //名字后缀
//    ABRecordSetValue(person, kABPersonNicknameProperty,(__bridge CFStringRef)@"", &error);            //名字昵称
//    ABRecordSetValue(person, kABPersonFirstNamePhoneticProperty,(__bridge CFStringRef)@"Wen", &error);//名字的拼音音标
//    ABRecordSetValue(person, kABPersonLastNamePhoneticProperty,(__bridge CFStringRef)@"Yue", &error); //姓氏的拼音音标
//    ABRecordSetValue(person, kABPersonMiddleNamePhoneticProperty,(__bridge CFStringRef)@"Y", &error); //英文信仰缩写字母的拼音音标
//
//
//
//
//
//#pragma mark - 添加联系人类型属性
//    /*添加联系人类型属性*/
//    ABRecordSetValue(person, kABPersonKindProperty, kABPersonKindPerson, &error);      //设置为个人类型
//    ABRecordSetValue(person, kABPersonKindProperty, kABPersonKindOrganization, &error);//设置为公司类型
//
//
//
//
//
//#pragma mark - 添加联系人头像属性
//    /*添加联系人头像属性*/
//    ABPersonSetImageData(person, (__bridge CFDataRef)(UIImagePNGRepresentation([UIImage imageNamed:@""])),&error);//设置联系人头像
//
//
//
//
//
//#pragma mark - 添加联系人电话信息
//    /*添加联系人电话信息*/
//    //实例化一个多值属性
//    ABMultiValueRef phoneMultiValue = ABMultiValueCreateMutable(kABMultiStringPropertyType);
//
//    //设置相关标志位,也可以不设置，下面的方法写NULL即可
//    ABMultiValueIdentifier MobileIdentifier;    //手机
//    ABMultiValueIdentifier iPhoneIdentifier;    //iPhone
//    ABMultiValueIdentifier MainIdentifier;      //主要
//    ABMultiValueIdentifier HomeFAXIdentifier;   //家中传真
//    ABMultiValueIdentifier WorkFAXIdentifier;   //工作传真
//    ABMultiValueIdentifier OtherFAXIdentifier;  //其他传真
//    ABMultiValueIdentifier PagerIdentifier;     //传呼
//
//    //设置相关数值
//    ABMultiValueAddValueAndLabel(phoneMultiValue, (__bridge CFStringRef)@"5551211", kABPersonPhoneMobileLabel, &MobileIdentifier);    //手机
//    ABMultiValueAddValueAndLabel(phoneMultiValue, (__bridge CFStringRef)@"5551212", kABPersonPhoneIPhoneLabel, &iPhoneIdentifier);    //iPhone
//    ABMultiValueAddValueAndLabel(phoneMultiValue, (__bridge CFStringRef)@"5551213", kABPersonPhoneMainLabel, &MainIdentifier);        //主要
//    ABMultiValueAddValueAndLabel(phoneMultiValue, (__bridge CFStringRef)@"5551214", kABPersonPhoneHomeFAXLabel, &HomeFAXIdentifier);  //家中传真
//    ABMultiValueAddValueAndLabel(phoneMultiValue, (__bridge CFStringRef)@"5551215", kABPersonPhoneWorkFAXLabel, &WorkFAXIdentifier);  //工作传真
//    ABMultiValueAddValueAndLabel(phoneMultiValue, (__bridge CFStringRef)@"5551216", kABPersonPhoneOtherFAXLabel, &OtherFAXIdentifier);//其他传真
//    ABMultiValueAddValueAndLabel(phoneMultiValue, (__bridge CFStringRef)@"5551217", kABPersonPhonePagerLabel, &PagerIdentifier);      //传呼
//
//    //自定义标签
//    ABMultiValueAddValueAndLabel(phoneMultiValue, (__bridge CFStringRef)@"55512118", (__bridge CFStringRef)@"自定义", &PagerIdentifier);//自定义标签
//
//    //添加属性
//    ABRecordSetValue(person, kABPersonPhoneProperty, phoneMultiValue, &error);
//
//    //释放资源
//    CFRelease(phoneMultiValue);
//
//
//#pragma mark - 添加联系人的工作信息
//    /*添加联系人的工作信息*/
//    ABRecordSetValue(person, kABPersonOrganizationProperty, (__bridge CFStringRef)@"OYue", &error);//公司(组织)名称
//    ABRecordSetValue(person, kABPersonDepartmentProperty, (__bridge CFStringRef)@"DYue", &error);  //部门
//    ABRecordSetValue(person, kABPersonJobTitleProperty, (__bridge CFStringRef)@"JYue", &error);    //职位
//
//    
//    
//    
//#pragma mark - 添加联系人的邮件信息
//    /*添加联系人的邮件信息*/
//    //实例化多值属性
//    ABMultiValueRef emailMultiValue = ABMultiValueCreateMutable(kABMultiStringPropertyType);
//
//    //设置相关标志位
//    ABMultiValueIdentifier QQIdentifier;//QQ
//
//    //进行赋值
//    //设置自定义的标签以及值
//    ABMultiValueAddValueAndLabel(emailMultiValue, (__bridge CFStringRef)@"77xxxxx48@qq.com", (__bridge CFStringRef)@"QQ", &QQIdentifier);
//
//    //添加属性
//    ABRecordSetValue(person, kABPersonEmailProperty, emailMultiValue, &error);
//
//    //释放资源
//    CFRelease(emailMultiValue);
//    
// 
//    
//    
//    
//    
//    
//    
//#pragma mark -  添加联系人的地址信息
//    /*添加联系人的地址信息*/
//    //实例化多值属性
//    ABMultiValueRef addressMultiValue = ABMultiValueCreateMutable(kABMultiDictionaryPropertyType);
//
//    //设置相关标志位
//    ABMultiValueIdentifier AddressIdentifier;
//
//    //初始化字典属性
//    CFMutableDictionaryRef addressDictionaryRef = CFDictionaryCreateMutable(kCFAllocatorSystemDefault, 0, NULL, NULL);
//
//    //进行添加
//    CFDictionaryAddValue(addressDictionaryRef, kABPersonAddressCountryKey, (__bridge CFStringRef)@"China");      //国家
//    CFDictionaryAddValue(addressDictionaryRef, kABPersonAddressCityKey, (__bridge CFStringRef)@"WeiFang");       //城市
//    CFDictionaryAddValue(addressDictionaryRef, kABPersonAddressStateKey, (__bridge CFStringRef)@"ShangDong");    //省(区)
//    CFDictionaryAddValue(addressDictionaryRef, kABPersonAddressStreetKey, (__bridge CFStringRef)@"Street");      //街道
//    CFDictionaryAddValue(addressDictionaryRef, kABPersonAddressZIPKey, (__bridge CFStringRef)@"261500");         //邮编
//    CFDictionaryAddValue(addressDictionaryRef, kABPersonAddressCountryCodeKey, (__bridge CFStringRef)@"ISO");    //ISO国家编码
//
//    //添加属性
//    ABMultiValueAddValueAndLabel(addressMultiValue, addressDictionaryRef, (__bridge CFStringRef)@"主要", &AddressIdentifier);
//    ABRecordSetValue(person, kABPersonAddressProperty, addressMultiValue, &error);
//
//    //释放资源
//    CFRelease(addressMultiValue);
//
//    
//    
//    
//#pragma mark - 添加联系人的生日信息
//    /*添加联系人的生日信息*/
//    //添加公历生日
//    ABRecordSetValue(person, kABPersonBirthdayProperty, (__bridge CFTypeRef)([NSDate date]), &error);
//
//
//    //添加联系人
//    if (ABAddressBookAddRecord(addressBook, person, &error) == true)
//    {
//        //成功就需要保存一下
//        ABAddressBookSave(addressBook, &error);
//    }
//
//    //不要忘记了释放资源
//    CFRelease(person);
//    CFRelease(addressBook);
//}
//
//
@end
