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
#ifdef __IPHONE_10_0
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

@end
