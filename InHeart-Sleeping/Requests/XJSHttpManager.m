//
//  XJSHttpManager.m
//  InHeart-Sleeping
//
//  Created by 项小盆友 on 2018/3/23.
//  Copyright © 2018年 项小盆友. All rights reserved.
//

#import "XJSHttpManager.h"
//static NSString * const BASEURL = @"http://test.med-vision.cn/api/v1/appControllerSm/";
static NSString * const BASEURL = /*@"http://10.12.254.11:8081/api/v1/appControllerSm/"; //*/@"http://support.med-vision.cn/api/v1/appControllerSm/";

@implementation XJSHttpManager
+ (instancetype)sharedInstance {
    static XJSHttpManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[XJSHttpManager alloc] initWithBaseURL:[NSURL URLWithString:BASEURL]];
        AFJSONRequestSerializer *requestSerializer = [AFJSONRequestSerializer serializer];
        [requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [requestSerializer setHTTPShouldHandleCookies:YES];
        AFJSONResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializer];
        NSMutableSet *types = [[responseSerializer acceptableContentTypes] mutableCopy];
        [types addObjectsFromArray:@[@"text/plain", @"text/html"]];
        responseSerializer.acceptableContentTypes = types;
        instance.requestSerializer = requestSerializer;
        instance.responseSerializer = responseSerializer;
        [NSURLSessionConfiguration defaultSessionConfiguration].HTTPMaximumConnectionsPerHost = 1;
        [NSURLSessionConfiguration defaultSessionConfiguration].timeoutIntervalForRequest = 10;
//        AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
//        securityPolicy.allowInvalidCertificates = YES;
//        securityPolicy.validatesDomainName = NO;
//        instance.securityPolicy = securityPolicy;
    });
    return instance;
}

@end
