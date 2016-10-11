//
//  YContactObject.m
//  YAddressBookDemo
//
//  Created by YueWen on 16/5/6.
//  Copyright © 2016年 YueWen. All rights reserved.
//

#import "YContactObject.h"

#pragma mark - YContactObject

@interface YContactObject ()

/**
 *  存放ABRecordRef属性的对象
 */
@property (nonatomic, strong)NSValue * recordRefValue;

@end


@implementation YContactObject


@end










#pragma mark - YContactNameObject
@implementation YContactNameObject

-(NSString *)name
{
    //除nil处理
    self.middleName = (self.middleName) ? self.middleName : @"";
    self.givenName = (self.givenName) ? self.givenName : @"";
    self.familyName = (self.familyName) ? self.familyName : @"";
    
    
    return [[self.familyName stringByAppendingString:self.middleName] stringByAppendingString:self.givenName];
}

@end









#pragma mark - YContactPhoneObject
@implementation YContactPhoneObject



@end









#pragma mark -  YContactJobObject
@implementation YContactJobObject



@end









#pragma mark - YContactEmailObject
@implementation YContactEmailObject



@end








#pragma mark - YContactAddressObject
@implementation YContactAddressObject



@end









#pragma mark - YContactBrithdayObject
@implementation YContactBrithdayObject



@end








#pragma mark - YContactInstantMessageObject
@implementation YContactInstantMessageObject



@end





#pragma mark - YContactRelatedNamesObject
@implementation YContactRelatedNamesObject



@end






#pragma mark - YContactSocialProfileObject
@implementation YContactSocialProfileObject



@end

