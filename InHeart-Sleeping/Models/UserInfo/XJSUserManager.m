//
//  XJSUserManager.m
//  InHeart-Sleeping
//
//  Created by 项小盆友 on 2018/3/28.
//  Copyright © 2018年 项小盆友. All rights reserved.
//

#import "XJSUserManager.h"

@implementation XJSUserManager
+ (XJSUserManager *)sharedUserInfo {
    static XJSUserManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[XJSUserManager alloc] init];
    });
    return instance;
}
- (BOOL)isLogined {
    if ([[NSUserDefaults standardUserDefaults] stringForKey:USERTOKEN]) {
        return YES;
    } else {
        return NO;
    }
}
- (void)saveUserInfo:(XJSUserModel *)userModel {
    if (userModel.token) {
        [[NSUserDefaults standardUserDefaults] setObject:userModel.token forKey:USERTOKEN];
    }
    if (userModel.userId) {
        [[NSUserDefaults standardUserDefaults] setObject:userModel.userId forKey:USERID];
    }
    if (userModel.username) {
        [[NSUserDefaults standardUserDefaults] setObject:userModel.username forKey:USERNAME];
    }
    if (userModel.realname) {
        [[NSUserDefaults standardUserDefaults] setObject:userModel.realname forKey:USERREALNAME];
    }
}
- (void)removeUserInfo {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:USERID];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:USERTOKEN];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:USERREALNAME];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:USERNAME];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
