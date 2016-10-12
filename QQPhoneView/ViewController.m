//
//  ViewController.m
//  QQPhoneView
//
//  Created by haohao on 16/10/8.
//  Copyright © 2016年 haohao. All rights reserved.
//

#import "ViewController.h"
#import "QQCallViewController.h"
#import "AppDelegate.h"
@interface ViewController ()

@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor redColor];
}
- (IBAction)btnClick:(id)sender {
    AppDelegate *deleage = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (deleage.phoneView.hidden == NO) {
        return;
    }
    QQCallViewController *VC = [[QQCallViewController alloc]init];
    UINavigationController *navigationcontoller = [[UINavigationController alloc]initWithRootViewController:VC];
    
    navigationcontoller.navigationBar.hidden = YES;
    [self presentViewController:navigationcontoller animated:YES completion:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
