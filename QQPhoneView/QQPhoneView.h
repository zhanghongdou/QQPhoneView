//
//  QQPhoneView.h
//  QQPhoneView
//
//  Created by haohao on 16/10/9.
//  Copyright © 2016年 haohao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Const.h"
@protocol QQPhoneViewDelegate <NSObject>
//悬浮窗点击事件
-(void)anything;
@end
@interface QQPhoneView : UIWindow
@property (nonatomic, strong) UIView *needToRemoveView;
@property(nonatomic ,strong)id<QQPhoneViewDelegate> delegate;
-(void)becomeSmallerWithFrame:(CGRect)rect WithView:(UIView *)view WithCallState:(BOOL)isCalling;
//设置显示时间
-(void)setTimeLabelText:(NSString *)timerStrText;
@end
