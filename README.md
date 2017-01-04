# RITLContactManager
一个整合AddressBook.framework以及Contact.framework的获取通讯录的Demo，目前iOS9.0之前会有内存泄露，努力更正..

Contacts.framework是Apple在 iOS9.0 替代AddressBook.framework的框架，至于AddressBook是做什么的框架，楼主默认看到博文的开发者是知道的 O(∩_∩)O。

如果想了解AddressBook的使用欢迎查看一下楼主之前关于AddressBook的博文，本篇不做过多的缀余:
[iOS开发------获取系统联系人(AddressBook篇)](http://blog.csdn.net/runintolove/article/details/51371996)
[ iOS开发------操作通讯录(AddressBook篇)&通讯录UI(AddressBookUI篇)](http://blog.csdn.net/runintolove/article/details/51387594)

每次iOS发布新的版本(甚至每年的WWDC大会举行完毕)很多敏锐的开发者都准备或者对新版本特性进行适配。当然这些大神肯定会在iOS9发布后在第一时间对通讯录功能进行适配，一些稍微不太敏锐的开发者鉴于AddressBook在iOS9下初次提醒以及讨厌适配的繁琐，也就不以为然。

但随着iOS10的发布，那么适配相关框架就显得格外重要（不是说AddressBook不能使用了，但为了项目的健壮性以及良好的体验性，还是非常建议第一时间适配的。当然，这句话不仅限于Contacts部分）。

如果大家的项目还需要适配iOS8（当然，大多数公司肯定是也不会抛弃iOS7的用户），那么使用AddressBook是必然的；但如果在iOS9+的系统上，楼主还是非常建议使用最新的Contacts.framework框架的.

个人推荐的主要是下面两点原因(来源于楼主查看官方文档，编写Demo以及使用instruments的体会)：

1.  AddressBook与其他相关废弃框架相似一样 (ex:ALAsset-图片库)，语言风格更接近于C语言(当然也可以说就是C语言)，不在ARC管理之下(对于习惯使用ARC下的开发者算是不小的挑战)，使用不太便利并容易造成内存泄露。

2.  新的框架无论在查看开发文档、使用、读取速度还是灵活性都远好于废弃框架，内存泄露易于查找以及补漏。


[这里还是要分享一下源码，楼主整合AddressBook.framework以及Contacts.framework的DEMO](https://github.com/RITL/RITLContactManager)
<br>
#预览图

左边为AddressBook框架进行的演示，右边为Contact框架进行的演示.
根据不同的版本进行自动适配，如果是iOS9，自动使用Contact.framework.

![使用AddressBook.framework](http://upload-images.jianshu.io/upload_images/1622004-546c0f8c0b597a77?imageMogr2/auto-orient/strip)

![使用Contacts.framework](http://upload-images.jianshu.io/upload_images/1622004-6f7f61fd6ddd8f31?imageMogr2/auto-orient/strip)



<br>
#权限描述

在iOS10上由于权限有很多的坑，本博文的内容需要使用通讯录权限.
那么不要忘记在项目的info.plist文件中加入如下描述：`Privacy - Contacts Usage Description`，描述字符串:`RITL want to use your Contacts（这个随意）`，尽可能的写点东西吧，听说如果不写上线可能会被Apple拒绝..
<br>
#获取权限-CNContactStore

负责获得权限、请求权限以及执行操作请求的类就是`CNContactStore`，具体Demo中的代码如下：
```
/**
 检测权限并作响应的操作
 */
- (void)__checkAuthorizationStatus
{
	//这里有一个枚举类:CNEntityType,不过没关系，只有一个值:CNEntityTypeContacts
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
```
<br>
#请求联系人列表-CNContactStore

这里有几种比较常用的思路

1.使用自带的枚举方法一次性获得所有的属性
```
// 使用枚举方法对所有的联系人对象(CNContact)进行列出，该方法是同步的
- (BOOL)enumerateContactsWithFetchRequest:(CNContactFetchRequest *)fetchRequest
                                    error:(NSError *__nullable *__nullable)error
                               usingBlock:(void (^)(CNContact *contact, BOOL *stop))block;
```
2.先获取所有联系人的identifier，再根据identifier读取联系人信息(Demo中使用的该思路)
```
// 通过identifer获得一个唯一的CNContact
- (nullable CNContact *)unifiedContactWithIdentifier:(NSString *)identifier
                                         keysToFetch:(NSArray<id<CNKeyDescriptor>> *)keys
                                               error:(NSError *__nullable *__nullable)error;
```
<br>
##遍历请求类-CNContactFetchRequest

感觉这里介绍一下`CNContactFetchRequest`类还是有必要的，毕竟当初在这里也是浪费了点时间，它是一个遍历请求的类，我们可以通过初始化该类的实例对象，告诉contactStore我们需要遍历contact的某些属性:
```
//实例化CNContactFetchRequest对象,通过一个遍历键的描述数组
- (instancetype)initWithKeysToFetch:(NSArray <id<CNKeyDescriptor>>*)keysToFetch NS_DESIGNATED_INITIALIZER;
```
<br>
##键值描述协议-CNKeyDescriptor

如果我们单纯的进入开发文档，我们会发现他是一个空协议，刚开始看到这里的时候楼主表示很蒙B
```
//没有任何的required和optional方法
@protocol CNKeyDescriptor <NSObject, NSSecureCoding, NSCopying>
@end
```
但很快就发现了下面这个Category
```
// //Allows contact property keys to be used with keysToFetch.
// 允许contact的属性键作为遍历的键
@interface NSString (Contacts) <CNKeyDescriptor>
@end
```
如果还是有点疑惑，那么相信看到下面就不会再有困惑了呢。没错，可以直接将下列字符串当成CNKeyDescriptor对象写入数组
```
//标识符
CONTACTS_EXTERN NSString * const CNContactIdentifierKey                      NS_AVAILABLE(10_11, 9_0);
//姓名前缀
CONTACTS_EXTERN NSString * const CNContactNamePrefixKey                      NS_AVAILABLE(10_11, 9_0);
//姓名
CONTACTS_EXTERN NSString * const CNContactGivenNameKey                       NS_AVAILABLE(10_11, 9_0);
//中间名
CONTACTS_EXTERN NSString * const CNContactMiddleNameKey                      NS_AVAILABLE(10_11, 9_0);
//姓氏
CONTACTS_EXTERN NSString * const CNContactFamilyNameKey                      NS_AVAILABLE(10_11, 9_0);
//之前的姓氏(ex:国外的女士)
CONTACTS_EXTERN NSString * const CNContactPreviousFamilyNameKey              NS_AVAILABLE(10_11, 9_0);
//姓名后缀
CONTACTS_EXTERN NSString * const CNContactNameSuffixKey                      NS_AVAILABLE(10_11, 9_0);
//昵称
CONTACTS_EXTERN NSString * const CNContactNicknameKey                        NS_AVAILABLE(10_11, 9_0);
//公司(组织)
CONTACTS_EXTERN NSString * const CNContactOrganizationNameKey                NS_AVAILABLE(10_11, 9_0);
//部门
CONTACTS_EXTERN NSString * const CNContactDepartmentNameKey                  NS_AVAILABLE(10_11, 9_0);
//职位
CONTACTS_EXTERN NSString * const CNContactJobTitleKey                        NS_AVAILABLE(10_11, 9_0);
//名字的拼音或音标
CONTACTS_EXTERN NSString * const CNContactPhoneticGivenNameKey               NS_AVAILABLE(10_11, 9_0);
//中间名的拼音或音标
CONTACTS_EXTERN NSString * const CNContactPhoneticMiddleNameKey              NS_AVAILABLE(10_11, 9_0);
//形式的拼音或音标
CONTACTS_EXTERN NSString * const CNContactPhoneticFamilyNameKey              NS_AVAILABLE(10_11, 9_0);
//公司(组织)的拼音或音标(iOS10 才开始存在的呢)
CONTACTS_EXTERN NSString * const CNContactPhoneticOrganizationNameKey        NS_AVAILABLE(10_12, 10_0);
//生日
CONTACTS_EXTERN NSString * const CNContactBirthdayKey                        NS_AVAILABLE(10_11, 9_0);
//农历
CONTACTS_EXTERN NSString * const CNContactNonGregorianBirthdayKey            NS_AVAILABLE(10_11, 9_0);
//备注
CONTACTS_EXTERN NSString * const CNContactNoteKey                            NS_AVAILABLE(10_11, 9_0);
//头像
CONTACTS_EXTERN NSString * const CNContactImageDataKey                       NS_AVAILABLE(10_11, 9_0);
//头像的缩略图
CONTACTS_EXTERN NSString * const CNContactThumbnailImageDataKey              NS_AVAILABLE(10_11, 9_0);
//头像是否可用
CONTACTS_EXTERN NSString * const CNContactImageDataAvailableKey              NS_AVAILABLE(10_12, 9_0);
//类型
CONTACTS_EXTERN NSString * const CNContactTypeKey                            NS_AVAILABLE(10_11, 9_0);
//电话号码
CONTACTS_EXTERN NSString * const CNContactPhoneNumbersKey                    NS_AVAILABLE(10_11, 9_0);
//邮箱地址
CONTACTS_EXTERN NSString * const CNContactEmailAddressesKey                  NS_AVAILABLE(10_11, 9_0);
//住址
CONTACTS_EXTERN NSString * const CNContactPostalAddressesKey                 NS_AVAILABLE(10_11, 9_0);
//其他日期
CONTACTS_EXTERN NSString * const CNContactDatesKey                           NS_AVAILABLE(10_11, 9_0);
//url地址
CONTACTS_EXTERN NSString * const CNContactUrlAddressesKey                    NS_AVAILABLE(10_11, 9_0);
//关联人
CONTACTS_EXTERN NSString * const CNContactRelationsKey                       NS_AVAILABLE(10_11, 9_0);
//社交
CONTACTS_EXTERN NSString * const CNContactSocialProfilesKey                  NS_AVAILABLE(10_11, 9_0);
//即时通信
CONTACTS_EXTERN NSString * const CNContactInstantMessageAddressesKey         NS_AVAILABLE(10_11, 9_0);
```
<br>
#获取联系人姓名属性

```
// RITLContactNameObject获取姓名属性的类目方法
-(void)contactObject:(CNContact *)contact
{
    [super contactObject:contact];
    
    //设置姓名属性
    self.nickName = contact.nickname;                   //昵称
    self.givenName = contact.givenName;                 //名字
    self.familyName = contact.familyName;               //姓氏
    self.middleName = contact.middleName;               //中间名
    self.namePrefix = contact.namePrefix;               //名字前缀
    self.nameSuffix = contact.nameSuffix;               //名字的后缀
    self.phoneticGivenName = contact.phoneticGivenName; //名字的拼音或音标
    self.phoneticFamilyName = contact.phoneticFamilyName;//姓氏的拼音或音标
    self.phoneticMiddleName = contact.phoneticMiddleName;//中间名的拼音或音标
    
#ifdef __IPHONE_10_0
    self.phoneticOrganizationName = contact.phoneticOrganizationName;//公司(组织)的拼音或音标
#endif
}
```

<br>
#获取联系人的类型

这里需要判断一下该属性是否可用（不只该属性，所有的属性都应先判断一下）不然会抛出异常.
```
/**
 *  获得联系人类型信息
 */
+ (RITLContactType)__contactTypeProperty
{
    if (![self.currentContact isKeyAvailable:CNContactTypeKey])
    {
        return RITLContactTypeUnknown;//没有可用就是未知
    }
    
    else if (self.currentContact.contactType == CNContactTypeOrganization)
    {
        return RITLContactTypeOrigination;//如果是组织
    }
    
    else{
        return RITLContactTypePerson;
    }
}
```
<br>
#获得联系人的头像图片
```
/**
 *  获得联系人的头像图片
 */
+ (UIImage * __nullable)__contactHeadImagePropery
{
    //缩略图Data
    if ([self.currentContact isKeyAvailable:CNContactThumbnailImageDataKey])
    {
        NSData * thumImageData = self.currentContact.thumbnailImageData;
        
        return [UIImage imageWithData:thumImageData];
    }
    return nil;
}
```
<br>
#获取联系人的电话信息
```
/**
 *  获得电话号码对象数组
 */
+ (NSArray <RITLContactPhoneObject *> *)__contactPhoneProperty
{
    
    if (![self.currentContact isKeyAvailable:CNContactPhoneNumbersKey])
    {
        return @[];
    }
    
    //外传数组
    NSMutableArray <RITLContactPhoneObject *> * phones = [NSMutableArray arrayWithCapacity:self.currentContact.phoneNumbers.count];
    
    for (CNLabeledValue * phoneValue in self.currentContact.phoneNumbers)
    {
        //初始化PhoneObject对象
        RITLContactPhoneObject * phoneObject = [RITLContactPhoneObject new];
        
        //setValue
        phoneObject.phoneTitle = [CNLabeledValue localizedStringForLabel:phoneValue.label];
        phoneObject.phoneNumber = ((CNPhoneNumber *)phoneValue.value).stringValue;
        
        [phones addObject:phoneObject];
    }
    
    return [NSArray arrayWithArray:phones];
}
```

<br>
#获取联系人的工作信息
```
/**
 *  获得工作的相关属性
 */
+ (RITLContactJobObject *)__contactJobProperty
{
    RITLContactJobObject * jobObject = [[ RITLContactJobObject alloc]init];
    
    if ([self.currentContact isKeyAvailable:CNContactJobTitleKey])
    {
        //setValue
        jobObject.jobTitle = self.currentContact.jobTitle;
        jobObject.departmentName = self.currentContact.departmentName;
        jobObject.organizationName = self.currentContact.organizationName;
    }

    return jobObject;
}
```
<br>
#获取联系人的邮件信息
```
/**
 *  获得Email对象的数组
 */
+ (NSArray <RITLContactEmailObject *> *)__contactEmailProperty
{
    if (![self.currentContact isKeyAvailable:CNContactEmailAddressesKey])
    {
        return @[];
    }
    
    //外传数组
    NSMutableArray <RITLContactEmailObject *> * emails = [NSMutableArray arrayWithCapacity:self.currentContact.emailAddresses.count];
    
    for (CNLabeledValue * emailValue in self.currentContact.emailAddresses)
    {
        //初始化RITLContactEmailObject对象
        RITLContactEmailObject * emailObject = [[RITLContactEmailObject alloc]init];
        
        //setValue
        emailObject.emailTitle =  [CNLabeledValue localizedStringForLabel:emailValue.label];
        emailObject.emailAddress = emailValue.value;
        
        [emails addObject:emailObject];
        
    }
    
    return [NSArray arrayWithArray:emails];
}
```
<br>
#获取联系人的地址信息
```
/**
 *  获得Address对象的数组
 */
+ (NSArray <RITLContactAddressObject *> *)__contactAddressProperty
{
    if (![self.currentContact isKeyAvailable:CNContactPostalAddressesKey]) {
        
        return @[];
        
    }
    
    //外传数组
    NSMutableArray <RITLContactAddressObject *> * addresses = [NSMutableArray arrayWithCapacity:self.currentContact.postalAddresses.count];
    
    for (CNLabeledValue * addressValue in self.currentContact.postalAddresses)
    {
        //初始化地址对象
        RITLContactAddressObject * addressObject = [[RITLContactAddressObject alloc]init];
        
        //setValues
        addressObject.addressTitle =  [CNLabeledValue localizedStringForLabel:addressValue.label];
        
        //setDetailValue
        [addressObject contactObject:addressValue.value];
        
        //add object
        [addresses addObject:addressObject];
    }
    
    return [NSArray arrayWithArray:addresses];
}
```
<br>
#获得联系人的生日信息
```
/**
 *  获得生日的相关属性
 */
+ (RITLContactBrithdayObject *)__contactBrithdayProperty
{
    //实例化对象
    RITLContactBrithdayObject * brithdayObject = [[RITLContactBrithdayObject alloc]init];
    
    
    if ([self.currentContact isKeyAvailable:CNContactBirthdayKey])
    {
        //set value
        brithdayObject.brithdayDate = [self.currentContact.birthday.calendar dateFromComponents:self.currentContact.birthday];
        brithdayObject.leapMonth = self.currentContact.birthday.isLeapMonth;
    }

    if ([self.currentContact isKeyAvailable:CNContactNonGregorianBirthdayKey])
    {
        brithdayObject.calendar = self.currentContact.nonGregorianBirthday.calendar.calendarIdentifier;
        brithdayObject.era = self.currentContact.nonGregorianBirthday.era;
        brithdayObject.day = self.currentContact.nonGregorianBirthday.day;
        brithdayObject.month = self.currentContact.nonGregorianBirthday.month;
        brithdayObject.year = self.currentContact.nonGregorianBirthday.year;
    }

    //返回对象
    return brithdayObject;
}
```
<br>
#获取联系人的即时通信信息
```
/**
 *  获得即时通信账号相关信息
 */
+ (NSArray <RITLContactInstantMessageObject *> *)__contactMessageProperty
{
    if (![self.currentContact isKeyAvailable:CNContactInstantMessageAddressesKey])
    {
        return @[];
    }
    
    //存放数组
    NSMutableArray <RITLContactInstantMessageObject *> * instantMessages = [NSMutableArray arrayWithCapacity:self.currentContact.instantMessageAddresses.count];
    
    for (CNLabeledValue * instanceAddressValue in self.currentContact.instantMessageAddresses)
    {
        RITLContactInstantMessageObject * instaceObject = [[RITLContactInstantMessageObject alloc]init];
        
        //set value
        instaceObject.identifier = instanceAddressValue.identifier;
        instaceObject.service = ((CNInstantMessageAddress *)instanceAddressValue.value).service;
        instaceObject.userName = ((CNInstantMessageAddress *)instanceAddressValue.value).username;
        
        //add
        [instantMessages addObject:instaceObject];
    }
    
    return [NSArray arrayWithArray:instantMessages];
}
```
<br>
#获得联系人的关联人信息
```
/**
 *  获得联系人的关联人信息
 */
+ (NSArray <RITLContactRelatedNamesObject *> *)__contactRelatedNamesProperty
{
    if (![self.currentContact isKeyAvailable:CNContactRelationsKey])
    {
        return @[];
    }
    
    //存放数组
    NSMutableArray <RITLContactRelatedNamesObject *> * relatedNames = [NSMutableArray arrayWithCapacity:self.currentContact.contactRelations.count];
    
    for (CNLabeledValue * relationsValue in self.currentContact.contactRelations)
    {
        RITLContactRelatedNamesObject * relatedObject = [[RITLContactRelatedNamesObject alloc]init];
        
        //set value
        relatedObject.identifier = relationsValue.identifier;
        relatedObject.relatedTitle =  [CNLabeledValue localizedStringForLabel:relationsValue.label];
        relatedObject.relatedName = ((CNContactRelation *)relationsValue.value).name;
        
        [relatedNames addObject:relatedObject];
        
    }

    return [NSArray arrayWithArray:relatedNames];
}
```
<br>
#获取联系人的社交简介信息
```
/**
 *  获得联系人的社交简介信息
 */
+ (NSArray <RITLContactSocialProfileObject *> *)__contactSocialProfilesProperty
{
    if (![self.currentContact isKeyAvailable:CNContactSocialProfilesKey])
    {
        return @[];
    }
    
    //外传数组
    NSMutableArray <RITLContactSocialProfileObject *> * socialProfiles = [NSMutableArray arrayWithCapacity:self.currentContact.socialProfiles.count];
    
    for (CNLabeledValue * socialProfileValue in self.currentContact.socialProfiles) {
        
        RITLContactSocialProfileObject * socialProfileObject = [[RITLContactSocialProfileObject alloc]init];
        
        //获得CNSocialProfile对象
        CNSocialProfile * socialProfile = socialProfileValue.value;

        //set value
        socialProfileObject.identifier = socialProfileValue.identifier;
        socialProfileObject.socialProfileTitle = socialProfile.service;
        socialProfileObject.socialProFileAccount = socialProfile.username;
        socialProfileObject.socialProFileUrl = socialProfile.urlString;
        
        [socialProfiles addObject:socialProfileObject];
    }
    
    return [NSArray arrayWithArray:socialProfiles];
}
```
<br>
#获取联系人的备注信息
```
/**
 获得联系人的备注信息
 */
+ (NSString * __nullable)__contactNoteProperty
{
    if ([self.currentContact isKeyAvailable:CNContactNoteKey])
    {
        return self.currentContact.note;
    }
    
    return nil;
}
```
<br>
#接收外界通讯录发生变化的方法

这里不再是直接使用C语言的函数赋址来进行方法注册，方法更加的ObjC，选用了更多的通知中心。
```
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
```
下面是执行变化后的方法:

楼主的测试的时候通讯录变化会连续触发3次通知方法，后面的延迟3s就是解决连续触发的问题，也不知道是个人的程序出问题还是Contact框架的bug，如果大家有什么好办法或者什么好的建议，也请告知一下，十分感谢。
```
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

```
