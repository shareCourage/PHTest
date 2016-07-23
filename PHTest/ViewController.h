//
//  ViewController.h
//  PHTest
//
//  Created by haohua pan on 16/6/27.
//  Copyright © 2016年 haohua pan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RACSubject;

@interface ViewController : UIViewController

@property (nonatomic, strong) RACSubject *delegateSubject;

@end

