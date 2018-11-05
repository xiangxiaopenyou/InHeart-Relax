//
//  XJSBaseRequest.h
//  InHeart-Sleeping
//
//  Created by 项小盆友 on 2018/3/23.
//  Copyright © 2018年 项小盆友. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef BOOL (^ParamsBlock)(id request);
typedef void (^RequestResultHandler)(id object, NSString *msg);

@interface XJSBaseRequest : NSObject
@property (strong, nonatomic) NSMutableDictionary *params;
- (void)postRequest:(NSDictionary *)params requestURLString:(NSString *)urlString result:(RequestResultHandler)handler;

@end
