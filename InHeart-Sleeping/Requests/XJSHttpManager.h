//
//  XJSHttpManager.h
//  InHeart-Sleeping
//
//  Created by 项小盆友 on 2018/3/23.
//  Copyright © 2018年 项小盆友. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

@interface XJSHttpManager : AFHTTPSessionManager
+ (instancetype)sharedInstance;

@end
