//
//  QQPhoneView.m
//  QQPhoneView
//
//  Created by haohao on 16/10/9.
//  Copyright © 2016年 haohao. All rights reserved.
//

#import "QQPhoneView.h"

@interface QQPhoneView ()<CAAnimationDelegate>
{
    //缩小之后显示的imageView
    UIImageView *_smallerImageView;
    //显示时间的label
    UILabel *_timeLabel;
    //用来接收头像的frame
    CGRect _headerFrame;
    UIView *_removeView;
    //用来判断是变大还是变小
    BOOL _becomeSmall;
    //获得截图的image
    UIImage *_screenShotsImage;
    //判断是否接通
    BOOL _isCalling;
}

@end
@implementation QQPhoneView


-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        self.windowLevel = UIWindowLevelAlert + 1;
        [self makeKeyAndVisible];
        //创建各个部件
        [self creatUI];
        //注意这里要先设置隐藏，因为没有设置根试图控制器，否则会崩掉
        self.hidden = YES;
    }
    return self;
}

-(void)creatUI
{
    _smallerImageView = [[UIImageView alloc]init];
    _smallerImageView.clipsToBounds = YES;
    _smallerImageView.layer.cornerRadius = headerImageViewWidth / 2;
    _smallerImageView.hidden = YES;
    _smallerImageView.userInteractionEnabled = YES;
    //添加一个移动的手势
    UIPanGestureRecognizer *move = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(moveWithHand:)];
    [_smallerImageView addGestureRecognizer:move];
    //添加一个单机变大的手势
    UITapGestureRecognizer *becomeBig = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(becomeBigger:)];
    [_smallerImageView addGestureRecognizer:becomeBig];
    
    _smallerImageView.backgroundColor = [UIColor clearColor];
    [self addSubview:_smallerImageView];
    
    _timeLabel = [[UILabel alloc]init];
    _timeLabel.adjustsFontSizeToFitWidth = YES;
    _timeLabel.hidden = YES;
    _timeLabel.font = [UIFont systemFontOfSize:10];
    _timeLabel.textColor = [UIColor whiteColor];
    _timeLabel.textAlignment = NSTextAlignmentCenter;
    _timeLabel.backgroundColor = [UIColor clearColor];
    [_smallerImageView addSubview:_timeLabel];
}

#pragma mark -----  随着手指移动
-(void)moveWithHand:(UIPanGestureRecognizer *)sender
{
    CGPoint point = [sender locationInView:[[UIApplication sharedApplication] keyWindow]];
    if (sender.state == UIGestureRecognizerStateChanged) {
        self.center = CGPointMake(point.x, point.y);
    }
    
    if (sender.state == UIGestureRecognizerStateEnded) {
        if (point.x <= kScreenWidth / 2) {
            if (point.y <= self.frame.size.height / 2 && point.x >= self.frame.size.width / 2 + 20) {
                [UIView animateWithDuration:0.15f animations:^{
                    self.center = CGPointMake(point.x, self.frame.size.height / 2 + 20);
                }];
            }else if (point.y >= kScreenHeight - self.frame.size.height / 2 && point.x >= self.frame.size.width / 2 + 20) {
                [UIView animateWithDuration:0.15f animations:^{
                    self.center = CGPointMake(point.x, kScreenHeight - self.frame.size.height / 2 - 10);
                }];
            }else if (point.y < kScreenHeight - self.frame.size.height / 2 && point.y > self.frame.size.height / 2) {
                [UIView animateWithDuration:0.15f animations:^{
                    self.center = CGPointMake(self.frame.size.width / 2 + 10, point.y);
                }];
            }else if (point.y <= self.frame.size.height / 2 && point.x <= self.frame.size.width / 2 + 20) {
                [UIView animateWithDuration:0.15f animations:^{
                    self.center = CGPointMake(self.frame.size.width / 2 + 10, self.frame.size.height / 2 + 20);
                }];
            }else if (point.y >= kScreenHeight - self.frame.size.height / 2 - 10 && point.x <= self.frame.size.width / 2 + 20) {
                [UIView animateWithDuration:0.15f animations:^{
                    self.center = CGPointMake(self.frame.size.width / 2 + 10, kScreenHeight - self.frame.size.height / 2 - 10);
                }];
            }
        }else{
            if (point.y <= self.frame.size.height / 2 && point.x <= kScreenWidth - self.frame.size.width / 2 - 20) {
                [UIView animateWithDuration:0.15f animations:^{
                    self.center = CGPointMake(point.x, self.frame.size.height / 2 + 20);
                }];
            }else if (point.y >= kScreenHeight - self.frame.size.height / 2 && point.x <= kScreenWidth - self.frame.size.width / 2 - 20) {
                [UIView animateWithDuration:0.15f animations:^{
                    self.center = CGPointMake(point.x, kScreenHeight - self.frame.size.height / 2 - 10);
                }];
            }else if (point.y < kScreenHeight - self.frame.size.height / 2 && point.y > self.frame.size.height / 2) {
                [UIView animateWithDuration:0.15f animations:^{
                    self.center = CGPointMake(kScreenWidth - self.frame.size.width / 2 - 10, point.y);
                }];
            }else if (point.y <= self.frame.size.height / 2 && point.x > kScreenWidth - self.frame.size.width / 2 - 20) {
                [UIView animateWithDuration:0.15f animations:^{
                    self.center = CGPointMake(kScreenWidth - self.frame.size.width / 2 - 10, self.frame.size.height / 2 + 20);
                }];
            }else if (point.y >= kScreenHeight - self.frame.size.height / 2 - 10 && point.x > kScreenWidth - self.frame.size.width / 2 - 20) {
                [UIView animateWithDuration:0.15f animations:^{
                    self.center = CGPointMake(kScreenWidth - self.frame.size.width / 2 - 10, kScreenHeight - self.frame.size.height / 2 - 10);
                }];
            }
        }
    }
}
#pragma mark -----  单击变大
-(void)becomeBigger:(UITapGestureRecognizer *)sender
{
    _smallerImageView.image = _screenShotsImage;
    _timeLabel.hidden = YES;
    //动画
    [UIView animateWithDuration:0.5f animations:^{
        self.frame = _headerFrame;
    } completion:^(BOOL finished) {
        //执行变大的动画
        _smallerImageView.hidden = YES;
        [self animationToBigger];
    }];
}

#pragma mark -------- become smaller
-(void)becomeSmallerWithFrame:(CGRect)rect WithView:(UIView *)view WithCallState:(BOOL)isCalling
{
    _isCalling = isCalling;
    self.needToRemoveView = view;
    self.hidden = NO;
    _becomeSmall = YES;
    _headerFrame = rect;
    _removeView = view;
    [self addSubview:_removeView];
    //实现动画变小的动画
    [self animationToSmall];
}

#pragma mark ----- 变小的动画
-(void)animationToSmall
{
    UIBezierPath *startPath = [UIBezierPath bezierPathWithOvalInRect:CGRectInset(_headerFrame, -kScreenHeight + 100, -kScreenHeight + 100)];
    UIBezierPath *endPath = [UIBezierPath bezierPathWithOvalInRect:_headerFrame];
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = startPath.CGPath;
    shapeLayer.backgroundColor = (__bridge CGColorRef _Nullable)([UIColor whiteColor]);
    _removeView.layer.mask = shapeLayer;
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"path"];
    animation.duration = animationDur;
    animation.fromValue = (__bridge id)(startPath.CGPath);
    animation.toValue = (__bridge id _Nullable)(endPath.CGPath);
    animation.delegate = self;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    [shapeLayer addAnimation:animation forKey:@"smallAnimation"];
}

#pragma mark ---- 变大的动画
-(void)animationToBigger
{
    self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    [self addSubview:_removeView];
    UIBezierPath *endPath = [UIBezierPath bezierPathWithOvalInRect:CGRectInset(_headerFrame, -kScreenHeight + 100, -kScreenHeight + 100)];
    UIBezierPath *startPath = [UIBezierPath bezierPathWithOvalInRect:_headerFrame];
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = startPath.CGPath;
    shapeLayer.backgroundColor = (__bridge CGColorRef _Nullable)([UIColor whiteColor]);
    _removeView.layer.mask = shapeLayer;
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"path"];
    animation.duration = animationDur;
    animation.fromValue = (__bridge id)(startPath.CGPath);
    animation.toValue = (__bridge id _Nullable)(endPath.CGPath);
    animation.delegate = self;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    [shapeLayer addAnimation:animation forKey:@"bigAnimation"];
    _becomeSmall = NO;
    
}

#pragma mark ------ AnimationDelegate
-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    //变小的时候
    if (_becomeSmall) {
        //截图
        [self screenShots];
        [_removeView removeFromSuperview];
        self.frame = _headerFrame;
        //设置动画
        [self moveAnimation];
    }else{
        _removeView.layer.mask = nil;
    }
}
#pragma mark ------ screenShots
-(void)screenShots
{
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(kScreenWidth, kScreenHeight), NO, 1);
    [_removeView drawViewHierarchyInRect:CGRectMake(0,0,CGRectGetWidth(_removeView.frame),CGRectGetHeight(_removeView.frame))afterScreenUpdates:NO];
    UIImage *shotImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIImage *image = [UIImage imageWithCGImage:CGImageCreateWithImageInRect([shotImage CGImage], _headerFrame)];
    _screenShotsImage = image;
}

-(void)moveAnimation
{
    _smallerImageView.hidden = NO;
    _smallerImageView.frame = CGRectMake(0, 0, CGRectGetWidth(_headerFrame), CGRectGetHeight(_headerFrame));
    _smallerImageView.image = _screenShotsImage;
    
    [UIView animateWithDuration:0.5f animations:^{
        self.frame = CGRectMake(kScreenWidth - 100, kScreenHeight - 200, CGRectGetWidth(_headerFrame), CGRectGetHeight(_headerFrame));
    } completion:^(BOOL finished) {
        _smallerImageView.image = [UIImage imageNamed:@"av_call"];
        _timeLabel.hidden = NO;
        _timeLabel.frame = CGRectMake(10, CGRectGetHeight(_headerFrame) - 35, CGRectGetWidth(_headerFrame) - 20, 20);
        if (!_isCalling) {
            _timeLabel.text = @"努力接通中...";
        }
    }];
}

-(void)setTimeLabelText:(NSString *)timerStrText
{
    _timeLabel.text = timerStrText;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/





@end
