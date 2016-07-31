//
//  ViewController.m
//  PHTest
//
//  Created by haohua pan on 16/6/27.
//  Copyright © 2016年 haohua pan. All rights reserved.
//

#import "ViewController.h"
#import "ReactiveCocoa.h"
//#import <ReactiveCocoa/ReactiveCocoa.h>

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *testImageView;
@property (nonatomic, strong) UILabel *labelL;
@end

@implementation ViewController

- (UILabel *)labelL {
    if (!_labelL) {
        UILabel *labelL        = [[UILabel alloc] initWithFrame:self.testImageView.frame];
        labelL.text            = @"500万现金";
        labelL.numberOfLines   = 0;
        labelL.backgroundColor = [UIColor brownColor];
        labelL.font            = [UIFont systemFontOfSize:30];
        labelL.textAlignment   = NSTextAlignmentCenter;
        _labelL = labelL;
    }
    return _labelL;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.testImageView.backgroundColor = [UIColor clearColor];
    self.testImageView.userInteractionEnabled = YES;
    [self.testImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick)]];
}

- (void)tapClick {
    if (self.delegateSubject) [self.delegateSubject sendNext:@2];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self.view insertSubview:self.labelL belowSubview:self.testImageView];
    
    NSString *urlStr = @"http://buspic.gpsoo.net/goome01/M00/02/51/wKgCoVd3jRGEZEMDAAAAAH8EPZE85.jpeg";
    urlStr = @"http://ftp.ytbbs.com/attachments/forum/201404/14/165935vfzw45q2574ggvii.gif";
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLSessionDataTask *downloadTask = [[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            UIImage *testImage = [[UIImage alloc] initWithData:data];
            self.testImageView.image = testImage;
        });
    }];
    [downloadTask setTaskDescription:@"weatherDownload"];
    [downloadTask resume];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    // 触摸任意位置
    UITouch *touch = touches.anyObject;
    // 触摸位置在图片上的坐标
    CGPoint cententPoint = [touch locationInView:self.testImageView];
    // 设置清除点的大小
    CGRect  rect = CGRectMake(cententPoint.x, cententPoint.y, 10, 10);
    // 默认是去创建一个透明的视图
    UIGraphicsBeginImageContextWithOptions(self.testImageView.bounds.size, NO, 0);
    // 获取上下文(画板)
    CGContextRef ref = UIGraphicsGetCurrentContext();
    // 把imageView的layer映射到上下文中
    [self.testImageView.layer renderInContext:ref];
    // 清除划过的区域
    CGContextClearRect(ref, rect);
    // 获取图片
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    // 结束图片的画板, (意味着图片在上下文中消失)
    UIGraphicsEndImageContext();
    
    self.testImageView.image = image;
}

@end
