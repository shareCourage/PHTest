//
//  PHTargetProxy.h
//  PHTest
//
//  Created by haohua pan on 16/7/30.
//  Copyright © 2016年 haohua pan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PHTargetProxy : NSProxy {
    
    id realObject1;
    
    id realObject2;
    
}



- (id)initWithTarget1:(id)t1 target2:(id)t2;

@end
