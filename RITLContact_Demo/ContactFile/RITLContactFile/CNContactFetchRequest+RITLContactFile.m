//
//  CNContactFetchRequest+RITLContactFile.m
//  RITLContact_Demo
//
//  Created by YueWen on 2016/10/11.
//  Copyright © 2016年 YueWen. All rights reserved.
//

#import "CNContactFetchRequest+RITLContactFile.h"


@implementation CNContactFetchRequest (RITLContactFile)


+(CNContactFetchRequest *)descriptorForAllKeys
{
    return [[CNContactFetchRequest alloc]initWithKeysToFetch:[self __allKeys]];
}




+(NSArray <id<CNKeyDescriptor>> *)__allKeys
{
//    NSLog(@"contact = %@",[CNContact descriptorForAllComparatorKeys]);
    
    return @[[CNContact descriptorForAllComparatorKeys],CNContactPhoneNumbersKey,CNContactEmailAddressesKey,CNContactPostalAddressesKey,CNContactJobTitleKey,CNContactDepartmentNameKey,CNContactDepartmentNameKey,CNContactNoteKey];
    
//    return @[[CNContact descriptorForAllComparatorKeys]];
}

@end
