//
//  RITLContactObject+RITLContactFile.m
//  RITLContact_Demo
//
//  Created by YueWen on 2016/10/11.
//  Copyright © 2016年 YueWen. All rights reserved.
//

#import "RITLContactObject+RITLContactFile.h"

@import Contacts;

@implementation NSObject (RITLContactFile)

-(void)contactObject:(CNContact *)contact
{
    
}

@end

@implementation RITLContactObject (RITLContactFile)

@dynamic identifier;

-(void)contactObject:(CNContact *)contact
{
    [super contactObject:contact];
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
}

//@property (readonly, copy, NS_NONATOMIC_IOSONLY) NSString *identifier;
//
//@property (readonly, NS_NONATOMIC_IOSONLY) CNContactType contactType;
//
//
//
//@property (readonly, copy, NS_NONATOMIC_IOSONLY) NSString *organizationName;
//@property (readonly, copy, NS_NONATOMIC_IOSONLY) NSString *departmentName;
//@property (readonly, copy, NS_NONATOMIC_IOSONLY) NSString *jobTitle;
//
//@property (readonly, copy, NS_NONATOMIC_IOSONLY) NSString *phoneticGivenName;
//@property (readonly, copy, NS_NONATOMIC_IOSONLY) NSString *phoneticMiddleName;
//@property (readonly, copy, NS_NONATOMIC_IOSONLY) NSString *phoneticFamilyName;
//@property (readonly, copy, NS_NONATOMIC_IOSONLY) NSString *phoneticOrganizationName NS_AVAILABLE(10_12, 10_0);
//
//@property (readonly, copy, NS_NONATOMIC_IOSONLY) NSString *note;

@end
