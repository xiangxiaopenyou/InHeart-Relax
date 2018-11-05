//
//  UIView+XPYRoundedCorner.h
//  InHeart-Sleeping
//
//  Created by 项小盆友 on 2018/11/5.
//  Copyright © 2018年 项小盆友. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (XPYRoundedCorner)
    - (void)borderWithRadius:(CGFloat)cornerRadius borderWidth:(CGFloat)width borderColor:(UIColor *)color cornerType:(UIRectCorner)corners;

@end

NS_ASSUME_NONNULL_END
