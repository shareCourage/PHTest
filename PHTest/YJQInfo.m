//
//  YJQInfo.m
//  PHTest
//
//  Created by Kowloon on 16/7/28.
//  Copyright © 2016年 haohua pan. All rights reserved.
//

#import "YJQInfo.h"
#import "AFNetworking.h"

@implementation YJQInfo
/*
 {
	"success": "true",
	"code": "0",
	"message": "登录成功",
	"sessionid": "CDF4B64FE7F733FD4A1FA1BC265B61CC",
	"data": {
 "id": "a992607f-333a-443f-82e9-d573fe15b98a",
 "susername": "胡华明",
 "money": "5.7",
 "pic": "",
 "backid": "0",
 "docnum": "14992",
 "expnum": "563",
 "kfPhone": "400-021-1558",
 "phone": "13160046572",
 "integral": "0"
	}
 }
 */
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
        if ([message isEqualToString:@"密码错误"]) {
            NSLog(@"Telephone =====%@", self.userName);
        }
        NSDictionary *data = responseObject[@"data"];
        if (data) {
            NSString *idInfo = data[@"id"];
            NSLog(@"id -> %@", idInfo);
            _userId = idInfo;
            [[NSUserDefaults standardUserDefaults] setObject:idInfo forKey:[NSString stringWithFormat:@"%@telephone",self.userName]];
        }
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        NSLog(@"%@", error);
    }];
}

- (instancetype)initWithUserId:(NSString *)userId bankId:(NSString *)bankId userName:(NSString *)userName password:(NSString *)password{
    self = [super init];
    if (self) {
        self.bankId = bankId;
        self.userName = userName;
        self.password = password;
        if (userId.length == 0) {
            userId = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@telephone",userName]];
        }
        self.userId = userId;
    }
    return self;
}
//{"password":"hu881125h","userType":"1","version":"1.2","operateSysType":"1","userName":"17865901923"}
- (void)setUserId:(NSString *)userId {
    _userId = userId;
    if (userId.length == 0) {
        NSString *host = @"http://139.196.109.201/app/loginAppUpgrade.do";
        NSDictionary *para = @{@"password": self.password,
                               @"userName": self.userName,
                               @"userType": @"1",
                               @"version": @"1.2",
                               @"operateSysType": @"1"};
        [self af_RequestOperationManagerWithHost:host para:para json:NO];
    }
}

- (instancetype)initWithUserId:(NSString *)userId bankId:(NSString *)bankId userName:(NSString *)userName {
    return [self initWithUserId:userId bankId:bankId userName:userName password:nil];
}

@end


@implementation YJQInfoGroup

- (instancetype)initWithInfos:(NSArray *)infos header:(NSString *)header {
    self = [super init];
    if (self) {
        self.infos = infos;
        self.header = header;
    }
    return self;
}

@end