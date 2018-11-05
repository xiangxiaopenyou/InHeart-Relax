//
//  XJSUserModel.m
//  InHeart-Sleeping
//
//  Created by 项小盆友 on 2018/3/27.
//  Copyright © 2018年 项小盆友. All rights reserved.
//

#import "XJSUserModel.h"

@implementation XJSUserModel
+ (void)login:(NSDictionary *)params handler:(RequestResultHandler)handler {
    [[XJSBaseRequest new] postRequest:params requestURLString:@"login" result:^(id object, NSString *msg) {
        if (object) {
            XJSUserModel *userModel = [XJSUserModel yy_modelWithDictionary:(NSDictionary *)object];
            !handler ?: handler(userModel, nil);
        } else {
            !handler ?: handler(nil, msg);
        }
    }];
}
+ (void)logout:(RequestResultHandler)handler {
    [[XJSBaseRequest new] postRequest:nil requestURLString:@"logout" result:^(id object, NSString *msg) {
        if (object) {
            !handler ?: handler(object, nil);
        } else {
            !handler ?: handler(nil, msg);
        }
    }];
}
+ (void)modifyInformation:(NSDictionary *)params handler:(RequestResultHandler)handler {
    [[XJSBaseRequest new] postRequest:params requestURLString:@"modifyInformations" result:^(id object, NSString *msg) {
        if (object) {
            !handler ?: handler(object, nil);
        } else {
            !handler ?: handler(nil, msg);
        }
    }];
}

@end
