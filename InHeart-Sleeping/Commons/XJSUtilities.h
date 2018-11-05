//
//  XJSUtilities.h
//  InHeart-Training
//
//  Created by 项小盆友 on 2018/1/15.
//  Copyright © 2018年 项小盆友. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XJSUtilities : NSObject
+ (BOOL)isNullObject:(id)anObject;
+ (void)showHud:(BOOL)isSuccess message:(NSString *)message;
+ (BOOL)isMobileNumber:(NSString *)phoneNumber;
@end
