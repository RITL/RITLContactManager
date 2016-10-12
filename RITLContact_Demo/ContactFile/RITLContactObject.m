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
    [self __stringHandle];
    
    //handle the string
    return [[[[self.namePrefix stringByAppendingString:self.familyName] stringByAppendingString:self.middleName] stringByAppendingString:self.givenName] stringByAppendingString:self.nameSuffix];
}



/**
 ensure the value is not nil
 */
- (void)__stringHandle
{
    self.namePrefix = (self.namePrefix) ? self.namePrefix : @"";
    self.familyName = (self.familyName) ? self.familyName : @"";
    self.middleName = (self.middleName) ? self.middleName : @"";
    self.givenName = (self.givenName) ? self.givenName : @"";
    self.nameSuffix = (self.nameSuffix) ? self.nameSuffix : @"";
}



/**
 排序用的姓名
 */
-(NSString *)__sortName
{
    [self __stringHandle];
    
    //handle the string
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

#pragma mark - RITLContactSortManager
@implementation RITLContactSortManager



+(NSArray<NSArray<RITLContactObject *> *> *)defaultHandleContactObject:(NSArray<RITLContactObject *> *)contactObjects
{
    return [self handleContactObjects:contactObjects groupingByKeyPath:@"__sortName" sortInGroupKeyPath:@"nameObject.name"];
}



+(NSArray<NSArray<RITLContactObject *> *> *)handleContactObjects:(NSArray<RITLContactObject *> *)contactObjects groupingByKeyPath:(NSString *)keyPath sortInGroupKeyPath:(NSString *)sortInGroupkeyPath
{
    
    UILocalizedIndexedCollation * localizedCollation = [UILocalizedIndexedCollation currentCollation];
    
    //初始化数组返回的数组
    NSMutableArray <NSMutableArray *> * contacts = [NSMutableArray arrayWithCapacity:0];
    
    
    /**(注:)
     * 为什么不直接用27，而用count呢，这里取决于初始化方式
     * 初始化方式为[[Class alloc] init],那么这个count = 0
     * 初始化方式为[Class currentCollation],那么这个count = 27
     */
    
    /**** 根据UILocalizedIndexedCollation的27个Title放入27个存储数据的数组 ****/
    for (NSInteger i = 0; i < localizedCollation.sectionTitles.count; i++)
    {
        [contacts addObject:[NSMutableArray arrayWithCapacity:0]];
    }
    
    
    //开始遍历联系人对象，进行分组
    for (RITLContactObject * contactObject in contactObjects)
    {
        //获取名字在UILocalizedIndexedCollation标头的索引数
        NSInteger section = [localizedCollation sectionForObject:contactObject.nameObject collationStringSelector:NSSelectorFromString(keyPath)];
        
        //根据索引在相应的数组上添加数据
        [contacts[section] addObject:contactObject];
    }
    
    
    //对每个同组的联系人进行排序
    for (NSInteger i = 0; i < localizedCollation.sectionTitles.count; i++)
    {
        //获取需要排序的数组
        NSMutableArray * tempMutableArray = contacts[i];
        
        //如果是直接的属性，直接用该方法排序即可，因为楼主自己构建的Model,name是Model的二级属性，所以此方法不能用
        //NSArray * sortArray = [self.localizedCollation sortedArrayFromArray:tempMutableArray collationStringSelector:@selector(name)];
        
        
        //这里因为需要通过nameObject的name进行排序，排序器排序(排序方法有好几种，楼主选择的排序器排序)
        NSSortDescriptor * sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:sortInGroupkeyPath ascending:true];
        [tempMutableArray sortUsingDescriptors:@[sortDescriptor]];
        contacts[i] = tempMutableArray;
        
    }
    
    //返回
    return [NSArray arrayWithArray:contacts];

}

@end
