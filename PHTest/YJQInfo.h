//
//  YJQInfo.h
//  PHTest
//
//  Created by Kowloon on 16/7/28.
//  Copyright © 2016年 haohua pan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YJQInfo : NSObject
@property (nonatomic, copy) void (^completion)();
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *bankId;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *password;
- (instancetype)initWithUserId:(NSString *)userId bankId:(NSString *)bankId userName:(NSString *)userName;
- (instancetype)initWithUserId:(NSString *)userId bankId:(NSString *)bankId userName:(NSString *)userName password:(NSString *)password;

@end


@interface YJQInfoGroup : NSObject

@property (nonatomic, strong) NSArray *infos;
@property (nonatomic, copy) NSString *header;
- (instancetype)initWithInfos:(NSArray *)infos header:(NSString *)header;

@end