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
    self.contactManager = [RITLContactsManager sharedInstance];
    self.titles = [NSMutableArray arrayWithCapacity:0];
    
    //开始请求
    [self requestContacts];

}


//开始请求所有的联系人
- (void)requestContacts
{
    __weak typeof(self) copy_self = self;
    
    //开始请求
    [self.contactManager requestContactsComplete:^(NSArray<RITLContactObject *> * _Nonnull contacts) {
        
        //开始赋值
        copy_self.contactObjects = contacts;
        copy_self.titles = [UILocalizedIndexedCollation currentCollation].sectionTitles;
        
        //刷新
        [copy_self.tableView reloadData];
        
    } defendBlock:^{
        
        //maybe you can present an AlerViewController to prompt user some message
        
    }];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)dealloc
{
 
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



@end
