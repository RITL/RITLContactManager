//
//  YContactsManager.m
//  YAddressBookDemo
//
//  Created by YueWen on 16/5/6.
//  Copyright © 2016年 YueWen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RITLContactsManager.h"
#import "RITLContacts.h"

#ifdef ContactFrameworkIsAvailable
#import "RITLContactManager.h"
#else
#import "RITLAddressBookContactManager.h"
#endif



@interface RITLContactsManager ()

#ifndef ContactFrameworkIsAvailable
/**
 负责针对AddressBook进行数据请求的类
 */
@property (nonatomic, strong) RITLAddressBookContactManager * addressBookContactManager;

#else
/**
 负责针对Contact进行数据请求的类
 */
@property (nonatomic, strong) RITLContactManager * contactManager NS_AVAILABLE_IOS(9_0);

#endif

@end



@implementation RITLContactsManager


-(instancetype)init
{
    if (self = [super init])
    {
#ifndef ContactFrameworkIsAvailable
        if (!isAvailableContactFramework)
        {
          self.addressBookContactManager = [[RITLAddressBookContactManager alloc]init];
        }
#else
        self.contactManager = [[RITLContactManager alloc]init];
#endif
        
    }
    
    return self;
}


-(void)dealloc
{
    NSLog(@"%@ dealloc",NSStringFromClass([self class]));
}



#pragma mark - 请求通讯录
//请求通讯录
-(void)requestContactsComplete:(void (^)(NSArray<RITLContactObject *> * _Nonnull))completeBlock defendBlock:(nonnull void (^)(void))defendBlock
{
    [self requestContactsType:ContactsTypeDefault Complete:completeBlock defendBlock:defendBlock];
}


-(void)requestContactsType:(ContactsType)contactType Complete:(void (^)(NSArray<RITLContactObject *> * _Nonnull))completeBlock defendBlock:(void (^)(void))defendBlock
{

#ifndef ContactFrameworkIsAvailable
    
    if (!isAvailableContactFramework)
    {
        //change Block
        self.addressBookContactManager.addressBookDidChange = self.contactDidChange;
        
        //如果是addressBook
        [self.addressBookContactManager requestContactsComplete:^(NSArray<RITLContactObject *> * _Nonnull contacts) {
            
            completeBlock(contacts);
            
        } defendBlock:^{
            
            defendBlock();
            
        }];
    }
    
#else
    //如果是contact
    self.contactManager.descriptors = self.descriptors;
    self.contactManager.contactDidChange = self.contactDidChange;
    
    [self.contactManager requestContactsComplete:^(NSArray<RITLContactObject *> * _Nonnull contacts) {
        
        completeBlock(contacts);
        
    } defendBlock:^{
        
        defendBlock();
        
    }];
    
#endif
}

@end


@implementation RITLContactsManager (RITLAddContact)

-(void)addContact:(RITLContactObject *)contact
{
    if (contact == nil) return;

#ifndef ContactFrameworkIsAvailable
    [self.addressBookContactManager addContact:contact];
#else
    [self.contactManager addContact:contact];
#endif
}

@end
