//
//  XJSSceneModel.m
//  InHeart-Sleeping
//
//  Created by 项小盆友 on 2018/3/26.
//  Copyright © 2018年 项小盆友. All rights reserved.
//

#import "XJSSceneModel.h"

@implementation XJSSceneModel
+ (void)scenesList:(NSString *)therapyId page:(NSNumber *)paging handler:(RequestResultHandler)handler {
    NSDictionary *params = @{ @"therapyId" : therapyId, @"paging" : paging };
    [[XJSBaseRequest new] postRequest:params requestURLString:@"scenesList" result:^(id object, NSString *msg) {
        if (object) {
            if (XJSIsNullObject(object)) {
                !handler ?: handler([NSArray new], nil);
            } else {
                NSArray *tempArray = [XJSSceneModel modelArrayFromArray:(NSArray *)object];
                !handler ?: handler(tempArray, nil);
            }
        } else {
            !handler ?: handler(nil, msg);
        }
    }];
}
+ (void)playScene:(NSDictionary *)params handler:(RequestResultHandler)handler {
    [[XJSBaseRequest new] postRequest:params requestURLString:@"playScene" result:^(id object, NSString *msg) {
        if (object) {
            !handler ?: handler(object, nil);
        } else {
            !handler ?: handler(nil, msg);
        }
    }];
}
@end
