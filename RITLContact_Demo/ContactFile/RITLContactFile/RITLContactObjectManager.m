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
    
    //identifier
    contactObject.identifier = contact.identifier;
    
    //姓名对象OK
    contactObject.nameObject = [self __contactNameProperty];
    
    //类型OK
    contactObject.type = [self __contactTypeProperty];
    
    //头像OK
    contactObject.headImage = [self __contactHeadImagePropery];
    
    //电话对象OK
    contactObject.phoneObject = [self __contactPhoneProperty];
    
    //工作对象OK
    contactObject.jobObject = [self __contactJobProperty];
    
    //邮件对象OK
    contactObject.emailAddresses = [self __contactEmailProperty];
    
    //地址对象OK
    contactObject.addresses = [self __contactAddressProperty];
    
    //生日对象
    contactObject.brithdayObject = [self __contactBrithdayProperty];
    
    //即时通信对象OK
    contactObject.instantMessage = [self __contactMessageProperty];
    
    //关联对象OK
    contactObject.relatedNames = [self __contactRelatedNamesProperty];
    
    //社交简介OK
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
    
    if ([self.currentContact isKeyAvailable:CNContactJobTitleKey])
    {
        //setValue
        jobObject.jobTitle = self.currentContact.jobTitle;
        jobObject.departmentName = self.currentContact.departmentName;
        jobObject.organizationName = self.currentContact.organizationName;
    }

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
    
    
    if ([self.currentContact isKeyAvailable:CNContactBirthdayKey])
    {
        //set value
        brithdayObject.brithdayDate = [self.currentContact.birthday.calendar dateFromComponents:self.currentContact.birthday];
        brithdayObject.leapMonth = self.currentContact.birthday.isLeapMonth;
    }

    if ([self.currentContact isKeyAvailable:CNContactNonGregorianBirthdayKey])
    {
        brithdayObject.calendar = self.currentContact.nonGregorianBirthday.calendar.calendarIdentifier;
        brithdayObject.era = self.currentContact.nonGregorianBirthday.era;
        brithdayObject.day = self.currentContact.nonGregorianBirthday.day;
        brithdayObject.month = self.currentContact.nonGregorianBirthday.month;
        brithdayObject.year = self.currentContact.nonGregorianBirthday.year;
    }

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
    if (![self.currentContact isKeyAvailable:CNContactInstantMessageAddressesKey])
    {
        return @[];
    }
    
    //存放数组
    NSMutableArray <RITLContactInstantMessageObject *> * instantMessages = [NSMutableArray arrayWithCapacity:self.currentContact.instantMessageAddresses.count];
    
    for (CNLabeledValue * instanceAddressValue in self.currentContact.instantMessageAddresses)
    {
        RITLContactInstantMessageObject * instaceObject = [[RITLContactInstantMessageObject alloc]init];
        
        //set value
        instaceObject.identifier = instanceAddressValue.identifier;
        instaceObject.service = ((CNInstantMessageAddress *)instanceAddressValue.value).service;
        instaceObject.userName = ((CNInstantMessageAddress *)instanceAddressValue.value).username;
        
        //add
        [instantMessages addObject:instaceObject];
    }
    
    return [NSArray arrayWithArray:instantMessages];
}



/**
 *  获得联系人的关联人信息
 */
+ (NSArray <RITLContactRelatedNamesObject *> *)__contactRelatedNamesProperty
{
    if (![self.currentContact isKeyAvailable:CNContactRelationsKey])
    {
        return @[];
    }
    
    //存放数组
    NSMutableArray <RITLContactRelatedNamesObject *> * relatedNames = [NSMutableArray arrayWithCapacity:self.currentContact.contactRelations.count];
    
    for (CNLabeledValue * relationsValue in self.currentContact.contactRelations)
    {
        RITLContactRelatedNamesObject * relatedObject = [[RITLContactRelatedNamesObject alloc]init];
        
        //set value
        relatedObject.identifier = relationsValue.identifier;
        relatedObject.relatedTitle = relationsValue.label;
        relatedObject.relatedName = ((CNContactRelation *)relationsValue.value).name;
        
        [relatedNames addObject:relatedObject];
        
    }

    
    return [NSArray arrayWithArray:relatedNames];
}



/**
 *  获得联系人的社交简介信息
 */
+ (NSArray <RITLContactSocialProfileObject *> *)__contactSocialProfilesProperty
{
    if (![self.currentContact isKeyAvailable:CNContactSocialProfilesKey])
    {
        return @[];
    }
    
    //外传数组
    NSMutableArray <RITLContactSocialProfileObject *> * socialProfiles = [NSMutableArray arrayWithCapacity:self.currentContact.socialProfiles.count];
    
    for (CNLabeledValue * socialProfileValue in self.currentContact.socialProfiles) {
        
        RITLContactSocialProfileObject * socialProfileObject = [[RITLContactSocialProfileObject alloc]init];
        
        //获得CNSocialProfile对象
        CNSocialProfile * socialProfile = socialProfileValue.value;

        //set value
        socialProfileObject.identifier = socialProfileValue.identifier;
        socialProfileObject.socialProfileTitle = socialProfile.service;
        socialProfileObject.socialProFileAccount = socialProfile.username;
        socialProfileObject.socialProFileUrl = socialProfile.urlString;
        
        [socialProfiles addObject:socialProfileObject];
    }
    
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
