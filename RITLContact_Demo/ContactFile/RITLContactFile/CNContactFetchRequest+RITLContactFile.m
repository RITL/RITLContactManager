//
//  CNContactFetchRequest+RITLContactFile.m
//  RITLContact_Demo
//
//  Created by YueWen on 2016/10/11.
//  Copyright © 2016年 YueWen. All rights reserved.
//

#import "CNContactFetchRequest+RITLContactFile.h"
#import "NSString+RITLContactFile.h"


@implementation CNContactFetchRequest (RITLContactFile)


+(CNContactFetchRequest *)descriptorForAllKeys
{
    return [[CNContactFetchRequest alloc]initWithKeysToFetch:[self __allKeys]];
}




+(NSArray <id<CNKeyDescriptor>> *)__allKeys
{
    return @[
#ifdef __IPHONE_10_0
            CNContactPhoneticOrganizationNameKey,
#endif
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
