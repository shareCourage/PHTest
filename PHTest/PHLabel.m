//
//  PHLabel.m
//  PHTest
//
//  Created by haohua pan on 16/6/27.
//  Copyright © 2016年 haohua pan. All rights reserved.
//

#import "PHLabel.h"

@implementation PHLabel


- (CGSize)intrinsicContentSize
{
    CGSize originalSize = [super intrinsicContentSize];
    
    CGFloat intrinscValue = 20;
    CGSize size = CGSizeMake(originalSize.width + intrinscValue, originalSize.height + intrinscValue);
    
    return size;
}

@end
