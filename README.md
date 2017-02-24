# RITLContactManager
一个整合AddressBook.framework以及Contact.framework的获取通讯录的Demo，目前iOS9.0之前会有内存泄露，努力更正..

Contacts.framework是Apple在 iOS9.0 替代AddressBook.framework的框架，至于AddressBook是做什么的框架，楼主默认开发者是知道的 O(∩_∩)O。

如果想了解AddressBook的使用欢迎查看一下楼主之前关于AddressBook的博文，本篇不做过多的缀余:
[iOS开发------获取系统联系人(AddressBook篇)](http://blog.csdn.net/runintolove/article/details/51371996)
[ iOS开发------操作通讯录(AddressBook篇)&通讯录UI(AddressBookUI篇)](http://blog.csdn.net/runintolove/article/details/51387594)

如果大家的项目还需要适配iOS8（当然，大多数公司肯定是也不会抛弃iOS7的用户），那么使用AddressBook是必然的；但如果在iOS9+的系统上，楼主还是非常建议使用最新的Contacts.framework框架的.

个人推荐的主要是下面两点原因(来源于楼主查看官方文档，编写Demo以及使用instruments的体会)：

1.  AddressBook与其他相关废弃框架相似一样 (ex:ALAsset-图片库)，语言风格更接近于C语言(当然也可以说就是C语言)，不在ARC管理之下(对于习惯使用ARC下的开发者算是不小的挑战)，使用不太便利并容易造成内存泄露。

2.  新的框架无论在查看开发文档、使用、读每次取速度还是灵活性都远好于废弃框架，内存泄露易于查找以及补漏。

介绍博文:[iOS开发------获取系统联系人(Contacts篇)](http://www.jianshu.com/p/fadeb914d1ed)
#预览图

左边为AddressBook框架进行的演示，右边为Contact框架进行的演示.
根据不同的版本进行自动适配，如果是iOS9，自动使用Contact.framework.

![使用AddressBook.framework](http://upload-images.jianshu.io/upload_images/1622004-546c0f8c0b597a77?imageMogr2/auto-orient/strip)

![使用Contacts.framework](http://upload-images.jianshu.io/upload_images/1622004-6f7f61fd6ddd8f31?imageMogr2/auto-orient/strip)



<br>
#权限描述

在iOS10上由于权限有很多的坑，本博文的内容需要使用通讯录权限.
那么不要忘记在项目的info.plist文件中加入如下描述：`Privacy - Contacts Usage Description`，描述字符串:`RITL want to use your Contacts（这个随意）`，尽可能的写点东西吧，听说如果不写上线可能会被Apple拒绝..

#用法如下:
```
//开始请求所有的联系人
- (void)requestContacts
{
    __weak typeof(self) copy_self = self;
    
#ifdef __IPHONE_9_0
    
    //设置便利属性，为了提升速度，只要姓名以及电话属性
    self.contactManager.descriptors = [NSString RITLContactNamePhoneKeys];
    
#endif
    
    //通讯发生变化进行的回调
    self.contactManager.contactDidChange = ^(NSArray <RITLContactObject *>* contacts){
      
        [copy_self __reloadTableView:contacts];
        
    };
    
    //开始请求
    [self.contactManager requestContactsComplete:^(NSArray<RITLContactObject *> * _Nonnull contacts) {
        
        [copy_self __reloadTableView:contacts];
        
    } defendBlock:^{
        
        //maybe you can present an AlerViewController to prompt user some message
        
    }];
}
```
