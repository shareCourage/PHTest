//
//  YJQInfo.h
//  PHTest
//
//  Created by Kowloon on 16/7/28.
//  Copyright © 2016年 haohua pan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YJQInfo : NSObject

@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *bankId;
@property (nonatomic, copy) NSString *userName;
- (instancetype)initWithUserId:(NSString *)userId bankId:(NSString *)bankId userName:(NSString *)userName;

@end
