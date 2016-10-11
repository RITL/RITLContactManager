//
//  YContactObject.m
//  YAddressBookDemo
//
//  Created by YueWen on 16/5/6.
//  Copyright © 2016年 YueWen. All rights reserved.
//

#import "RITLContactObject.h"

#pragma mark - YContactObject

@interface RITLContactObject ()

/**
 *  存放ABRecordRef属性的对象
 */
@property (nonatomic, strong)NSValue * recordRefValue;

@end


@implementation RITLContactObject


@end










#pragma mark - RITLContactNameObject
@implementation RITLContactNameObject

-(NSString *)name
{
    //除nil处理
    self.middleName = (self.middleName) ? self.middleName : @"";
    self.givenName = (self.givenName) ? self.givenName : @"";
    self.familyName = (self.familyName) ? self.familyName : @"";
    
    
    return [[self.familyName stringByAppendingString:self.middleName] stringByAppendingString:self.givenName];
}

@end









#pragma mark - RITLContactPhoneObject
@implementation RITLContactPhoneObject



@end









#pragma mark -  YContactJobObject
@implementation RITLContactJobObject



@end









#pragma mark - YContactEmailObject
@implementation RITLContactEmailObject



@end








#pragma mark - YContactAddressObject
@implementation RITLContactAddressObject



@end









#pragma mark - YContactBrithdayObject
@implementation RITLContactBrithdayObject



@end








#pragma mark - YContactInstantMessageObject
@implementation RITLContactInstantMessageObject



@end





#pragma mark - YContactRelatedNamesObject
@implementation RITLContactRelatedNamesObject



@end






#pragma mark - YContactSocialProfileObject
@implementation RITLContactSocialProfileObject



@end

