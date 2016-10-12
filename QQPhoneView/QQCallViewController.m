//
//  QQCallViewController.m
//  QQPhoneView
//
//  Created by haohao on 16/10/9.
//  Copyright © 2016年 haohao. All rights reserved.
//

#import "QQCallViewController.h"
#import "Const.h"
#import "AppDelegate.h"
@interface QQCallViewController ()<QQPhoneViewDelegate>
{
    //缩小的按钮
    UIButton *_narrowBtn;
    //挂掉电话的按钮
    UIButton *_hangUpBtn;
    //通话的头像
    UIImageView *_headPortraitImageView;
    //呼叫的动画
    UIImageView *_callingImageView;
    //显示时间的label
    UILabel *_timeLabel;
    //模拟通话接通之后
    UIButton *_callingBtn;
    NSTimer *_timer;
    //计时
    NSInteger _minuteCount;
}
@end

@implementation QQCallViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    //创建各部分的UI
    [self creatUI];
}

-(void)creatUI
{
    _headPortraitImageView = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth / 2 - headerImageViewWidth / 2, 100, headerImageViewWidth, headerImageViewWidth)];
    _headPortraitImageView.layer.cornerRadius = headerImageViewWidth/2;
    _headPortraitImageView.clipsToBounds = YES;
    _headPortraitImageView.image = [UIImage imageNamed:@"AppIcon-160x60"];
    _headPortraitImageView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_headPortraitImageView];
    
    
    _callingImageView = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth / 2 - 50 / 2, kScreenHeight / 2 - 50 / 2, 50, 50)];
    _callingImageView.backgroundColor = [UIColor clearColor];
    _callingImageView.clipsToBounds = YES;
    
    _callingImageView.animationImages = [NSArray arrayWithObjects:
                                         
                                         [UIImage imageNamed:@"voiceChange_receive_1.png"],
                                         
                                         [UIImage imageNamed:@"voiceChange_receive_2.png"],
                                         
                                         [UIImage imageNamed:@"voiceChange_receive_3.png"], nil];
    
    _callingImageView.animationDuration = 1.0;
    _callingImageView.animationRepeatCount = CGFLOAT_MAX;
    
    [self.view addSubview:_callingImageView];
    
    
    //挂断的按钮
    _hangUpBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _hangUpBtn.frame = CGRectMake(kScreenWidth / 2 - 60 / 2, kScreenHeight - 60 - 10, 60, 60);
    [_hangUpBtn setBackgroundImage:[UIImage imageNamed:@"AV_red_pressed"] forState:UIControlStateNormal];
    [_hangUpBtn addTarget:self action:@selector(hangUp:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_hangUpBtn];
    //缩小的按钮
    _narrowBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _narrowBtn.frame = CGRectMake(kScreenWidth - 60 - 10, kScreenHeight - 60 - 10, 60, 60);
    [_narrowBtn setBackgroundImage:[UIImage imageNamed:@"AV_scale"] forState:UIControlStateNormal];
    [_narrowBtn addTarget:self action:@selector(narrow:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_narrowBtn];
    
    //显示时间的label
    _timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth / 2 - 100 / 2, kScreenHeight - 200, 100, 20)];
    _timeLabel.textColor = [UIColor orangeColor];
    _timeLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_timeLabel];
    //模拟通话接通之后
    _callingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _callingBtn.frame = CGRectMake(kScreenWidth / 2 - 150 / 2, kScreenHeight - 200, 150, 20);
    [_callingBtn setTitle:@"点击模拟接通" forState:UIControlStateNormal];
    [_callingBtn setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    [_callingBtn addTarget:self action:@selector(simulationCalling:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_callingBtn];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [_callingImageView startAnimating];
}

#pragma mark ---- 模拟接通
-(void)simulationCalling:(UIButton *)sender
{
    sender.hidden = YES;
    [_callingImageView stopAnimating];
    _callingImageView.hidden = YES;
    //创建定时器
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(startCountTimeInterval) userInfo:nil repeats:YES];
}

#pragma mark ----开始计时
-(void)startCountTimeInterval
{
    _minuteCount++;
    NSInteger minutecount = _minuteCount / 60;
    NSInteger secondcount = _minuteCount % 60;
    if (minutecount > 60) {
        NSInteger hour = minutecount / 60;
        minutecount = hour % 60;
        _timeLabel.text = [NSString stringWithFormat:@"%02ld:%02ld:%02ld", hour,minutecount, secondcount];
    }else{
        _timeLabel.text = [NSString stringWithFormat:@"%02ld:%02ld", minutecount, secondcount];
    }
    //传到QQPhoneView;
    AppDelegate *deleage
    = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [deleage.phoneView setTimeLabelText:_timeLabel.text];
}

#pragma mark ---- hangupEvent
-(void)hangUp:(UIButton *)sender
{
    [_timer invalidate];
    _timer = nil;
    AppDelegate *deleage
    = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        _headPortraitImageView.frame = CGRectMake(kScreenWidth / 2 - headerImageViewWidth / 2, 50, headerImageViewWidth, headerImageViewWidth);
        _headPortraitImageView.alpha = 0.5;
        _hangUpBtn.frame = CGRectMake(kScreenWidth / 2 - 60 / 2, kScreenHeight - 20, 60, 60);
        _hangUpBtn.alpha = 0.5;
        _narrowBtn.frame = CGRectMake(kScreenWidth - 60 - 10, kScreenHeight - 20, 60, 60);
        _narrowBtn.alpha = 0.5;
    } completion:^(BOOL finished) {
        
        deleage.phoneView.hidden = YES;
        [deleage.phoneView.needToRemoveView removeFromSuperview];
        deleage.phoneView.delegate = nil;
    }];
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        
    }];
}


#pragma mark ---- narrowEvent
-(void)narrow:(UIButton *)sender
{
    AppDelegate *deleage = (AppDelegate *)[UIApplication sharedApplication].delegate;
    __weak typeof (self)weakSelf = self;
    deleage.phoneView.delegate = weakSelf;
    [deleage.phoneView becomeSmallerWithFrame:_headPortraitImageView.frame WithView:self.view WithCallState:_callingBtn.hidden];
    [self.navigationController dismissViewControllerAnimated:NO completion:^{
        
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)anything {
    //暂不做处理
}
-(void)dealloc
{
    NSLog(@"release");
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
