//
//  YJQInfo.m
//  PHTest
//
//  Created by Kowloon on 16/7/28.
//  Copyright © 2016年 haohua pan. All rights reserved.
//

#import "YJQInfo.h"
#import "AFNetworking.h"

typedef void(^YJQDictBlock)(NSDictionary *dict);

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
- (void)af_RequestOperationManagerWithHost:(NSString *)host para:(NSDictionary *)para json:(BOOL)json completion:(YJQDictBlock)completion{
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
        if (completion) {
            completion(responseObject);
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
        [self af_RequestOperationManagerWithHost:host para:para json:NO completion:^(NSDictionary *dict) {
            NSString *message = dict[@"message"];
            NSLog(@"%@", message);
            if ([message isEqualToString:@"密码错误"]) {
                NSLog(@"Telephone =====%@", self.userName);
            }
            NSDictionary *data = dict[@"data"];
            if (data) {
                NSString *idInfo = data[@"id"];
                NSLog(@"id -> %@", idInfo);
                _userId = idInfo;
                [[NSUserDefaults standardUserDefaults] setObject:idInfo forKey:[NSString stringWithFormat:@"%@telephone",self.userName]];
            }
        }];
    }
//    [self balanceCheck];
//    [self bankIdCheck];
}

/*
 *http://139.196.109.201/app/mybalanceUpgrade.do 查看余额
 {"sessionid":"","userId":"54b5b46c-9d3c-4900-b64c-7abdf7adae42","userType":"1"}
 {
	"message": "查询成功",
	"balance": "9.7",
	"code": "0",
	"sessionid": "",
	"success": true
 }
 */
- (void)balanceCheck {
    NSString *host = @"http://139.196.109.201/app/mybalanceUpgrade.do";
    if (self.userId.length == 0) return;
    NSDictionary *para = @{@"sessionid": @"",
                           @"userId": self.userId,
                           @"userType": @"1"};
    [self af_RequestOperationManagerWithHost:host para:para json:NO completion:^(NSDictionary *dict) {
        NSString *balance = [dict objectForKey:@"balance"];
        if (balance) {
            self.balance = balance;
        }
        if (self.completion) {
            self.completion();
        }
    }];
}

/*
 *提现接口 http://139.196.109.201/app/withdraw.do
 {"fee":"13.9","sessionid":"","bankcardid":"a9a10056-373e-4954-8a08-e1d1ef057183","userId":"d4061d1b-7598-41b8-8ed5-ff8fa25fd389","userType":"1"}
 {
	"message": "提现请求成功",
	"freeze": "0",
	"code": "0",
	"sessionid": "",
	"success": true
 }
 */
- (void)withdrawMethod {
    NSString *host = @"http://139.196.109.201/app/withdraw.do";
    if (self.userId.length == 0) return;
    if ([self.balance floatValue] < 10.f) return;
    NSDictionary *para = @{@"fee": self.balance,
                           @"sessionid": @"",
                           @"bankcardid": self.bankId,
                           @"userId": self.userId,
                           @"userType": @"1"};
    [self af_RequestOperationManagerWithHost:host para:para json:NO completion:^(NSDictionary *dict) {
        NSString *message = [dict objectForKey:@"message"];
        NSLog(@"%@", message);
    }];
}

/*
 银行卡id查询
 http://139.196.109.201/app/mybanklist.do
 {"sessionid":"","currentPage":"1","userId":"d4061d1b-7598-41b8-8ed5-ff8fa25fd389","userType":"1"}
 {
	"message": "查询成功",
	"data": [{
 "id": "a9a10056-373e-4954-8a08-e1d1ef057183",
 "cardnum": "6228480128081085572",
 "bankname": "中国农业银行",
 "name": "潘豪华",
 "pic": "/yjq/upload/app/2015121017571080.png",
 "type": "0"
	}],
	"code": "0",
	"sessionid": "",
	"success": true
 }
 */
- (void)bankIdCheck {
    NSString *host = @"http://139.196.109.201/app/mybanklist.do";
    if (self.userId.length == 0) return;
    NSDictionary *para = @{@"sessionid": @"",
                           @"currentPage": @"1",
                           @"userId": self.userId,
                           @"userType": @"1"};
    [self af_RequestOperationManagerWithHost:host para:para json:NO completion:^(NSDictionary *dict) {
        NSString *message = [dict objectForKey:@"message"];
        NSLog(@"%@", message);
        NSArray *data = dict[@"data"];
        if ([data isKindOfClass:[NSArray class]]) {
            if (data.count > 0) {
                NSMutableArray *bankInfos = @[].mutableCopy;
                for (NSDictionary *dict in data) {
                    [bankInfos addObject:[[YJQBankInfo alloc] initWithDict:dict]];
                }
                self.bankInfos = bankInfos.copy;
            }
        }
        
        
    }];
}


- (instancetype)initWithUserId:(NSString *)userId bankId:(NSString *)bankId userName:(NSString *)userName {
    return [self initWithUserId:userId bankId:bankId userName:userName password:nil];
}

- (NSString *)bankId {
    if (_bankId) {
        return _bankId;
    } else {
        YJQBankInfo *bankInfo = self.bankInfos.firstObject;
        return bankInfo.bankId;
    }
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

@implementation YJQBankInfo
/*
 "id": "a9a10056-373e-4954-8a08-e1d1ef057183",
 "cardnum": "6228480128081085572",
 "bankname": "中国农业银行",
 "name": "潘豪华",
 "pic": "/yjq/upload/app/2015121017571080.png",
 "type": "0"
 */

- (instancetype)initWithDict:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        self.bankId = dict[@"id"];
        self.cardNum = dict[@"cardnum"];
        self.bankName = dict[@"bankname"];
        self.name = dict[@"name"];
        self.pic = dict[@"pic"];
    }
    return self;
}

@end