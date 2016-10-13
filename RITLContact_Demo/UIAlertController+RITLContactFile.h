//
//  UIAlertController+RITLContactFile.h
//  RITLContact_Demo
//
//  Created by YueWen on 2016/10/13.
//  Copyright © 2016年 YueWen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RITLContactObject;

NS_ASSUME_NONNULL_BEGIN

@interface UIAlertController (RITLContactFile)


/**
 根据RITLContactObject初始化AlertController

 @param contactObject RITLContactObject对象

 @return 创建好的UIAlertController对象
 */
+(instancetype)alertControllerWithContactObject:(RITLContactObject *)contactObject;

@end

NS_ASSUME_NONNULL_END
