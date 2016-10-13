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
    self.nickName = contact.nickname;
    self.givenName = contact.givenName;
    self.familyName = contact.familyName;
    self.middleName = contact.middleName;
    self.namePrefix = contact.namePrefix;
    self.nameSuffix = contact.nameSuffix;
    self.phoneticGivenName = contact.phoneticGivenName;
    self.phoneticFamilyName = contact.phoneticFamilyName;
    self.phoneticMiddleName = contact.phoneticMiddleName;
    
#ifdef __IPHONE_10_0
    self.phoneticOrganizationName = contact.phoneticOrganizationName;
#endif
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
