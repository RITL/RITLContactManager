//
//  RITLContacts.h
//  RITLContact_Demo
//
//  Created by YueWen on 2016/10/11.
//  Copyright © 2016年 YueWen. All rights reserved.
//

#ifndef RITLContacts_h
#define RITLContacts_h


#define isAvailableContactFramework ([UIDevice currentDevice].systemVersion.floatValue >= 9.0)
//#define isAvailableContactFramework (false)//调试AddressBook

#ifdef __IPHONE_9_0
    #define ContactFrameworkIsAvailable
#endif

#ifndef ContactFrameworkIsAvailable
#define RITLTESTNAME (@"RITLTestNameAddressBook")
#else
#define RITLTESTNAME (@"RITLTestNameContact")
#endif


#endif /* RITLContacts_h */
