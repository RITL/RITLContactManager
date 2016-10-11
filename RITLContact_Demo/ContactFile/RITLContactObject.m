//
//  YContactObject.m
//  YAddressBookDemo
//
//  Created by YueWen on 16/5/6.
//  Copyright © 2016年 YueWen. All rights reserved.
//

#import "RITLContactObject.h"
#import <objc/runtime.h>


/**
 获得object所有属性名字的数组

 @param object 需要属性名字的数组

 @return 存储对象属性名字的数组
 */
NSArray<NSString *> * propertyNames(id object)
{
    unsigned int propertyCount;
    
    //获得当前所有的属性
    objc_property_t * propertyList = class_copyPropertyList([object class], &propertyCount);
    
    NSMutableArray <NSString *> * propertys = [NSMutableArray arrayWithCapacity:propertyCount];
    
    for (NSUInteger i = 0; i < propertyCount; i++)
    {
        //获得属性名字
        NSString * propertyName = [NSString stringWithUTF8String:property_getName(propertyList[i])];
        
        [propertys addObject:propertyName];
    }
    
    //释放
    free(propertyList);
    
    return [propertys mutableCopy];
}


#pragma mark - YContactObject

@implementation RITLContactObject



#pragma mark - NSMutableCoping

//-(id)mutableCopyWithZone:(NSZone *)zone
//{
//    RITLContactObject * object = [[RITLContactObject alloc]init];
//
//    NSArray <NSString *> * propertys = propertyNames(self);
//
//    //进行赋值
//    for (NSString * property in propertys)
//    {
//        //获得处理完毕的属性名
//        NSString * propertyHandle = [NSString stringWithFormat:@"%@%@",[property substringToIndex:1].uppercaseString,[property substringFromIndex:1]];
//        
//        //获得执行方法
//        NSString * selectorName = [NSString stringWithFormat:@"set%@:",propertyHandle];
//
//        SEL setSEL = NSSelectorFromString(selectorName);
//        
//        [object performSelector:setSEL withObject:[self valueForKey:property] afterDelay:0];
//    }
//    
//    return object;
//}




+(BOOL)resolveInstanceMethod:(SEL)sel
{
    return [super resolveInstanceMethod:sel];
}

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

