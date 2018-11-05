//
//  XJTUtilities.m
//  InHeart-Training
//
//  Created by 项小盆友 on 2018/1/15.
//  Copyright © 2018年 项小盆友. All rights reserved.
//

#import "XJSUtilities.h"

@implementation XJSUtilities
+ (BOOL)isNullObject:(id)anObject {
    if (!anObject || [anObject isEqual:@""] || [anObject isEqual:[NSNull null]] || [anObject isKindOfClass:[NSNull class]]) {
        return YES;
    } else {
        return NO;
    }
}
+ (void)showHud:(BOOL)isSuccess message:(NSString *)message {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:XJSKeyWindow animated:YES];
    hud.detailsLabel.text = message;
    UIImageView *customImage = [[UIImageView alloc] init];
    customImage.image = isSuccess ? [UIImage imageNamed:@"success_tip"] : [UIImage imageNamed:@"error_tip"];
    hud.customView = customImage;
    hud.mode = MBProgressHUDModeCustomView;
    hud.removeFromSuperViewOnHide = YES;
    [hud hideAnimated:YES afterDelay:1.f];
}
+ (BOOL)isMobileNumber:(NSString *)phoneNumber {
    NSString *mobile = @"^1(3[0-9]|4[57]|5[0-35-9]|8[0-9]|7[0678])\\d{8}$";
    NSPredicate *regextestMobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", mobile];
    return [regextestMobile evaluateWithObject:phoneNumber];
}

@end
