//
//  ViewController.m
//  LCAlertDemo
//
//  Created by lcc on 2017/5/3.
//  Copyright © 2017年 lcc. All rights reserved.
//

#import "ViewController.h"
#import "LCAlertView.h"

#define HEXCOLOR(c) [UIColor colorWithRed:((c>>16)&0xFF)/255.0f green:((c>>8)&0xFF)/255.0f blue:(c&0xFF)/255.0f alpha:1.0f]

#define kDarkGrayTextColor    HEXCOLOR(0x333333)  //重要文字用于普通级的段落文字
#define kMainColor     HEXCOLOR(0xff8400)  //主色调，

@interface ViewController ()<LCAlertViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
}
- (IBAction)alertAction:(UIButton *)sender {
    switch (sender.tag) {
        case 10: {
            LCAlertView *alert = [[LCAlertView alloc]initWithMessage:@"为保证资金安全，请先实名认证。为保证资金安全，请先实名认证。为保证资金安全，请先实名认证。为保证资金安全，请先实名认证。为保证资金安全，请先实名认证。为保证资金安全，请先实名认证。为保证资金安全，请先实名认证。为保证资金安全，请先实名认证。为保证资金安全，请先实名认证。为保证资金安全，请先实名认证。为保证资金安全，请先实名认证。为保证资金安全，请先实名认证。为保证资金安全，请先实名认证。为保证资金安全，请先实名认证。为保证资金安全，请先实名认证。为保证资金安全，请先实名认证。为保证资金安全，请先实名认证。为保证资金安全，请先实名认证。为保证资金安全，请先实名认证。为保证资金安全，请先实名认证。为保证资金安全，请先实名认证。为保证资金安全，请先实名认证。为保证资金安全，请先实名认证。为保证资金安全，请先实名认证。为保证资金安全，请先实名认证。为保证资金安全，请先实名认证。为保证资金安全，请先实名认证。为保证资金安全，请先实名认证。为保证资金安全，请先实名认证。为保证资金安全，请先实名认证。为保证资金安全，请先实名认证。为保证资金安全，请先实名认证。为保证资金安全，请先实名认证。为保证资金安全，请先实名认证。为保证资金安全，请先实名认证。为保证资金安全，请先实名认证。为保证资金安全，请先实名认证。为保证资金安全，请先实名认证。为保证资金安全，请先实名认证。为保证资金安全，请先实名认证。为保证资金安全，请先实名认证。为保证资金安全，请先实名认证。为保证资金安全，请先实名认证。为保证资金安全，请先实名认证。" cancelButtonTitle:@"知道了" otherButtonTitle:@"实名认证" usingBlockWhenTapButton:^(LCAlertView *alertView, NSInteger buttonIndex) {
                if (buttonIndex == 0) {
                    NSLog(@"取消认证");
                    
                } else if (buttonIndex == 1) {
                    
                }
            }];
            [alert.cancelButton setTitleColor:kDarkGrayTextColor forState:UIControlStateNormal];
            [alert.sureButton setTitleColor:kMainColor forState:UIControlStateNormal];
            [alert show];
        }break;
        case 11: {
            LCAlertView *alert = [[LCAlertView alloc]initWithMessage:@"什么什么啊" cancelButtonTitle:@"线下支付" otherButtonTitle:@"扫码支付" usingBlockWhenTapButton:^(LCAlertView *alertView, NSInteger buttonIndex) {
                if (buttonIndex == 0) {
                    
                } else if (buttonIndex == 1) {
                    
                }
            }];
            alert.closeButton.hidden = NO;
            [alert.cancelButton setTitleColor:kDarkGrayTextColor forState:UIControlStateNormal];
            [alert.sureButton setTitleColor:kMainColor forState:UIControlStateNormal];
            [alert show];
        }break;
        case 12: {
            LCAlertView *alert = [[LCAlertView alloc]initWithTitle:@"温馨提示" message:@"你想干嘛？" cancelButtonTitle:@"不了" otherButtonTitles:@[@"你管我",@"啥"]];
            [alert.cancelButton setTitleColor:kDarkGrayTextColor forState:UIControlStateNormal];
            [alert.cancelButton setBackgroundColor:[UIColor purpleColor]];
            [alert.sureButton setTitleColor:kMainColor forState:UIControlStateNormal];
            alert.delegate = self;
            [alert show];
        }break;
            
        default:
            break;
    }
}

- (void)alertView:(LCAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0: {
            NSLog(@"不了");
        }break;
        case 1: {
            NSLog(@"你管我");
        }break;
        case 2: {
            NSLog(@"啥");
        }break;
            
        default:
            break;
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
