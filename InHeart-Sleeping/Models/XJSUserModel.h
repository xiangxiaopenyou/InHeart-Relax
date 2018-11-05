//
//  XJSUserModel.h
//  InHeart-Sleeping
//
//  Created by 项小盆友 on 2018/3/27.
//  Copyright © 2018年 项小盆友. All rights reserved.
//

#import "XJSBaseModel.h"

@interface XJSUserModel : XJSBaseModel
@property (copy, nonatomic) NSString *token;
@property (copy, nonatomic) NSString *userId;
@property (copy, nonatomic) NSString *username;
@property (copy, nonatomic) NSString *realname;

+ (void)login:(NSDictionary *)params handler:(RequestResultHandler)handler;
+ (void)logout:(RequestResultHandler)handler;
+ (void)modifyInformation:(NSDictionary *)params handler:(RequestResultHandler)handler;
@end
