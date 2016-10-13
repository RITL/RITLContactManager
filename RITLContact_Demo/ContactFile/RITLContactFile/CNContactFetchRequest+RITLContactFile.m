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
    return [[CNContactFetchRequest alloc]initWithKeysToFetch:[NSString RITLContactAllKeys]];
}


@end
