
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

@interface PHTableViewController ()

@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, weak) YJQInfo *selectInfo;
@property (nonatomic, strong) UITextField *titleTextField;
@property (nonatomic, strong) UILabel *leftLabel;

@end

@implementation PHTableViewController

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = @[].mutableCopy;
    }
    return _dataSource;
}
- (YJQInfoGroup *)userInfosWithUserName:(NSArray *)userNames userIds:(NSArray *)userIds password:(NSString *)password header:(NSString *)header{
    NSMutableArray *arrays = @[].mutableCopy;
    for (NSInteger index = 0; index < userIds.count; index ++) {
        NSString *userId = nil;//userIds[index];
        NSString *userName = userNames[index];
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

- (void)viewDidLoad {
    [super viewDidLoad];
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
    
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 35, 35)];
    label.textColor = [UIColor greenColor];
    label.textAlignment = NSTextAlignmentCenter;
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:label];
    self.navigationItem.leftBarButtonItem = leftItem;
    self.leftLabel = label;
    
    UIBarButtonItem *addItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addClick)];
    self.navigationItem.rightBarButtonItem = addItem;
    
    [self addUserName];
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
    return;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    PHReactiveCocoaController *vc = [storyboard instantiateViewControllerWithIdentifier:@"PHReactiveCocoaController"];
    vc.yjqModel = model;
    [self.navigationController pushViewController:vc animated:YES];
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
        }
        if ([message isEqualToString:@"使用成功"]) {
            [[NSUserDefaults standardUserDefaults] setObject:self.titleTextField.text forKey:@"codeNum"];
            self.leftLabel.text = @"Y";
            self.leftLabel.textColor = [UIColor greenColor];
        } else {
            self.leftLabel.text = @"N";
            self.leftLabel.textColor = [UIColor redColor];
        }
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        NSLog(@"%@", error);
    }];
}

- (void)af_RequestOperationManagerWithHost:(NSString *)host para:(NSDictionary *)para {
    [self af_RequestOperationManagerWithHost:host para:para json:NO];
}



- (void)addUserName {
    [self.dataSource addObject:[self userInfosWithUserName:@[@"15818572527"]
                                                   userIds:@[@"fdc2c531-dc9c-4388-8b25-f698eafe43ae"]
                                                  password:@"ygphh383509677H"
                                                    header:@"PHH"]];
    [self.dataSource addObject:[self userInfosWithUserName:@[@"15970179507",
                                                             @"15814465582"]
                                                   userIds:@[@"d4061d1b-7598-41b8-8ed5-ff8fa25fd389",
                                                             @"54b5b46c-9d3c-4900-b64c-7abdf7adae42"]
                                                  password:@"123456"
                                                    header:@"One"]];
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