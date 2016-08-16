//
//  PHScrollController.m
//  PHTest
//
//  Created by haohua pan on 16/8/16.
//  Copyright © 2016年 haohua pan. All rights reserved.
//

#import "PHScrollController.h"
#import <Masonry/Masonry.h>
//#import <SDWebImage/UIImageView+WebCache.h>
#import "UIImageView+WebCache.h"



@interface PHScrollController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backViewHeight;

@property (weak, nonatomic) IBOutlet UIView *backgroundView;
@property (weak, nonatomic) IBOutlet UIScrollView *backScrollView;


@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, weak) UIView *upView;

@end

@implementation PHScrollController

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = @[].mutableCopy;
        for (NSInteger index = 0; index < 19; index ++) {
            PHModel *model = [PHModel new];
            model.type = index % 2 + 1;
//            model.type = 1;
            if (model.type == 1) {
                model.contentString = @"环球网综合报道】据日本时事通信社8月16日报道，美国《华盛顿邮报》当地时间15日援引美政府高官的话报道称，日本首相安倍晋三通过美军太平洋司令部司令哈里斯向美国总统奥巴马转达了自己的立场，表示反对美国正在探讨的“不首先使用核武器”政策";
            } else {
                model.contentString = @"http://buspic.gpsoo.net/goome01/M00/02/51/wKgCoVd3jRGEZEMDAAAAAH8EPZE85.jpeg";
            }
            [_dataSource addObject:model];
        }
    }
    return _dataSource;
}

- (UIColor *)randomColor {
    CGFloat hue = ( arc4random() % 256 / 256.0 );  //  0.0 to 1.0
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from white
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from black
    return [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    for (PHModel *model in self.dataSource) {
        if (model.type == 1) {
            UILabel *label = [UILabel new];
            label.backgroundColor = [self randomColor];
            label.numberOfLines= 0;
            label.text = model.contentString;
            [self.backgroundView addSubview:label];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(10);
                make.right.mas_equalTo(self.backgroundView).offset(-10);
                if (self.upView) {
                    make.top.mas_equalTo(self.upView.mas_bottom).offset(20);
                } else {
                    make.top.mas_equalTo(self.backgroundView).offset(20);
                }
            }];
            self.upView = label;
        } else {
            UIImageView *imageView = [UIImageView new];
            [self.backgroundView addSubview:imageView];
            [imageView sd_setImageWithURL:[NSURL URLWithString:model.contentString]];
            [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(10);
                make.right.mas_equalTo(self.backgroundView).offset(-10);
                make.height.mas_equalTo(200);
                if (self.upView) {
                    make.top.mas_equalTo(self.upView.mas_bottom).offset(20);
                } else {
                    make.top.mas_equalTo(self.backgroundView).offset(5);
                }
            }];
            self.upView = imageView;
        }
        
        [self.backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.upView.mas_bottom).offset(10);
        }];
        CGSize size = self.backScrollView.contentSize;
        size.height = self.backViewHeight.constant;
        self.backScrollView.contentSize = size;
    }
    
}



@end





@implementation PHModel



@end