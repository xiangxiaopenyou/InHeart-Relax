//
//  XJSPatientModel.m
//  InHeart-Sleeping
//
//  Created by 项小盆友 on 2018/3/27.
//  Copyright © 2018年 项小盆友. All rights reserved.
//

#import "XJSPatientModel.h"

@implementation XJSPatientModel
+ (void)addPatient:(NSDictionary *)params handler:(RequestResultHandler)handler {
    [[XJSBaseRequest new] postRequest:params requestURLString:@"addPatient" result:^(id object, NSString *msg) {
        if (object) {
            !handler ?: handler(object, nil);
        } else {
            !handler ?: handler(nil, msg);
        }
    }];
}
+ (void)patientsList:(NSString *)keyword page:(NSNumber *)paging handler:(RequestResultHandler)handler {
    NSMutableDictionary *params = [@{@"paging" : paging} mutableCopy];
    if (keyword) {
        [params setObject:keyword forKey:@"keyword"];
    }
    [[XJSBaseRequest new] postRequest:params requestURLString:@"patientsList" result:^(id object, NSString *msg) {
        if (object) {
            NSArray *tempArray = [XJSPatientModel modelArrayFromArray:(NSArray *)object];
            !handler ?: handler(tempArray, nil);
        } else {
            !handler ?: handler(nil, msg);
        }
    }];
}
+ (void)patientDetail:(NSString *)patientId handler:(RequestResultHandler)handler {
    NSDictionary *params = @{@"id" : patientId};
    [[XJSBaseRequest new] postRequest:params requestURLString:@"patientInformations" result:^(id object, NSString *msg) {
        if (object) {
            XJSPatientModel *tempModel = [XJSPatientModel yy_modelWithDictionary:(NSDictionary *)object];
            !handler ?: handler(tempModel, nil);
        } else {
            !handler ?: handler(nil, msg);
        }
    }];
}
+ (void)modifyPatientInformations:(NSDictionary *)params handler:(RequestResultHandler)handler {
    [[XJSBaseRequest new] postRequest:params requestURLString:@"updatePatient" result:^(id object, NSString *msg) {
        if (object) {
            !handler ?: handler(object, nil);
        } else {
            !handler ?: handler(nil, msg);
        }
    }];
}
+ (void)deletePatient:(NSString *)patientId handle:(RequestResultHandler)handler {
    NSDictionary *params = @{@"id" : patientId};
    [[XJSBaseRequest new] postRequest:params requestURLString:@"deletePatient" result:^(id object, NSString *msg) {
        if (object) {
            !handler ?: handler(object, nil);
        } else {
            !handler ?: handler(nil, msg);
        }
    }];
}

@end
