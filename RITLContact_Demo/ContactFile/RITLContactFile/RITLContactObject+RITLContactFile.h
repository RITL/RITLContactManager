//
//  RITLContactObject+RITLContactFile.h
//  RITLContact_Demo
//
//  Created by YueWen on 2016/10/11.
//  Copyright © 2016年 YueWen. All rights reserved.
//

#import "RITLContactObject.h"

NS_ASSUME_NONNULL_BEGIN

@class CNContact;

@interface NSObject (RITLContactFile)

- (void)contactObject:(CNContact *)contact NS_AVAILABLE_IOS(9_0);

@end

@interface RITLContactObject (RITLContactFile)

/**
 对象的标志位
 */
@property (nonatomic, strong) NSString * identifier NS_AVAILABLE_IOS(9_0);

@end


@interface RITLContactNameObject (RITLContactFile)

@end

NS_ASSUME_NONNULL_END
