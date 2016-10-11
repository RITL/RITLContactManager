//
//  RITLContactsManager.m
//  RITLContact_Demo
//
//  Created by YueWen on 2016/10/11.
//  Copyright © 2016年 YueWen. All rights reserved.
//

#import "RITLContactManager.h"
#import "RITLContactObject.h"
#import "CNContactFetchRequest+RITLContactFile.h"
#import "RITLContactObjectManager.h"
@import Contacts;


@interface RITLContactManager ()

/// 请求通讯录数据的对象
@property (nonatomic, strong) CNContactStore * contactStore;

/// 获取到数据完成的回调
@property(nonatomic, copy)void (^completeBlock)(NSArray<RITLContactObject *> * _Nonnull);

/// 没有权限的回调
@property(nonatomic, copy)void (^defendBlock)(void);

@end

@implementation RITLContactManager



-(instancetype)init
{
    if (self = [super init])
    {
        //初始化CNContactStore
        self.contactStore = [CNContactStore new];
    }
    
    return self;
}

#pragma mark - public function

-(void)requestContactsComplete:(void (^)(NSArray <RITLContactObject *> *))completeBlock defendBlock:(void (^)(void))defendBlock
{
    //进行赋值
    self.completeBlock = completeBlock;
    self.defendBlock = defendBlock;
    
    //开始请求
    [self __checkAuthorizationStatus];
}

#pragma mark - private function
/**
 检测权限并作响应的操作
 */
- (void)__checkAuthorizationStatus
{
    switch ([CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts])
    {
            //存在权限
        case CNAuthorizationStatusAuthorized:
            //获取通讯录
            [self __obtainContacts];
            break;
            
            //权限未知
        case CNAuthorizationStatusNotDetermined:
            //请求权限
            [self __requestAuthorizationStatus];break;
            
            //如果没有权限
        case CNAuthorizationStatusRestricted:
        case CNAuthorizationStatusDenied://需要提示
            self.defendBlock();break;
    }
}


/**
 *  获取通讯录中的联系人
 */
- (void)__obtainContacts
{
    NSMutableArray <RITLContactObject *> * contacts = [NSMutableArray arrayWithCapacity:0];
    
    //获取联系人
    [self.contactStore enumerateContactsWithFetchRequest:[CNContactFetchRequest descriptorForAllKeys] error:nil usingBlock:^(CNContact * _Nonnull contact, BOOL * _Nonnull stop) {
       
        //进行对象的处理
        RITLContactObject * contactObject = [RITLContactObjectManager contantObject:contact];
        
        //
        [contacts addObject:contactObject];
        
    }];
    
    //block
    self.completeBlock([contacts mutableCopy]);
}




/**
 请求通讯录的权限
 */
- (void)__requestAuthorizationStatus
{
    //避免强引用
    __weak typeof(self) weakSelf = self;
    
    
    [self.contactStore requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
           
            //主线程调用
            if (granted == true)
            {
                [weakSelf __obtainContacts];
            }
            
            else
            {
                weakSelf.defendBlock();
            }
        });
    }];
}


@end
