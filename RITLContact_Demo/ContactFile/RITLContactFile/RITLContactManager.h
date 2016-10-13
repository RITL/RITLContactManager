//
//  RITLContactsManager.h
//  RITLContact_Demo
//
//  Created by YueWen on 2016/10/11.
//  Copyright © 2016年 YueWen. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class RITLContactObject;
@protocol CNKeyDescriptor;


/**
 针对Contacts.framework进行请求数据的类
 */
NS_CLASS_AVAILABLE_IOS(9_0) @interface RITLContactManager : NSObject


/**
 想要获得的键值描述，详见NSString+RITLContactFile.m 或者 CNContact.h,默认为RITLContactAllKeys
 */
@property (nonatomic, copy)NSArray <id<CNKeyDescriptor>> * descriptors;

/**
 发生变化的回调,返回更新后的数组
 */
@property (nonatomic, copy)void(^contactDidChange)(NSArray<RITLContactObject *>*);


/**
 便利初始化方法

 @param contactDidChange 发生变化进行的回调

 @return RITLContactManager初始化完毕的RITLContactManager对象
 */
-(instancetype)initContactDidChange:(void(^)(NSArray<RITLContactObject *>*)) contactDidChange;


/**
 请求所有的联系人,按照添加人的时间顺序
 
 @param completeBlock 获取到数据完成的回调
 @param defendBlock   没有权限进行的回调
 */
- (void)requestContactsComplete:(void (^)(NSArray <RITLContactObject *> *))completeBlock defendBlock:(void(^)(void)) defendBlock;


@end

NS_ASSUME_NONNULL_END
