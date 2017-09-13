//
//  YContactsTableViewController.m
//  YAddressBookDemo
//
//  Created by YueWen on 16/5/9.
//  Copyright © 2016年 YueWen. All rights reserved.
//

#import "RITLContactsTableViewController.h"
#import "RITLContactsManager.h"
#import "RITLContactObject.h"
#import "NSString+RITLContactFile.h"
#import "UIAlertController+RITLContactFile.h"



static NSString * const reuseIdentifier = @"RightCell";


@interface RITLContactsTableViewController ()

//存放联系人的数组，存放直接请求出的联系人数组
@property (nonatomic, copy)NSArray <RITLContactObject *> *  contactObjects;

//存放索引的数组，(e.g. A-Z,# in US/English)
@property (nonatomic, copy)NSArray <NSString *> * titles;

//存放处理过的数组
@property (nonatomic, copy)NSArray <NSArray *> * handleContactObjects;

//负责请求联系人对象
@property (nonatomic, strong) RITLContactsManager * contactManager;

@end


@implementation RITLContactsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //初始化属性
    self.contactManager = [[RITLContactsManager alloc]init];
    self.titles = [NSMutableArray arrayWithCapacity:0];
    
    //开始请求
    [self requestContacts];

}


//开始请求所有的联系人
- (void)requestContacts
{
    __weak typeof(self) copy_self = self;
    
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 90000
    
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

- (void)__reloadTableView:(NSArray <RITLContactObject *> *)contactObjects
{
    //开始赋值
    self.contactObjects = contactObjects;
    self.titles = [UILocalizedIndexedCollation currentCollation].sectionTitles;
    
    //刷新
    [self.tableView reloadData];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)dealloc
{
    NSLog(@"%@ dealloc",NSStringFromClass([self class]));
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    //返回首字母可能的个数
    return self.titles.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    //根据组数，获取每组联系人的数量
    return self.handleContactObjects[section].count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    //fetch Model
    RITLContactObject * contactObject = [self.handleContactObjects[indexPath.section] objectAtIndex:indexPath.row];
    
    //configture cell..
    cell.textLabel.text = contactObject.nameObject.name;
    cell.detailTextLabel.text = contactObject.phoneObject.firstObject.phoneNumber;
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //select cell coding...
    
    //get model
    RITLContactObject * contactObject = self.handleContactObjects[indexPath.section][indexPath.row];
    
    //进行判断
    [self presentViewController:[UIAlertController alertControllerWithContactObject:contactObject] animated:true completion:^{
        
    }];
    
    [tableView deselectRowAtIndexPath:indexPath animated:true];

}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [[[UILocalizedIndexedCollation currentCollation] sectionTitles] objectAtIndex:section];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return [[UILocalizedIndexedCollation currentCollation] sectionIndexTitles];
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    return [[UILocalizedIndexedCollation currentCollation] sectionForSectionIndexTitleAtIndex:index];
}



#pragma mark - <UITableViewDelegate>
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    //如果没有数据
    if (self.handleContactObjects[section].count == 0)
    {
        return 0;
    }
    return 15;
}





#pragma mark - Getter Function

#pragma mark - localizedCollation Setter
-(NSArray<NSArray *> *)handleContactObjects
{
    return [RITLContactSortManager defaultHandleContactObject:self.contactObjects];
}



- (IBAction)addContact:(id)sender
{
    UIButton * sendButton = (UIButton *)sender;
    
    //button不能再点击
    sendButton.enabled = false;
    
    [self.contactManager addContact:[RITLContactObject testContactObject]];
    
    //3s后才可再添加,为了能够承接3秒变化通知的响应
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
       
        [sendButton setEnabled:true];
        
    });
    
}


@end
