//
//  UIAlertController+RITLContactFile.m
//  RITLContact_Demo
//
//  Created by YueWen on 2016/10/13.
//  Copyright © 2016年 YueWen. All rights reserved.
//

#import "UIAlertController+RITLContactFile.h"
#import "RITLContactObject.h"

@implementation UIAlertController (RITLContactFile)


#pragma mark - public function
+(instancetype)alertControllerWithContactObject:(RITLContactObject *)contactObject
{

    //Set initailtal value
    NSString * title = nil;
    UIAlertControllerStyle style = UIAlertControllerStyleAlert;
    
    if (contactObject.phoneObject.count ==0)//没有phone
    {
        title = [NSString stringWithFormat:@"%@没有电话号码",contactObject.nameObject.name];
    }
    
    else if(contactObject.hasMulitPhone == false)//只有一个phone
    {
        title = [NSString stringWithFormat:@"%@只有一个电话号码:%@",contactObject.nameObject.name,contactObject.phoneObject.firstObject.phoneNumber];
    }
    
    else//多个phone
    {
        title = [NSString stringWithFormat:@"%@有%@个电话号码",contactObject.nameObject.name,@(contactObject.phoneObject.count)];
        style = UIAlertControllerStyleActionSheet;
        
    }
    
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:nil message:title preferredStyle:style];
    
    if (contactObject.hasMulitPhone == true)
    {
        [self __addSheetAction:alertController Phones:contactObject.phoneObject];
    }
    
    else
    {
        [alertController addAction:[UIAlertAction actionWithTitle:@"Cancle" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
    }
    
    return alertController;
}


#pragma mark - private fucntion
+ (void)__addSheetAction:(UIAlertController *)alertController Phones:(NSArray<RITLContactPhoneObject *> *)phones
{
    for (RITLContactPhoneObject * phoneObject in phones)
    {
        UIAlertAction * action = [UIAlertAction actionWithTitle:phoneObject.phoneNumber style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
           
            NSLog(@"%@",action.title);
        }];
        
        [alertController addAction:action];
    }
    
    UIAlertAction * action = [UIAlertAction actionWithTitle:@"Cancle" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
       
        
    }];
    
    [alertController addAction:action];
}

@end
