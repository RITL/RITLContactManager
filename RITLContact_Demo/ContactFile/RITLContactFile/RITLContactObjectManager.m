//
//  RITLContactsObjectManager.m
//  RITLContact_Demo
//
//  Created by YueWen on 2016/10/11.
//  Copyright © 2016年 YueWen. All rights reserved.
//

#import "RITLContactObjectManager.h"
#import "RITLContactObject.h"
#import "RITLContactObject+RITLContactFile.h"
#import "NSString+RITLContactFile.h"
@import ObjectiveC;
@import Contacts;

static NSString * currentContactKey = @"currentContact";

@implementation RITLContactObjectManager

+(CNContact *)currentContact
{
    return objc_getAssociatedObject(self, &currentContactKey);
}


+(void)setCurrentContact:(CNContact *)contact
{
    return objc_setAssociatedObject(self, &currentContactKey, contact, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


-(void)dealloc
{
    objc_removeAssociatedObjects(self);
}


#pragma mark - public Function

+(RITLContactObject *)contantObject:(CNContact *)contact
{
    //
    self.currentContact = contact;
    
    //初始化一个YContactObject对象
    RITLContactObject * contactObject = [[RITLContactObject alloc]init];
    
    //姓名对象OK
    contactObject.nameObject = [self __contactNameProperty];
    
    //类型OK
    contactObject.type = [self __contactTypeProperty];
    
    //头像OK
    contactObject.headImage = [self __contactHeadImagePropery];
    
    //电话对象OK
    contactObject.phoneObject = [self __contactPhoneProperty];
    
    //工作对象
    contactObject.jobObject = [self __contactJobProperty];
    
    //邮件对象OK
    contactObject.emailAddresses = [self __contactEmailProperty];
    
    //地址对象OK
    contactObject.addresses = [self __contactAddressProperty];
    
    //生日对象
    contactObject.brithdayObject = [self __contactBrithdayProperty];
    
    //即时通信对象
    contactObject.instantMessage = [self __contactMessageProperty];
    
    //关联对象
    contactObject.relatedNames = [self __contactRelatedNamesProperty];
    
    //社交简介
    contactObject.socialProfiles = [self __contactSocialProfilesProperty];
    
    //备注OK
    contactObject.note = [self __contactNoteProperty];
    
    //创建时间
//    contactObject.creationDate = [self __contactDateProperty:kABPersonCreationDateProperty];              //创建日期
    
    //最近一次修改的时间
//    contactObject.modificationDate = [self __contactDateProperty:kABPersonModificationDateProperty];      //最近一次修改的时间
    
    return contactObject;
}

#pragma mark - private Function




/**
 *  获得姓名的相关属性
 */
+ (RITLContactNameObject *)__contactNameProperty
{
    RITLContactNameObject * nameObject = [[RITLContactNameObject alloc]init];
    
    if ([self.currentContact areKeysAvailable:[NSString RITLContactNameKeys]])
    {
       [nameObject contactObject:self.currentContact];
    }
    
    return nameObject;
}


/**
 *  获得工作的相关属性
 */
+ (RITLContactJobObject *)__contactJobProperty
{
    RITLContactJobObject * jobObject = [[ RITLContactJobObject alloc]init];
    
    
    return jobObject;
}




/**
 *  获得Email对象的数组
 */
+ (NSArray <RITLContactEmailObject *> *)__contactEmailProperty
{
    if (![self.currentContact isKeyAvailable:CNContactEmailAddressesKey])
    {
        return @[];
    }
    
    //外传数组
    NSMutableArray <RITLContactEmailObject *> * emails = [NSMutableArray arrayWithCapacity:self.currentContact.emailAddresses.count];
    
    for (CNLabeledValue * emailValue in self.currentContact.emailAddresses)
    {
        //初始化RITLContactEmailObject对象
        RITLContactEmailObject * emailObject = [[RITLContactEmailObject alloc]init];
        
        //setValue
        emailObject.emailTitle = emailValue.label;
        emailObject.emailAddress = emailValue.value;
        
        [emails addObject:emailObject];
        
    }
    
    return [NSArray arrayWithArray:emails];
}





/**
 *  获得Address对象的数组
 */
+ (NSArray <RITLContactAddressObject *> *)__contactAddressProperty
{
    if (![self.currentContact isKeyAvailable:CNContactPostalAddressesKey]) {
        
        return @[];
        
    }
    
    //外传数组
    NSMutableArray <RITLContactAddressObject *> * addresses = [NSMutableArray arrayWithCapacity:self.currentContact.postalAddresses.count];
    
    for (CNLabeledValue * addressValue in self.currentContact.postalAddresses)
    {
        //初始化地址对象
        RITLContactAddressObject * addressObject = [[RITLContactAddressObject alloc]init];
        
        //setValues
        addressObject.addressTitle = addressValue.label;
        
        //setDetailValue
        [addressObject contactObject:addressValue.value];
        
        //add object
        [addresses addObject:addressObject];
    }
    
    return [NSArray arrayWithArray:addresses];
    
}





/**
 *  获得电话号码对象数组
 */
+ (NSArray <RITLContactPhoneObject *> *)__contactPhoneProperty
{
    
    if (![self.currentContact isKeyAvailable:CNContactPhoneNumbersKey])
    {
        return @[];
    }
    
    //外传数组
    NSMutableArray <RITLContactPhoneObject *> * phones = [NSMutableArray arrayWithCapacity:self.currentContact.phoneNumbers.count];
    
    for (CNLabeledValue * phoneValue in self.currentContact.phoneNumbers)
    {
        //初始化PhoneObject对象
        RITLContactPhoneObject * phoneObject = [RITLContactPhoneObject new];
        
        //setValue
        phoneObject.phoneTitle = phoneValue.label;
        phoneObject.phoneNumber = ((CNPhoneNumber *)phoneValue.value).stringValue;
        
        [phones addObject:phoneObject];
    }
    
    return [NSArray arrayWithArray:phones];
}




/**
 *  获得联系人的头像图片
 */
+ (UIImage * __nullable)__contactHeadImagePropery
{
    //缩略图Data
    if ([self.currentContact isKeyAvailable:CNContactThumbnailImageDataKey])
    {
        NSData * thumImageData = self.currentContact.thumbnailImageData;
        
        return [UIImage imageWithData:thumImageData];
    }
    
    return nil;
}




/**
 *  获得生日的相关属性
 */
+ (RITLContactBrithdayObject *)__contactBrithdayProperty
{
    //实例化对象
    RITLContactBrithdayObject * brithdayObject = [[RITLContactBrithdayObject alloc]init];
    

    
    //返回对象
    return brithdayObject;
}




/**
 *  获得联系人类型信息
 */
+ (RITLContactType)__contactTypeProperty
{
    if (![self.currentContact isKeyAvailable:CNContactTypeKey]) {
        
        return RITLContactTypeUnknown;
        
    }
    
    else if (self.currentContact.contactType == CNContactTypeOrganization) {
        
        return RITLContactTypeOrigination;
    }
    
    else if(self.currentContact.contactType == CNContactTypePerson){
        
        return RITLContactTypePerson;
    }
        
    return RITLContactTypeUnknown;
}



/**
 *  获得即时通信账号相关信息
 */
+ (NSArray <RITLContactInstantMessageObject *> *)__contactMessageProperty
{
    //存放数组
    NSMutableArray <RITLContactInstantMessageObject *> * instantMessages = [NSMutableArray arrayWithCapacity:0];
    

    return [NSArray arrayWithArray:instantMessages];
}



/**
 *  获得联系人的关联人信息
 */
+ (NSArray <RITLContactRelatedNamesObject *> *)__contactRelatedNamesProperty
{
    //存放数组
    NSMutableArray <RITLContactRelatedNamesObject *> * relatedNames = [NSMutableArray arrayWithCapacity:0];
    

    
    return [NSArray arrayWithArray:relatedNames];
}



/**
 *  获得联系人的社交简介信息
 */
+ (NSArray <RITLContactSocialProfileObject *> *)__contactSocialProfilesProperty
{
    //外传数组
    NSMutableArray <RITLContactSocialProfileObject *> * socialProfiles = [NSMutableArray arrayWithCapacity:0];
    

    return [NSArray arrayWithArray:socialProfiles];
}



/**
 获得联系人的备注信息
 */
+ (NSString * __nullable)__contactNoteProperty
{
    if ([self.currentContact isKeyAvailable:CNContactNoteKey])
    {
        return self.currentContact.note;
    }
    
    return nil;
}

@end
