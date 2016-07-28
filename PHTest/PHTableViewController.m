
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

@interface PHTableViewController ()

@property (nonatomic, strong) NSArray *dataSource;

@end

@implementation PHTableViewController

- (NSArray *)dataSource {
    if (!_dataSource) {
        YJQInfo *one = [[YJQInfo alloc] initWithUserId:@"fdc2c531-dc9c-4388-8b25-f698eafe43ae"
                                                bankId:@"a9a10056-373e-4954-8a08-e1d1ef057183"
                                              userName:@"UserId_1581857"];
        YJQInfo *two = [[YJQInfo alloc] initWithUserId:@"d4061d1b-7598-41b8-8ed5-ff8fa25fd389"
                                                bankId:@"070f9342-ffb4-44af-83df-04db2f84ed01"
                                              userName:@"UserId_1597017"];
        YJQInfo *three = [[YJQInfo alloc] initWithUserId:@"54b5b46c-9d3c-4900-b64c-7abdf7adae42"
                                                  bankId:@"b97cd5dc-776e-43db-8dfa-63073b33312b"
                                                userName:@"UserId_1581446"];
        _dataSource = @[one, two, three];
    }
    return _dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([self class])];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([self class])];
    YJQInfo *model = [self.dataSource objectAtIndex:indexPath.row];
    cell.textLabel.text = model.userName;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    YJQInfo *model = [self.dataSource objectAtIndex:indexPath.row];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    PHReactiveCocoaController *vc = [storyboard instantiateViewControllerWithIdentifier:@"PHReactiveCocoaController"];
    vc.yjqModel = model;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
