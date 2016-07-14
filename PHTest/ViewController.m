//
//  ViewController.m
//  PHTest
//
//  Created by haohua pan on 16/6/27.
//  Copyright © 2016年 haohua pan. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *testImageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.testImageView.backgroundColor = [UIColor purpleColor];
    NSString *url = @"http://buspic.gpsoo.net/goome01/M00/02/51/wKgCoVd3jRGEZEMDAAAAAH8EPZE85.jpeg";
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    
    NSLog(@"%@ bytes, %@ KB",@(data.length), @(data.length / 1024));
    UIImage *testImage = [[UIImage alloc] initWithData:data];
    self.testImageView.image = testImage;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
