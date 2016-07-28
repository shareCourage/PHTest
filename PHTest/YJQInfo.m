//
//  YJQInfo.m
//  PHTest
//
//  Created by Kowloon on 16/7/28.
//  Copyright © 2016年 haohua pan. All rights reserved.
//

#import "YJQInfo.h"

@implementation YJQInfo

- (instancetype)initWithUserId:(NSString *)userId bankId:(NSString *)bankId userName:(NSString *)userName {
    self = [super init];
    if (self) {
        self.userId = userId;
        self.bankId = bankId;
        self.userName = userName;
    }
    return self;
}

@end
