//
//  ViewController.m
//  SortArrayTest
//
//  Created by MengLong Wu on 16/9/7.
//  Copyright © 2016年 MengLong Wu. All rights reserved.
//

#import "ViewController.h"
#import "ChineseToPinyin.h"
#define SHOW_ALERT(msg)    UIAlertView   *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];\
[alert show];
@interface ViewController ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>

@property (nonatomic,strong)UITableView *tableView;

@property (nonatomic,strong)NSMutableArray  *cityArray;

@property (nonatomic,strong)NSMutableArray  *titleArray;

@property (nonatomic,strong)NSMutableDictionary *cityDic;

@property (nonatomic,strong)NSMutableArray  *useArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addCity)];
    
    self.navigationItem.rightBarButtonItem = rightItem;
    
    _titleArray = [[NSMutableArray alloc]init];
    _cityArray = [[NSMutableArray alloc]init];
    _cityDic = [[NSMutableDictionary alloc]init];
    
    self.tableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStylePlain];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.view addSubview:_tableView];
    
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];

}
- (void)addCity
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"添加城市" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    
    [alert show];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
//        点击确定按钮
        UITextField *textField = [alertView textFieldAtIndex:0];

//        首先判断城市数组中时候存在该城市
        if ([_cityArray containsObject:textField.text]) {
            SHOW_ALERT(@"该城市已存在!");
            return;
        }
        
        [_cityArray addObject:textField.text];
        
        _cityDic = [self sectionOfTableViewWithCharacter];
        
        [_tableView reloadData];
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _cityDic.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *array = [[_cityDic allKeys] sortedArrayUsingSelector:@selector(compare:)];
    
    NSArray *rowArray = [_cityDic objectForKey:[array objectAtIndex:section]];
    
    return rowArray.count;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    
    NSArray *sortArray = [[_cityDic allKeys] sortedArrayUsingSelector:@selector(compare:)];
    
    return [sortArray objectAtIndex:section];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    NSArray *sortArray = [[_cityDic allKeys] sortedArrayUsingSelector:@selector(compare:)];
    
    cell.textLabel.text = [[_cityDic objectForKey:[sortArray objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];

    return cell;
}
- (nullable NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    NSArray *array = [_cityDic allKeys];
    
    array = [array sortedArrayUsingSelector:@selector(compare:)];
    return array;
}

- (NSMutableDictionary *)sectionOfTableViewWithCharacter
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    
    for (NSString *city in _cityArray) {
        NSString *pCity = [ChineseToPinyin pinyinFromChiniseString:city];
        
        NSString *firstLetter = [pCity substringWithRange:NSMakeRange(0, 1)];
        
        if (![dic objectForKey:firstLetter]) {
            NSMutableArray *array = [[NSMutableArray alloc]init];
            [dic setObject:array forKey:firstLetter];
        }
        
        [[dic objectForKey:firstLetter] addObject:city];
    }
    return dic;
}


















@end
