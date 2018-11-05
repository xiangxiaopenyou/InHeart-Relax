//
//  XJSDeviceModel.h
//  InHeart-Sleeping
//
//  Created by 项小盆友 on 2018/4/2.
//  Copyright © 2018年 项小盆友. All rights reserved.
//

#import "XJSBaseModel.h"

@interface XJSDeviceModel : XJSBaseModel
@property (copy, nonatomic) NSString *deviceId;
@property (copy, nonatomic) NSString *deviceName;
+ (void)devicesList:(RequestResultHandler)handler;
@end
