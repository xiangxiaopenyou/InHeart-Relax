//
//  XJSTherapyModel.m
//  InHeart-Sleeping
//
//  Created by 项小盆友 on 2018/3/26.
//  Copyright © 2018年 项小盆友. All rights reserved.
//

#import "XJSTherapyModel.h"
#import <objc/message.h>

@implementation XJSTherapyModel
+ (void)therapiesList:(RequestResultHandler)handler {
    [[XJSBaseRequest new] postRequest:nil requestURLString:@"therapyList" result:^(id object, NSString *msg) {
        if (object) {
            NSArray *tempArray = [XJSTherapyModel modelArrayFromArray:(NSArray *)object];
            !handler ?: handler(tempArray, nil);
        } else {
            !handler ?: handler(nil, msg);
        }
    }];
}

@end
