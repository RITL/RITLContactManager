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
#import "RITLContactObject+RITLContactFile.h"
#import "RITLContactCatcheManager.h"
#import "NSString+RITLContactFile.h"
#import "RITLContactCatcheManager.h"


@import Contacts;


@interface RITLContactManager ()

/// 表示是否已经做监听
@property (nonatomic, assign) BOOL notificationDidAdd;

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



-(instancetype)initContactDidChange:(void (^)(NSArray<RITLContactObject *> * _Nonnull))contactDidChange
{
    if (self = [self init])
    {
        self.contactDidChange = contactDidChange;
    }
    
    return self;
}


-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
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
            [self __obtainContacts:self.completeBlock];
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
- (void)__obtainContacts:(void (^)(NSArray<RITLContactObject *> * _Nonnull)) completeBlock
{
    if (self.notificationDidAdd == false)
    {
        //添加通知
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(__contactDidChange:) name:CNContactStoreDidChangeNotification object:nil];
        self.notificationDidAdd = !self.notificationDidAdd;
    }
    
    __weak typeof(self) weakSelf = self;
    
    //进行缓存
    [[RITLContactCatcheManager sharedInstace]startRequestIndentifiers:^(NSArray<NSString *> * _Nonnull identifiers) {

        NSArray * contacts = [weakSelf __contactHandleWithIdentifiers:identifiers];
        
        //主线程回调
        dispatch_async(dispatch_get_main_queue(), ^{
           
            completeBlock([contacts mutableCopy]);
            
        });
    }];
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
                [weakSelf __obtainContacts:weakSelf.completeBlock];
            }
            
            else
            {
                weakSelf.defendBlock();
            }
        });
    }];
}



/**
 通讯录发生变化进行的回调

 @param notication 发送的通知
 */
- (void)__contactDidChange:(NSNotification *)notication
{
    //重新获取通讯录
    if (self.contactDidChange != nil )
    {
        //重新加载缓存
        [[RITLContactCatcheManager sharedInstace]reloadContactIdentifiers:^(NSArray<NSString *> * _Nonnull identifiers) {
            
            NSArray * contacts = [self __contactHandleWithIdentifiers:identifiers];
            
            //回调
            self.contactDidChange([contacts mutableCopy]);
        }];
    }
    
}




/**
 将所有的identifiers转成RITLObject对象

 @param identifiers 存放identifiers的数组

 @return 初始化完毕的RITLContactObject数组
 */
- (NSArray <RITLContactObject *> *)__contactHandleWithIdentifiers:(NSArray <NSString *> *)identifiers
{
    NSMutableArray <RITLContactObject *> * contacts = [NSMutableArray arrayWithCapacity:0];
    
    for (NSString * identifier in identifiers)
    {
        CNContact * contact = [self.contactStore unifiedContactWithIdentifier:identifier keysToFetch:[NSString RITLContactAllKeys] error:nil];
        
        //进行对象的处理
        RITLContactObject * contactObject = [RITLContactObjectManager contantObject:contact];
        
        [contacts addObject:contactObject];
    }
    
    return [contacts mutableCopy];
}


@end
