//
//  CNMutableContact+RITLContactFile.m
//  RITLContact_Demo
//
//  Created by YueWen on 2016/10/14.
//  Copyright © 2016年 YueWen. All rights reserved.
//

#import "CNMutableContact+RITLContactFile.h"
#import "RITLContactObject.h"

@implementation CNMutableContact (RITLContactFile)


-(void)nameWithNameObject:(RITLContactNameObject *)nameObject
{
    if (nameObject == nil) {
        return;
    }
    
    //name
    self.nickname = nameObject.nickName;
    self.givenName = nameObject.givenName;
    self.familyName = nameObject.familyName;
    self.middleName = nameObject.middleName;
    self.namePrefix = nameObject.namePrefix;
    self.nameSuffix = nameObject.nameSuffix;
    self.phoneticGivenName = nameObject.phoneticGivenName;
    self.phoneticFamilyName = nameObject.phoneticFamilyName;
    self.phoneticMiddleName = nameObject.phoneticMiddleName;
    
#ifdef __IPHONE_10_0
    self.phoneticOrganizationName = nameObject.phoneticOrganizationName;
#endif
    
}



-(void)phoneWithPhoneObjects:(NSArray<RITLContactPhoneObject *> *)phoneObjects
{
    if (phoneObjects == nil) {
        return;
    }
    
    NSMutableArray <CNLabeledValue *>* values = [NSMutableArray arrayWithCapacity:phoneObjects.count];
    
    for (RITLContactPhoneObject * phoneObject in phoneObjects)
    {
        CNLabeledValue * labelValue = [CNLabeledValue labeledValueWithLabel:phoneObject.phoneTitle value:[CNPhoneNumber phoneNumberWithStringValue:phoneObject.phoneNumber ]];
        
        [values addObject:labelValue];
    }
    
    self.phoneNumbers = [values mutableCopy];
}



-(void)jobWithJobObjects:(RITLContactJobObject *)jobObject
{
    if (jobObject == nil) {
        return;
    }
    
    self.organizationName = jobObject.organizationName;
    self.departmentName = jobObject.departmentName;
    self.jobTitle = jobObject.jobTitle;
}



-(void)emailWithEmailObjects:(NSArray<RITLContactEmailObject *> *)emailObjects
{
    if (emailObjects == nil) {
        return;
    }
    
    NSMutableArray <CNLabeledValue *>* values = [NSMutableArray arrayWithCapacity:emailObjects.count];
    
    for (RITLContactEmailObject * emailObject in emailObjects)
    {
        [values addObject:[CNLabeledValue labeledValueWithLabel:emailObject.emailTitle value:emailObject.emailAddress]];
    }
    
    self.emailAddresses = [values mutableCopy];
}


-(void)addressWithAddressObjects:(NSArray<RITLContactAddressObject *> *)addressObjects
{
    if (addressObjects == nil) {
        return;
    }
    
    NSMutableArray <CNLabeledValue *>* values = [NSMutableArray arrayWithCapacity:addressObjects.count];
    
    for (RITLContactAddressObject * addressObject in addressObjects)
    {
        [values addObject:[CNLabeledValue labeledValueWithLabel:addressObject.addressTitle value:[CNMutablePostalAddress postalAddress:addressObject]]];
    }
    
    self.postalAddresses = [values mutableCopy];
}


-(void)instantWithInstantObjects:(NSArray<RITLContactInstantMessageObject *> *)instantObjects
{
    if (instantObjects == nil) {
        return;
    }
    
    NSMutableArray <CNLabeledValue *>* values = [NSMutableArray arrayWithCapacity:instantObjects.count];
    
    for (RITLContactInstantMessageObject * messageObject in instantObjects)
    {
        [values addObject:[CNLabeledValue labeledValueWithLabel:nil value:[[CNInstantMessageAddress alloc] initWithUsername:messageObject.userName service:messageObject.service]]];
    }
    
    self.instantMessageAddresses = [values mutableCopy];
}


-(void)socialProfileWithSocialObjects:(NSArray <RITLContactSocialProfileObject *> *)socialObjects
{
    if (socialObjects == nil) {
        return;
    }
    
    NSMutableArray <CNLabeledValue *>* values = [NSMutableArray arrayWithCapacity:socialObjects.count];
    
    for (RITLContactSocialProfileObject * socialObject in socialObjects)
    {
        [values addObject:[CNLabeledValue labeledValueWithLabel:nil value:[[CNSocialProfile alloc]initWithUrlString:socialObject.socialProFileUrl username:socialObject.socialProFileAccount userIdentifier:nil service:socialObject.socialProfileTitle]]];
    }
    
    self.socialProfiles = [values mutableCopy];
}


@end







@implementation CNMutablePostalAddress (RITLContactFile)

+(instancetype)postalAddress:(RITLContactAddressObject *)addressObject
{
    CNMutablePostalAddress * address = [[CNMutablePostalAddress alloc]init];
    
    //set value
    address.street = addressObject.street;
    address.city = addressObject.city;
    address.state = addressObject.state;
    address.postalCode = addressObject.postalCode;
    address.country = addressObject.country;
    address.ISOCountryCode = addressObject.ISOCountryCode;
    
    return address;
}

@end
