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

//负责进行联系人分组的原生类
@property (nonatomic, strong)UILocalizedIndexedCollation * localizedCollation;

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
    self.localizedCollation = [UILocalizedIndexedCollation currentCollation];
    
    UILocalizedIndexedCollation * c = [[UILocalizedIndexedCollation alloc]init];
    NSLog(@"%@",@(c.sectionTitles.count));
    
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
        copy_self.titles = copy_self.localizedCollation.sectionTitles;
        
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
    //初始化数组返回的数组
    NSMutableArray <NSMutableArray *> * contacts = [NSMutableArray arrayWithCapacity:0];
    
    
    /**(注:)
     * 为什么不直接用27，而用count呢，这里取决于初始化方式
     * 初始化方式为[[Class alloc] init],那么这个count = 0
     * 初始化方式为[Class currentCollation],那么这个count = 27
     */
    
    /**** 根据UILocalizedIndexedCollation的27个Title放入27个存储数据的数组 ****/
    for (NSInteger i = 0; i < self.localizedCollation.sectionTitles.count; i++)
    {
        [contacts addObject:[NSMutableArray arrayWithCapacity:0]];
    }
    
    
    //开始遍历联系人对象，进行分组
    for (RITLContactObject * contactObject in self.contactObjects)
    {
        //获取名字在UILocalizedIndexedCollation标头的索引数
        NSInteger section = [self.localizedCollation sectionForObject:contactObject.nameObject collationStringSelector:@selector(name)];
        
        //根据索引在相应的数组上添加数据
        [contacts[section] addObject:contactObject];
    }
    
    
    //对每个同组的联系人进行排序
    for (NSInteger i = 0; i < self.localizedCollation.sectionTitles.count; i++)
    {
        //获取需要排序的数组
        NSMutableArray * tempMutableArray = contacts[i];
        
        //如果是直接的属性，直接用该方法排序即可，因为楼主自己构建的Model,name是Model的二级属性，所以此方法不能用
        //NSArray * sortArray = [self.localizedCollation sortedArrayFromArray:tempMutableArray collationStringSelector:@selector(name)];
        
        
        //这里因为需要通过nameObject的name进行排序，排序器排序(排序方法有好几种，楼主选择的排序器排序)
        NSSortDescriptor * sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"nameObject.name" ascending:true];
        [tempMutableArray sortUsingDescriptors:@[sortDescriptor]];
        contacts[i] = tempMutableArray;
        
    }
    
    //返回
    return [NSArray arrayWithArray:contacts];
}



@end
