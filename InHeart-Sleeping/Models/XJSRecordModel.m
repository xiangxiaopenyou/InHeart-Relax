//
//  XJSRecordModel.m
//  InHeart-Sleeping
//
//  Created by 项小盆友 on 2018/4/8.
//  Copyright © 2018年 项小盆友. All rights reserved.
//

#import "XJSRecordModel.h"

@implementation XJSRecordModel
+ (void)recordsList:(NSString *)patientId date:(NSString *)dateString page:(NSNumber *)paging handler:(RequestResultHandler)handler {
    NSMutableDictionary *params = [@{@"patientId" : patientId,
                                     @"paging" : paging
                                     } mutableCopy];
    if (dateString) {
        [params setObject:dateString forKey:@"datetime"];
    }
    [[XJSBaseRequest new] postRequest:params requestURLString:@"trainingRecordsList" result:^(id object, NSString *msg) {
        if (object) {
            NSArray *tempArray = [XJSRecordModel modelArrayFromArray:(NSArray *)object];
            !handler ?: handler(tempArray, nil);
        } else {
            !handler ?: handler(nil, msg);
        }
    }];
}

@end
