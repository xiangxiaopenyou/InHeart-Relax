//
//  XJSUserManager.h
//  InHeart-Sleeping
//
//  Created by 项小盆友 on 2018/3/28.
//  Copyright © 2018年 项小盆友. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XJSUserModel.h"
@interface XJSUserManager : NSObject

+ (XJSUserManager *)sharedUserInfo;
- (BOOL)isLogined;
- (void)saveUserInfo:(XJSUserModel *)userModel;
- (void)removeUserInfo;

@end
