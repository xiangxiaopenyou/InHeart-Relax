//
//  XJSDeviceModel.m
//  InHeart-Sleeping
//
//  Created by 项小盆友 on 2018/4/2.
//  Copyright © 2018年 项小盆友. All rights reserved.
//

#import "XJSDeviceModel.h"

@implementation XJSDeviceModel
+ (void)devicesList:(RequestResultHandler)handler {
    [[XJSBaseRequest new] postRequest:nil requestURLString:@"devicesList" result:^(id object, NSString *msg) {
        if (object) {
            NSArray *tempArray = [XJSDeviceModel modelArrayFromArray:(NSArray *)object];
            !handler ?: handler(tempArray, nil);
        } else {
            !handler ?: handler(nil, msg);
        }
    }];
}

@end
