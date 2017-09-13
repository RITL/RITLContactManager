//
//  RITLContactObject+RITLContactFile.m
//  RITLContact_Demo
//
//  Created by YueWen on 2016/10/11.
//  Copyright © 2016年 YueWen. All rights reserved.
//

#import "RITLContactObject+RITLContactFile.h"

@import ObjectiveC;
@import Contacts;

@implementation NSObject (RITLContactFile)

-(void)contactObject:(CNContact *)contact
{
    
}

@end

@implementation RITLContactObject (RITLContactFile)


-(void)contactObject:(CNContact *)contact
{
    [super contactObject:contact];
}

-(NSArray<NSString *> *)phones
{
    NSMutableArray <NSString *> * mulitPhones = [NSMutableArray arrayWithCapacity:self.phoneObject.count];
    
    for (RITLContactPhoneObject * phoneObject in self.phoneObject)
    {
        [mulitPhones addObject:phoneObject.phoneNumber];
    }
    
    return [mulitPhones copy];
}

@end


@implementation RITLContactNameObject (RITLContactFile)

-(void)contactObject:(CNContact *)contact
{
    [super contactObject:contact];
    
    //设置姓名属性
    self.nickName = contact.nickname;                   //昵称
    self.givenName = contact.givenName;                 //名字
    self.familyName = contact.familyName;               //姓氏
    self.middleName = contact.middleName;               //中间名
    self.namePrefix = contact.namePrefix;               //名字前缀
    self.nameSuffix = contact.nameSuffix;               //名字的后缀
    self.phoneticGivenName = contact.phoneticGivenName; //名字的拼音或音标
    self.phoneticFamilyName = contact.phoneticFamilyName;//姓氏的拼音或音标
    self.phoneticMiddleName = contact.phoneticMiddleName;//中间名的拼音或音标
    
    if (UIDevice.currentDevice.systemVersion.floatValue >= 10.0) {
        
        self.phoneticOrganizationName = contact.phoneticOrganizationName;//公司(组织)的拼音或音标
    }
}


@end


static NSString * formattedAddressKey;

@implementation RITLContactAddressObject (RITLContactFile)


-(void)contactObject:(CNPostalAddress *)cnAddressObject
{
    self.street = cnAddressObject.street;
    self.city = cnAddressObject.city;
    self.state = cnAddressObject.state;
    self.postalCode = cnAddressObject.postalCode;
    self.country = cnAddressObject.country;
    self.ISOCountryCode = cnAddressObject.ISOCountryCode;
    
    //set
    self.formattedAddress = [CNPostalAddressFormatter stringFromPostalAddress:cnAddressObject style:CNPostalAddressFormatterStyleMailingAddress];
}

-(void)dealloc
{
    
}


@end
