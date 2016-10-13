//
//  RITLContactCatcheManager.m
//  RITLContact_Demo
//
//  Created by YueWen on 2016/10/13.
//  Copyright © 2016年 YueWen. All rights reserved.
//

#import "RITLContactCatcheManager.h"

@import Contacts;

@interface RITLContactCatcheManager ()

/// 负责读取通讯的store
@property (nonatomic, strong) CNContactStore * contactStore;

/// 存放所有标志位的数组
@property (nonatomic, strong) NSMutableArray <NSString *> * multIdentifiers;

/// 是否应该缓存
@property (nonatomic, assign) BOOL shouldCatche;

@end

@implementation RITLContactCatcheManager


-(instancetype)init
{
    if (self = [super init])
    {
        _contactStore = [[CNContactStore alloc]init];
        _multIdentifiers = [NSMutableArray arrayWithCapacity:0];
        _shouldCatche = true;

    }
    
    return self;
}

+(instancetype)sharedInstace
{
    static RITLContactCatcheManager * manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        manager = [[RITLContactCatcheManager alloc]init];
        
    });
    
    return manager;
}

#pragma mark -


-(void)startRequestIndentifiers:(void (^)(NSArray<NSString *> * _Nonnull))completeBlock
{
    if (_multIdentifiers.count == 0)
    {
        //重新获取
        [self reloadContactIdentifiers:^(NSArray<NSString *> * _Nonnull contacts) {
           
            completeBlock(contacts); return;
            
        }];
    }
    
    //直接返回
    else completeBlock(self.identifiers);
}



-(void)reloadContactIdentifiers:(void (^)(NSArray<NSString *> * _Nonnull))completeBlock
{
    //移除所有的对象
    [_multIdentifiers removeAllObjects];
    
    __weak typeof(self) weakSelf = self;
    
        //异步读取所有的通讯录的identifier
        dispatch_queue_t contactQueue = dispatch_queue_create("RITLContactCatheQueue", NULL);
        dispatch_async(contactQueue, ^{
            
            //获取联系人
            [self.contactStore enumerateContactsWithFetchRequest:[[CNContactFetchRequest alloc]initWithKeysToFetch:@[CNContactIdentifierKey]] error:nil usingBlock:^(CNContact * _Nonnull contact, BOOL * _Nonnull stop) {
                
                //进行添加
                [weakSelf.multIdentifiers addObject:contact.identifier];
                
            }];
            
            //主线程完成之后进行回调
            dispatch_async(dispatch_get_main_queue(), ^{
                
                 completeBlock(self.identifiers);
                
            });
        });
}





#pragma mark - getter function

-(NSArray<NSString *> *)identifiers
{
    return [_multIdentifiers mutableCopy];
}


@end
