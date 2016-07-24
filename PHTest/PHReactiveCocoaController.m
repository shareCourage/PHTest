//
//  PHReactiveCocoaController.m
//  PHTest
//
//  Created by haohua pan on 16/7/15.
//  Copyright © 2016年 haohua pan. All rights reserved.
//

#import "PHReactiveCocoaController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "ViewController.h"
#import "AFNetworking.h"

@interface PHReactiveCocoaController ()

@property (weak, nonatomic) IBOutlet UITextField *textField;
@end

#define UserId_1581857  @"fdc2c531-dc9c-4388-8b25-f698eafe43ae"
#define BankId_1581857  @"a9a10056-373e-4954-8a08-e1d1ef057183"

#define UserId_1597017  @"d4061d1b-7598-41b8-8ed5-ff8fa25fd389"
#define BankId_1597017  @"070f9342-ffb4-44af-83df-04db2f84ed01"

@implementation PHReactiveCocoaController
- (void)af_RequestOperationManagerWithHost:(NSString *)host para:(NSDictionary *)para json:(BOOL)json{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    if (json) {
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
    } else {
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    }
    NSData *data = [NSJSONSerialization dataWithJSONObject:para options:NSJSONWritingPrettyPrinted error:nil];
    NSString *requestString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSMutableDictionary *mparas = @{}.mutableCopy;
    [mparas setObject:requestString forKey:@"jsonString"];
    [manager POST:host parameters:mparas.copy success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSLog(@"%@", responseObject);
        NSLog(@"%@", responseObject[@"message"]);
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        NSLog(@"%@", error);
    }];
}

- (void)af_RequestOperationManagerWithHost:(NSString *)host para:(NSDictionary *)para {
    [self af_RequestOperationManagerWithHost:host para:para json:NO];
}

- (IBAction)addNumClick:(id)sender {
    NSString *userId = UserId_1597017;//159
    NSDictionary *parameters = @{@"userId": userId};
    NSString *host = @"http://139.196.109.201/app/scanWxForward.do";
    [self af_RequestOperationManagerWithHost:host para:parameters json:YES];
}

- (IBAction)commitClick:(id)sender {
    NSString *scanHost = @"http://139.196.109.201/app/scanmedcodeUpgrade.do";
    NSString *meCode = [NSString stringWithFormat:@"code%@", self.textField.text];
    NSString *userId = UserId_1597017;//159
    NSDictionary *parameters = @{@"sessionid": @"",
                                 @"medCode": meCode,
                                 @"userId": userId,
                                 @"userType": @"1"};
    [self af_RequestOperationManagerWithHost:scanHost para:parameters];
}

- (IBAction)withDraw:(id)sender {
    [self withdrawWithBankId:BankId_1597017 userId:UserId_1597017];
}

- (void)withdrawWithBankId:(NSString *)bankId userId:(NSString *)userId {
    /*
     {"fee":"4","sessionid":"","bankcardid":"a9a10056-373e-4954-8a08-e1d1ef057183","userId":"d4061d1b-7598-41b8-8ed5-ff8fa25fd389","userType":"1"}
     */
    NSString *withdrawHost = @"http://139.196.109.201/app/withdraw.do";
    NSDictionary *para = @{@"fee": @"10",
                           @"sessionid": @"",
                           @"bankcardid": bankId,
                           @"userId": userId,
                           @"userType": @"1"};
    [self af_RequestOperationManagerWithHost:withdrawHost para:para];
}

- (void)textFieldSetup {
    self.textField.text = @"82013634018376735735";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self textFieldSetup];
    [self RACSignal];
    [self RACSubject];
    [self RACReplaySubject];
}

- (void)RACSignal {
    RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        //block调用时刻：每当有订阅者订阅信号，就会调用block。
        
        // 2.发送信号
        [subscriber sendNext:[UIView new]];
        
        // 如果不在发送数据，最好发送信号完成，内部会自动调用[RACDisposable disposable]取消订阅信号。
        [subscriber sendCompleted];
        
        return [RACDisposable disposableWithBlock:^{
            
            // block调用时刻：当信号发送完成或者发送错误，就会自动执行这个block,取消订阅信号。
            
            // 执行完Block后，当前信号就不在被订阅了。
            
            NSLog(@"信号被销毁");
            
        }];
    }];
    
    // 3.订阅信号,才会激活信号.
    [signal subscribeNext:^(id x) {
        // block调用时刻：每当有信号发出数据，就会调用block.
        NSLog(@"接收到数据:%@",x);
    }];
}

- (void)RACSubject {
    // RACSubject使用步骤
    // 1.创建信号 [RACSubject subject]，跟RACSiganl不一样，创建信号时没有block。
    // 2.订阅信号 - (RACDisposable *)subscribeNext:(void (^)(id x))nextBlock
    // 3.发送信号 sendNext:(id)value
    
    // RACSubject:底层实现和RACSignal不一样。
    // 1.调用subscribeNext订阅信号，只是把订阅者保存起来，并且订阅者的nextBlock已经赋值了。
    // 2.调用sendNext发送信号，遍历刚刚保存的所有订阅者，一个一个调用订阅者的nextBlock。
    
    // 1.创建信号
    RACSubject *subject = [RACSubject subject];
    
    // 2.订阅信号
    [subject subscribeNext:^(id x) {
        // block调用时刻：当信号发出新值，就会调用.
        NSLog(@"第一个订阅者%@",x);
    }];
    [subject subscribeNext:^(id x) {
        // block调用时刻：当信号发出新值，就会调用.
        NSLog(@"第二个订阅者%@",x);
    }];
    
    // 3.发送信号
    [subject sendNext:[UIButton new]];
}

- (void)RACReplaySubject {
    // RACReplaySubject使用步骤:
    // 1.创建信号 [RACSubject subject]，跟RACSiganl不一样，创建信号时没有block。
    // 2.可以先订阅信号，也可以先发送信号。
    // 2.1 订阅信号 - (RACDisposable *)subscribeNext:(void (^)(id x))nextBlock
    // 2.2 发送信号 sendNext:(id)value
    
    // RACReplaySubject:底层实现和RACSubject不一样。
    // 1.调用sendNext发送信号，把值保存起来，然后遍历刚刚保存的所有订阅者，一个一个调用订阅者的nextBlock。
    // 2.调用subscribeNext订阅信号，遍历保存的所有值，一个一个调用订阅者的nextBlock
    
    // 如果想当一个信号被订阅，就重复播放之前所有值，需要先发送信号，在订阅信号。
    // 也就是先保存值，在订阅值。
    
    // 1.创建信号
    RACReplaySubject *replaySubject = [RACReplaySubject subject];
    
    // 2.发送信号
    [replaySubject sendNext:@1];
    [replaySubject sendNext:@2];
    
    // 3.订阅信号
    [replaySubject subscribeNext:^(id x) {
        
        NSLog(@"第一个订阅者接收到的数据%@",x);
    }];
    
    // 订阅信号
    [replaySubject subscribeNext:^(id x) {
        
        NSLog(@"第二个订阅者接收到的数据%@",x);
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ViewController *vc = [story instantiateViewControllerWithIdentifier:NSStringFromClass([ViewController class])];
    // 设置代理信号
    vc.delegateSubject = [RACSubject subject];
    
    // 订阅代理信号
    [vc.delegateSubject subscribeNext:^(id x) {
        
        NSLog(@"点击了通知按钮%@",x);
    }];
    
    // 跳转到第二个控制器
    [self.navigationController pushViewController:vc animated:YES];
}

@end

// RACSignal使用步骤：
// 1.创建信号 + (RACSignal *)createSignal:(RACDisposable * (^)(id<RACSubscriber> subscriber))didSubscribe
// 2.订阅信号,才会激活信号. - (RACDisposable *)subscribeNext:(void (^)(id x))nextBlock
// 3.发送信号 - (void)sendNext:(id)value


// RACSignal底层实现：
// 1.创建信号，首先把didSubscribe保存到信号中，还不会触发。
// 2.当信号被订阅，也就是调用signal的subscribeNext:nextBlock
// 2.2 subscribeNext内部会创建订阅者subscriber，并且把nextBlock保存到subscriber中。
// 2.1 subscribeNext内部会调用siganl的didSubscribe
// 3.siganl的didSubscribe中调用[subscriber sendNext:@1];
// 3.1 sendNext底层其实就是执行subscriber的nextBlock






