//
//  PHScrollTwoController.m
//  PHTest
//
//  Created by haohua pan on 16/8/17.
//  Copyright © 2016年 haohua pan. All rights reserved.
//

#import "PHScrollTwoController.h"
#import <Masonry/Masonry.h>
#import "PHScrollController.h"
#import "UIImageView+WebCache.h"

@interface PHScrollTwoController ()
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation PHScrollTwoController
- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = @[].mutableCopy;
        for (NSInteger index = 0; index < 19; index ++) {
            PHModel *model = [PHModel new];
            model.type = index % 2 + 1;
            //            model.type = 1;
            if (model.type == 1) {
                model.contentString = @"【环球网综合报道】据日本时事通信社8月16日报道，美国《华盛顿邮报》当地时间15日援引美政府高官的话报道称，日本首相安倍晋三通过美军太平洋司令部司令哈里斯向美国总统奥巴马转达了自己的立场，表示反对美国正在探讨的“不首先使用核武器”政策";
            } else {
                model.contentString = @"http://buspic.gpsoo.net/goome01/M00/02/51/wKgCoVd3jRGEZEMDAAAAAH8EPZE85.jpeg";
            }
            [_dataSource addObject:model];
        }
    }
    return _dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.pagingEnabled = NO;
    [self.view addSubview:self.scrollView];
    self.scrollView.backgroundColor = [UIColor lightGrayColor];
    
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    UIView *lastLabel = nil;
    for (NSUInteger i = 0; i < 19; ++i) {
        PHModel *model = self.dataSource[i];
        if (model.type == 1) {
            UILabel *label = [[UILabel alloc] init];
            label.numberOfLines = 0;
            label.layer.borderColor = [UIColor greenColor].CGColor;
            label.layer.borderWidth = 2.0;
            NSString *htmlString = [self randomText];
            NSAttributedString * attrStr = [[NSAttributedString alloc] initWithData:[htmlString dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
            label.attributedText = attrStr;
            
            // We must preferredMaxLayoutWidth property for adapting to iOS6.0
            label.preferredMaxLayoutWidth = screenWidth - 30;
            label.textAlignment = NSTextAlignmentLeft;
//            label.textColor = [self randomColor];
            [self.scrollView addSubview:label];
            
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(15);
                make.right.mas_equalTo(self.view).offset(-15);
                
                if (lastLabel) {
                    make.top.mas_equalTo(lastLabel.mas_bottom).offset(20);
                } else {
                    make.top.mas_equalTo(self.scrollView).offset(20);
                }
            }];
            lastLabel = label;
        } else {
            UIImageView *imageView = [UIImageView new];
            [imageView sd_setImageWithURL:[NSURL URLWithString:model.contentString]];
            [self.scrollView addSubview:imageView];
            [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(15);
                make.right.mas_equalTo(self.view).offset(-15);
                make.height.mas_equalTo(200);
                if (lastLabel) {
                    make.top.mas_equalTo(lastLabel.mas_bottom).offset(20);
                } else {
                    make.top.mas_equalTo(self.scrollView).offset(20);
                }
            }];
            lastLabel = imageView;
        }
        
    }
    
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
        
        // 让scrollview的contentSize随着内容的增多而变化
        make.bottom.mas_equalTo(lastLabel.mas_bottom).offset(20);
    }];
}

- (UIColor *)randomColor {
    CGFloat hue = ( arc4random() % 256 / 256.0 );  //  0.0 to 1.0
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from white
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from black
    return [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
}

- (NSString *)randomText {
    CGFloat length = arc4random_uniform(3);
    
    NSMutableString *str = [[NSMutableString alloc] init];
    for (NSUInteger i = 0; i < length; ++i) {
        [str appendString:@"<span style=\"color: rgb(153, 204, 0);\"><font size=\"4\"><span style=\"font-weight: bold;\">【环球网综合报道】</span></font></span><br><span style=\"color: rgb(0, 255, 255);\"><font size=\"2\">据日本时事通信社8月16日报道，美国《华盛顿邮报》当地时间15日援引美政府高官的话报道称，日本首相安倍晋三通过美军太平洋司令部司令哈里斯向美国总统奥巴马转达了自己的立场，表示反对美国正在探讨的“不首先使用核武器”政策</font></span><br><span style=\"color: rgb(255, 0, 0);\">红色字体，提示</span><br>"];
    }
    
    return str;
}


@end
