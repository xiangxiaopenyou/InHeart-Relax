//
//  XJSBaseRequest.m
//  InHeart-Sleeping
//
//  Created by 项小盆友 on 2018/3/23.
//  Copyright © 2018年 项小盆友. All rights reserved.
//

#import "XJSBaseRequest.h"
#import "XJSHttpManager.h"

@implementation XJSBaseRequest
- (instancetype)init {
    self = [super init];
    if (self) {
        self.params = [[NSMutableDictionary alloc] init];
        if ([[NSUserDefaults standardUserDefaults] stringForKey:USERTOKEN]) {
            NSString *userToken = [[NSUserDefaults standardUserDefaults] stringForKey:USERTOKEN];
            [self.params setObject:userToken forKey:@"token"];
        }
    }
    return self;
}
- (void)postRequest:(NSDictionary *)params requestURLString:(NSString *)urlString result:(RequestResultHandler)handler {
    if (params) {
        [self.params addEntriesFromDictionary:params];
    }
    [[XJSHttpManager sharedInstance] POST:urlString parameters:self.params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"success"] boolValue]) {
            !handler ?: handler(responseObject[@"data"], nil);
        } else {
            if ([responseObject[@"code"] integerValue] == 95 ||
                [responseObject[@"code"] integerValue] == 97 ||
                [responseObject[@"code"] integerValue] == 98) {
                !handler ?: handler(nil, responseObject[@"message"]);
                [[XJSUserManager sharedUserInfo] removeUserInfo];
                [[NSNotificationCenter defaultCenter] postNotificationName:XJSLoginStatusDidChange object:@NO];
            } else {
                !handler ?: handler(nil, responseObject[@"message"]);
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        !handler ?: handler(nil, NETWORKERRORTIP);
    }];
}

@end
