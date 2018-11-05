//
//  XJSChooseDevicesView.h
//  InHeart-Sleeping
//
//  Created by 项小盆友 on 2018/4/2.
//  Copyright © 2018年 项小盆友. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XJSDeviceModel;

@interface XJSChooseDevicesView : UIView
@property (copy, nonatomic) void (^comfirmBlock)(XJSDeviceModel *model);
- (void)show;
- (void)dismiss;
- (void)setupContentData:(NSArray *)deviceArray device:(XJSDeviceModel *)deviceModel;

@end
