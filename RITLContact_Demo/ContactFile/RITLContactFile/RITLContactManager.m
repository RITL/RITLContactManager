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

#pragma 由于暂时无法解决通知多次响应的问题，以3s为限制，只响应一次通知回调
/// 表示是否响应监听回调
@property (nonatomic, assign, getter=shouldResponseContactChange) BOOL responseContactChange;

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
        self.responseContactChange = true;
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


-(NSArray<id<CNKeyDescriptor>> *)descriptors
{
    if (_descriptors == nil)
    {
        return [NSString RITLContactAllKeys];
    }
    
    return _descriptors;
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
    [self __addStoreDidChangeNotification];
    
    __weak typeof(self) weakSelf = self;
    
    //进行缓存
    [[RITLContactCatcheManager sharedInstace]startRequestIndentifiers:^(NSArray<NSString *> * _Nonnull identifiers) {

        NSArray * contacts = [weakSelf __contactHandleWithIdentifiers:identifiers];
        
        completeBlock([contacts mutableCopy]);

    }];
}



/**
 添加变化监听
 */
- (void)__addStoreDidChangeNotification
{
    if (self.notificationDidAdd == false)
    {
        //添加通知
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(__contactDidChange:) name:CNContactStoreDidChangeNotification object:nil];
        self.notificationDidAdd = !self.notificationDidAdd;
    }
    
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
        //如果可以进行回调
        if (self.shouldResponseContactChange == true)
        {
            //重新加载缓存
            [[RITLContactCatcheManager sharedInstace]reloadContactIdentifiers:^(NSArray<NSString *> * _Nonnull identifiers) {
                
                NSArray * contacts = [self __contactHandleWithIdentifiers:identifiers];
                
                //回调
                self.contactDidChange([contacts mutableCopy]);
            }];
            
            self.responseContactChange = false;
            
            //延迟3s
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                self.responseContactChange = true;
                
            });
        }

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
        CNContact * contact = [self.contactStore unifiedContactWithIdentifier:identifier keysToFetch:self.descriptors error:nil];
        
        //进行对象的处理
        RITLContactObject * contactObject = [RITLContactObjectManager contantObject:contact];
        
        [contacts addObject:contactObject];
    }
    
    return [contacts mutableCopy];
}

@end


@implementation RITLContactManager (RITLAddContact)

-(void)addContact:(RITLContactObject *)contact
{
    NSLog(@"RITLContactManager add contact");
}

@end
