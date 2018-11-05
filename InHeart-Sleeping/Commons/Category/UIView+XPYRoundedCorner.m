//
//  UIView+XPYRoundedCorner.m
//  InHeart-Sleeping
//
//  Created by 项小盆友 on 2018/11/5.
//  Copyright © 2018年 项小盆友. All rights reserved.
//

#import "UIView+XPYRoundedCorner.h"

@implementation UIView (XPYRoundedCorner)
    - (void)borderWithRadius:(CGFloat)cornerRadius borderWidth:(CGFloat)width borderColor:(UIColor *)color cornerType:(UIRectCorner)corners
    {
        CGRect rect = CGRectMake(width / 2.0, width / 2.0, CGRectGetWidth(self.frame) - width, CGRectGetHeight(self.frame) - width);
        CGSize radii = CGSizeMake(cornerRadius, width);
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:corners cornerRadii:radii];
        
        CAShapeLayer *shaperLayer = [CAShapeLayer layer];
        shaperLayer.strokeColor = color.CGColor;
        shaperLayer.fillColor = [UIColor clearColor].CGColor;
        shaperLayer.lineWidth = width;
        shaperLayer.lineJoin = kCALineJoinRound;
        shaperLayer.lineCap = kCALineCapRound;
        shaperLayer.path = path.CGPath;
        [self.layer addSublayer:shaperLayer];
    }

@end
