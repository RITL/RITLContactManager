//
//  RITLAddressBookContactManager.m
//  RITLContact_Demo
//
//  Created by YueWen on 2016/10/11.
//  Copyright © 2016年 YueWen. All rights reserved.
//

#import "RITLAddressBookContactManager.h"
#import <AddressBook/AddressBook.h>
#import "RITLContactObject.h"
#import "RITLAddressBookContactObjectManager.h"

static NSNotificationName const addressBookDidChanged = @"RITLADDRESSBOOKDIDCHANGED";

@interface RITLAddressBookContactManager ()

/// 请求通讯录的结构体对象
@property (nonatomic, assign, nullable)ABAddressBookRef addressBook;

/// 获取到数据完成的回调
@property(nonatomic, copy)void (^completeBlock)(NSArray<RITLContactObject *> * _Nonnull);

/// 没有权限的回调
@property(nonatomic, copy)void (^defendBlock)(void);

@end



@implementation RITLAddressBookContactManager


-(instancetype)init
{
    if (self = [super init])
    {
        //初始化addressBook
        self.addressBook = ABAddressBookCreate();
        
        //注册监听
        ABAddressBookRegisterExternalChangeCallback(self.addressBook,addressBookChangeCallBack,nil);
        
        //收通知
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(__handleAddressBookDidChanged) name:addressBookDidChanged object:nil];
    }
    
    return self;
}



void addressBookChangeCallBack(ABAddressBookRef addressBook, CFDictionaryRef info, void *context)
{
    //coding when addressBook did changed
    NSLog(@"通讯录发生变化啦");
    
    //发送通知
    [[NSNotificationCenter defaultCenter]postNotificationName:addressBookDidChanged object:nil];
}


- (void)__handleAddressBookDidChanged
{
    //重新获取联系人
    //必须在同一个线程
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self __obtainContactCompleteBlock:self.addressBookDidChange];
        
        //获得修改的联系人数组
        /*no implementation....*/
    });
}


-(void)dealloc
{
    //移除监听
    ABAddressBookUnregisterExternalChangeCallback(self.addressBook, addressBookChangeCallBack, (__bridge void *)(self));
    
    //移除
    [[NSNotificationCenter defaultCenter]removeObserver:self];

    CFRelease(self.addressBook);
    
    NSLog(@"%@ dealloc",NSStringFromClass([self class]));
}



#pragma mark - public function


-(void)requestContactsComplete:(void (^)(NSArray<RITLContactObject *> * _Nonnull))completeBlock defendBlock:(nonnull void (^)(void))defendBlock
{
    //进行赋值
    self.completeBlock = completeBlock;
    self.defendBlock = defendBlock;
    
    
    
    //验证权限并进行下一步操作
    [self __checkAuthorizationStatus];
}


#pragma mark - private function

 /**
  检测权限并作响应的操作
  */
- (void)__checkAuthorizationStatus
{
    switch (ABAddressBookGetAuthorizationStatus())
    {
            //存在权限
        case kABAuthorizationStatusAuthorized:
        {
            //主线程
            dispatch_async(dispatch_get_main_queue(), ^{
              
                //获取通讯录
                [self __obtainContactCompleteBlock:self.completeBlock];
            });
        }
            break;
            
            //权限未知
        case kABAuthorizationStatusNotDetermined:
            //请求权限
            [self __requestAuthorizationStatus];break;
            
            //如果没有权限
        case kABAuthorizationStatusDenied:
        case kABAuthorizationStatusRestricted://需要提示
            self.defendBlock();break;
    }
}


/**
 *  获取通讯录中的联系人
 */
- (void)__obtainContactCompleteBlock:(void(^)(NSArray<RITLContactObject *> * _Nonnull)) completeBlock
{

    ABAddressBookRef addressBook = ABAddressBookCreate();
    
    //按照添加时间请求所有的联系人
    CFArrayRef allContacts = ABAddressBookCopyArrayOfAllPeople(addressBook);

    //按照排序规则请求所有的联系人
    //    ABRecordRef recordRef = ABAddressBookCopyDefaultSource(addressBook);
    //    CFArrayRef allContacts = ABAddressBookCopyArrayOfAllPeopleInSourceWithSortOrdering(addressBook, recordRef, kABPersonSortByFirstName);
    
    //存放所有联系人的数组
    NSMutableArray <RITLContactObject *> * contacts = [NSMutableArray arrayWithCapacity:CFArrayGetCount(allContacts)];
    
    //遍历获取所有的数据
    for (NSInteger i = 0; i < CFArrayGetCount(allContacts); i++)
    {
        //获得People对象
        ABRecordRef recordRef = CFArrayGetValueAtIndex(allContacts, i);
        
        //获得contact对象
        RITLContactObject * contactObject = [RITLAddressBookContactObjectManager contantObject:recordRef];
        
        //添加对象
        [contacts addObject:contactObject];
        
        CFRelease(recordRef);
        
    }
        
    if (completeBlock != nil)
    {
        //进行数据回调
        completeBlock([NSArray arrayWithArray:contacts]);
    }
    
    //释放资源
    CFRelease(allContacts);
//    if(addressBook != NULL) CFRelease(addressBook);
}



/**
 请求通讯录的权限
 */
- (void)__requestAuthorizationStatus
{
    //避免强引用
    __weak typeof(self) copy_self = self;
    
    ABAddressBookRequestAccessWithCompletion(self.addressBook, ^(bool granted, CFErrorRef error) {
        
        //主线程获取联系人
        dispatch_async(dispatch_get_main_queue(), ^{
            
            //权限得到允许
            if (granted == true)
            {
                [copy_self __obtainContactCompleteBlock:self.completeBlock];
            }
            
            else
            {
                copy_self.defendBlock();
            }
        });

    });
}
@end

@implementation RITLAddressBookContactManager (RITLAddContact)

-(void)addContact:(RITLContactObject *)contact
{
    
    NSLog(@"RITLAddressBookcontact add contact");
    
    ABAddressBookRef addressBook = ABAddressBookCreate();
    
    ABRecordRef recordRef = [RITLAddressBookContactObjectManager recordRef:contact];
    
    dispatch_async(dispatch_get_main_queue(), ^{
       
        if(ABAddressBookAddRecord(addressBook, recordRef, nil) == true)
        {
            NSLog(@"add success");
        }
        
        CFErrorRef error;
        
        if (ABAddressBookHasUnsavedChanges(addressBook))
        {
            if(ABAddressBookSave(addressBook, &error) == true)
            {
                NSLog(@"save");
                
                if (error != NULL)
                {
                    //                NSLog(@"error = %@",error);
                }
                
                else NSLog(@"save success");
            }
        }
        
        CFRelease(recordRef);
        
        if (error != NULL)
        {
            //        CFRelease(error);
        }
        
        CFRelease(addressBook);
        
    });
}



@end
