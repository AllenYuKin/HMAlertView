//
//  ViewController.m
//  HMAlertView
//
//  Created by hongyu on 2016/12/30.
//  Copyright © 2016年 Allen. All rights reserved.
//

#import "ViewController.h"
#import "HMAlertView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    UIButton *alertButton       = [UIButton buttonWithType:UIButtonTypeCustom];
    alertButton.backgroundColor = [UIColor cyanColor];
    alertButton.frame           = CGRectMake(0, 0, 50, 50);
    alertButton.center          = self.view.center;
    [alertButton addTarget:self action:@selector(action) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:alertButton];
}

- (void)action
{
    [[HMAlertView sharedAlertManager] AlertWithContent:@"内容" cancel:@"取消" sure:@"确定" buttonType:HMAlertTypeDefault sureBtBlock:^{
        NSLog(@"确定回调");
    } cancelBtBlock:^{
        NSLog(@"取消回调");
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
