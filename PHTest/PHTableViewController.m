
//
//  PHTableViewController.m
//  PHTest
//
//  Created by Kowloon on 16/7/28.
//  Copyright © 2016年 haohua pan. All rights reserved.
//

#import "PHTableViewController.h"
#import "YJQInfo.h"
#import "PHReactiveCocoaController.h"
#import "AFNetworking.h"
#import "PHTargetProxy.h"

@interface PHTableViewController ()

@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, weak) YJQInfo *selectInfo;
@property (nonatomic, strong) UITextField *titleTextField;
@property (nonatomic, strong) UIButton *leftBtn;

@end

@implementation PHTableViewController

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = @[].mutableCopy;
    }
    return _dataSource;
}

- (void)proxyLearn {
    
    // Create an empty mutable string, which will be one of the
    
    // real objects for the proxy.
    
    NSMutableString *string = [[NSMutableString alloc] init];
    
    
    
    // Create an empty mutable array, which will be the other
    
    // real object for the proxy.
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    
    
    // Create a proxy to wrap the real objects.  This is rather
    
    // artificial for the purposes of this example -- you'd rarely
    
    // have a single proxy covering two objects.  But it is possible.
    
    id proxy = [[PHTargetProxy alloc] initWithTarget1:string target2:array];
    
    
    
    // Note that we can't use appendFormat:, because vararg methods
    
    // cannot be forwarded!
    
    [proxy appendString:@"This "];
    
    [proxy appendString:@"is "];
    
    [proxy addObject:string];
    
    [proxy appendString:@"a "];
    
    [proxy appendString:@"test!"];
    
    if ([[proxy objectAtIndex:0] isEqualToString:@"This is a test!"]) {
        
        NSLog(@"Appending successful.%@", proxy);
        
    } else {
        
        NSLog(@"Appending failed, got: '%@'", proxy);
        
    }
    NSLog(@"Example finished without errors.");
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self proxyLearn];
    UITextField *titleTF = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 250, 30)];
    titleTF.borderStyle = UITextBorderStyleRoundedRect;
    titleTF.textColor = [UIColor redColor];
    titleTF.textAlignment = NSTextAlignmentCenter;
    NSString *string = [[NSUserDefaults standardUserDefaults] objectForKey:@"codeNum"];
    if (string.length != 0) {
        titleTF.text = string;//@"82013634018376735745"
    } else {
        titleTF.text = @"82013634018376735645";
    }
    self.navigationItem.titleView = titleTF;
    self.titleTextField = titleTF;
    
    
    UIButton *label = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 35, 35)];
    [label setBackgroundColor:[UIColor purpleColor]];
    [label addTarget:self action:@selector(leftBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [label setTitle:@"Start" forState:UIControlStateNormal];
    [label setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:label];
    self.navigationItem.leftBarButtonItem = leftItem;
    self.leftBtn = label;
    
    UIBarButtonItem *addItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addClick)];
    self.navigationItem.rightBarButtonItem = addItem;
    
    [self addUserName];
}

- (void)leftBtnClick {
    [self scanMethod];
}

- (void)addClick {
    NSString *userId = self.selectInfo.userId;//159
    if (userId.length == 0) return;
    NSDictionary *parameters = @{@"userId": userId};
    NSString *host = @"http://139.196.109.201/app/scanWxForward.do";
    [self af_RequestOperationManagerWithHost:host para:parameters json:YES];
}

- (void)scanMethod {
    NSString *scanHost = @"http://139.196.109.201/app/scanmedcodeUpgrade.do";
    NSString *meCode = [NSString stringWithFormat:@"code%@", self.titleTextField.text];
    NSString *userId = self.selectInfo.userId;//159
    if (userId.length == 0) return;
    NSDictionary *parameters = @{@"sessionid": @"",
                                 @"medCode": meCode,
                                 @"userId": userId,
                                 @"userType": @"1"};
    [self af_RequestOperationManagerWithHost:scanHost para:parameters];
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    YJQInfoGroup *group = [self.dataSource objectAtIndex:section];
    return group.infos.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    YJQInfoGroup *group = [self.dataSource objectAtIndex:section];
    return group.header;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([self class])];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:NSStringFromClass([self class])];
    }
    YJQInfoGroup *group = [self.dataSource objectAtIndex:indexPath.section];
    YJQInfo *model = [group.infos objectAtIndex:indexPath.row];
    cell.textLabel.text = model.userName;
    NSString *name = [model.bankInfos.firstObject name];
    NSString *bankName = [model.bankInfos.firstObject bankName];
    if (model.balance) {
        cell.textLabel.text = [NSString stringWithFormat:@"%@__%@__%@__%@",model.userName, model.balance, (name ?: @"无"), (bankName ?: @"无")];
    }
    if (model.userId) {
        cell.detailTextLabel.text = model.userId;
    } else {
        cell.detailTextLabel.text = model.password;
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    YJQInfoGroup *group = [self.dataSource objectAtIndex:indexPath.section];
    YJQInfo *model = [group.infos objectAtIndex:indexPath.row];
    self.selectInfo = model;
    [model withdrawMethod];
#if 1
    [self addClick];
#else
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    PHReactiveCocoaController *vc = [storyboard instantiateViewControllerWithIdentifier:@"PHReactiveCocoaController"];
    vc.yjqModel = model;
    [self.navigationController pushViewController:vc animated:YES];
#endif
}

- (void)af_RequestOperationManagerWithHost:(NSString *)host para:(NSDictionary *)para json:(BOOL)json{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    if (json) {
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
    } else {
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    }
    NSData *data = [NSJSONSerialization dataWithJSONObject:para options:NSJSONWritingPrettyPrinted error:nil];
    NSString *requestString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSMutableDictionary *mparas = @{}.mutableCopy;
    [mparas setObject:requestString forKey:@"jsonString"];
    [manager POST:host parameters:mparas.copy success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSLog(@"%@", responseObject);
        NSString *message = responseObject[@"message"];
        NSLog(@"%@", message);
        NSDictionary *data = responseObject[@"data"];
        if (data) {
            NSString *info = data[@"info"];
            NSLog(@"%@", info);
            if ([info containsString:@"此药品监管码已被扫描"]) {
                [self indexValueChanged];
            }
        }
        if ([message isEqualToString:@"使用成功"]) {
            [self indexValueChanged];
        } else {
            [self.leftBtn setTitle:@"N" forState:UIControlStateNormal];
            [self.leftBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        }
        
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        NSLog(@"%@", error);
    }];
}

- (void)indexValueChanged {
    NSString *string = self.titleTextField.text;
    NSInteger len = 4;
    NSInteger loc = string.length - len;
    NSRange range = NSMakeRange(loc, len);
    NSString *settleStr = [string substringWithRange:range];
    NSInteger index = [settleStr integerValue];
    index++;
    settleStr = [NSString stringWithFormat:@"%@",@(index)];
    NSMutableString *mustring = string.mutableCopy;
    [mustring replaceCharactersInRange:range withString:settleStr];
    self.titleTextField.text = mustring.copy;
    [[NSUserDefaults standardUserDefaults] setObject:mustring.copy forKey:@"codeNum"];
    [self.leftBtn setTitle:@"Y" forState:UIControlStateNormal];
    [self.leftBtn setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
}

- (void)af_RequestOperationManagerWithHost:(NSString *)host para:(NSDictionary *)para {
    [self af_RequestOperationManagerWithHost:host para:para json:NO];
}



- (void)addUserName {
    [self.dataSource addObject:[self userInfosWithUserName:@[@"15818572527",
                                                             @"15636404297"]
                                                   userIds:nil//@[@"fdc2c531-dc9c-4388-8b25-f698eafe43ae"]
                                                  password:@"ygphh383509677H"
                                                    header:@"PHH"]];
    [self.dataSource addObject:[self userInfosWithUserName:@[@"15970179507",
                                                             @"15814465582"]
                                                   userIds:@[@"d4061d1b-7598-41b8-8ed5-ff8fa25fd389",
                                                             @"54b5b46c-9d3c-4900-b64c-7abdf7adae42"]
                                                  password:@"123456"
                                                    header:@"One"]];
//    [self.dataSource addObject:[self userInfosWithUserName:@[@"15970179507"]
//                                                   userIds:@[@"d4061d1b-7598-41b8-8ed5-ff8fa25fd389"]
//                                                  password:@"123456"
//                                                    header:@"One2"]];

    [self.dataSource addObject:[self userInfosWithUserName:@[@"17895331630",
                                                             @"17865901923",
                                                             @"15718243730",
                                                             @"13265089060",
                                                             @"13160046572",
                                                             @"13728475009",
                                                             @"15606880784"]
                                                   userIds:@[@"2ec21dd6-5f2a-4725-a843-61a543d20c66",
                                                             @"6365d93e-cd31-4d04-9d77-bf335e006b12",
                                                             @"a773ab24-a93a-44b6-bdd5-35c42e3fafb5",
                                                             @"4272be95-8c4f-454e-bd5d-4f0662b36d05",
                                                             @"a992607f-333a-443f-82e9-d573fe15b98a",
                                                             @"05dc8c4f-4a90-4e37-a716-71bd0c510dcc",
                                                             @"6e32b97f-c835-4a3d-a1a3-b44d0fa050d4"]
                                                  password:@"hu881125h"
                                                    header:@"胡子"]];
    
    [self.dataSource addObject:[self userInfosWithUserName:@[@"13169542457",//绑卡
                                                             @"15594625518",//绑卡
                                                             @"13201511884",//绑卡
                                                             @"15820756843",//绑卡
                                                             @"13238686138",
                                                             @"18423248804",
                                                             @"13651406599",
                                                             @"15916931145"]
                                                   userIds:nil
                                                  password:@"hu881125h"
                                                    header:@"胡子0730"]];
    
    [self.dataSource addObject:[self userInfosWithUserName:@[@"17189262144",
                                                             @"13054457008",
                                                             @"13116767847",
                                                             @"13236546802",
                                                             @"13053141780",
                                                             @"15664801157",
                                                             @"13016604054",
                                                             @"13082404624"]
                                                   userIds:nil
                                                  password:@"hu881125h"
                                                    header:@"胡子0803_A"]];
    [self.dataSource addObject:[self userInfosWithUserName:@[@"15694636574",
                                                             @"13201499474",
                                                             @"13190112719",
                                                             @"13148394041",
                                                             @"13073652047",
                                                             @"15680795038",
                                                             @"13284222642"]
                                                   userIds:nil
                                                  password:@"hu881125h"
                                                    header:@"胡子0803_B"]];
    
    [self.dataSource addObject:[self userInfosWithUserName:@[@"14709251436",
                                                             @"18704015673",
                                                             @"15360149991",
                                                             @"18729514099",
                                                             @"18704021425",
                                                             @"13093729635",
                                                             @"13600146934",
                                                             @"13078642087",
                                                             @"13184235686",
                                                             @"15916881225"]
                                                   userIds:nil
                                                  password:@"hu881125h"
                                                    header:@"胡子0807"]];
    
}
- (YJQInfoGroup *)userInfosWithUserName:(NSArray *)userNames userIds:(NSArray *)userIds password:(NSString *)password header:(NSString *)header{
    NSMutableArray *arrays = @[].mutableCopy;
    for (NSInteger index = 0; index < userNames.count; index ++) {
        NSString *userId = userIds ? userIds[index] : nil;
        
        NSString *userName = userNames[index];
        if (!userId) {
//            NSLog(@"%@",userName);
        }
        YJQInfo *model = [[YJQInfo alloc] initWithUserId:userId bankId:nil userName:userName password:password];
        __weak typeof(self) weakSelf = self;
        model.completion = ^{
            [weakSelf.tableView reloadData];
        };
        [arrays addObject:model];
    }
    YJQInfoGroup *group = [[YJQInfoGroup alloc] initWithInfos:arrays.copy header:header];
    return group;
}

@end

#if 0
NSArray *userNames = @[@"15818572527",
                       @"15970179507",
                       @"15814465582",
                       @"17895331630",
                       @"17865901923",
                       @"15718243730",
                       @"13265089060",
                       @"13160046572",
                       @"13728475009",
                       @"15606880784"];
NSArray *userIds = @[@"fdc2c531-dc9c-4388-8b25-f698eafe43ae",
                     @"d4061d1b-7598-41b8-8ed5-ff8fa25fd389",
                     @"54b5b46c-9d3c-4900-b64c-7abdf7adae42",
                     @"2ec21dd6-5f2a-4725-a843-61a543d20c66",
                     @"6365d93e-cd31-4d04-9d77-bf335e006b12",
                     @"a773ab24-a93a-44b6-bdd5-35c42e3fafb5",
                     @"4272be95-8c4f-454e-bd5d-4f0662b36d05",
                     @"a992607f-333a-443f-82e9-d573fe15b98a",
                     @"05dc8c4f-4a90-4e37-a716-71bd0c510dcc",
                     @"6e32b97f-c835-4a3d-a1a3-b44d0fa050d4"];

#endif
