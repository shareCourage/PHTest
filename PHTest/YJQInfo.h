//
//  YJQInfo.h
//  PHTest
//
//  Created by Kowloon on 16/7/28.
//  Copyright © 2016年 haohua pan. All rights reserved.
//

#import <Foundation/Foundation.h>
@class YJQBankInfo;

@interface YJQInfo : NSObject
@property (nonatomic, copy) void (^completion)();
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *bankId;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *password;
@property (nonatomic, copy) NSString *balance;
@property (nonatomic, strong) NSArray<YJQBankInfo *> *bankInfos;
- (instancetype)initWithUserId:(NSString *)userId bankId:(NSString *)bankId userName:(NSString *)userName;
- (instancetype)initWithUserId:(NSString *)userId bankId:(NSString *)bankId userName:(NSString *)userName password:(NSString *)password;
- (void)balanceCheck;
- (void)withdrawMethod;
@end


@interface YJQInfoGroup : NSObject

@property (nonatomic, strong) NSArray *infos;
@property (nonatomic, copy) NSString *header;
- (instancetype)initWithInfos:(NSArray *)infos header:(NSString *)header;

@end


@interface YJQBankInfo : NSObject

@property (nonatomic, copy) NSString *bankId;
@property (nonatomic, copy) NSString *cardNum;
@property (nonatomic, copy) NSString *bankName;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *pic;
- (instancetype)initWithDict:(NSDictionary *)dict;

@end
