//
//  NSString+RITLContactFile.m
//  RITLContact_Demo
//
//  Created by YueWen on 2016/10/12.
//  Copyright © 2016年 YueWen. All rights reserved.
//

#import "NSString+RITLContactFile.h"

@import Contacts;

@implementation NSString (RITLContactFile)

+(NSArray<id<CNKeyDescriptor>> *)RITLContactNameKeys
{
    return @[
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 100000
             CNContactPhoneticOrganizationNameKey,
#endif
             CNContactNamePrefixKey,
             CNContactGivenNameKey,
             CNContactMiddleNameKey,
             CNContactFamilyNameKey,
             CNContactPreviousFamilyNameKey,
             CNContactNameSuffixKey,
             CNContactNicknameKey,
             CNContactPhoneticGivenNameKey,
             CNContactPhoneticMiddleNameKey,
             CNContactPhoneticFamilyNameKey
             ];
}


+(NSArray<id<CNKeyDescriptor>> *)RITLContactNamePhoneKeys
{
    NSArray * nameKeys = [self RITLContactNameKeys];
    NSArray * phoneKeys = @[CNContactPhoneNumbersKey];
    
    return [nameKeys arrayByAddingObjectsFromArray:phoneKeys];
}


+(NSArray <id<CNKeyDescriptor>> *)RITLContactAllKeys
{
    return @[
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 100000
             CNContactPhoneticOrganizationNameKey,
#endif
             //identifier
             CNContactIdentifierKey,
             
             //name
             CNContactNamePrefixKey,
             CNContactGivenNameKey,
             CNContactMiddleNameKey,
             CNContactFamilyNameKey,
             CNContactPreviousFamilyNameKey,
             CNContactNameSuffixKey,
             CNContactNicknameKey,
             
             //phonetic
             CNContactPhoneticGivenNameKey,
             CNContactPhoneticMiddleNameKey,
             CNContactPhoneticFamilyNameKey,
             
             //number
             CNContactPhoneNumbersKey,
             
             //email
             CNContactEmailAddressesKey,
             
             //postal
             CNContactPostalAddressesKey,
             
             //job
             CNContactJobTitleKey,
             CNContactDepartmentNameKey,
             CNContactOrganizationNameKey,
             
             //note
             CNContactNoteKey,
             
             //type
             CNContactTypeKey,
             
             //birthday
             CNContactBirthdayKey,
             CNContactNonGregorianBirthdayKey,
             
             //instantMessageAddresses
             CNContactInstantMessageAddressesKey,
             
             //relation
             CNContactRelationsKey,
             
             //SocialProfiles
             CNContactSocialProfilesKey,
             
             //Dates
             CNContactDatesKey
             ];
}

@end
