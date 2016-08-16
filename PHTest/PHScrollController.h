//
//  PHScrollController.h
//  PHTest
//
//  Created by haohua pan on 16/8/16.
//  Copyright © 2016年 haohua pan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PHScrollController : UIViewController

@end


@interface PHModel : NSObject

@property (nonatomic, assign) NSInteger type;

@property (nonatomic, copy) NSString *contentString;

@end