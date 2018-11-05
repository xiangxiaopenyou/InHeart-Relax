//
//  XJTUtilitiesDefines.h
//  InHeart-Training
//
//  Created by 项小盆友 on 2018/1/15.
//  Copyright © 2018年 项小盆友. All rights reserved.
//

#import "XJSUtilities.h"
//主界面
#define XJSKeyWindow [UIApplication sharedApplication].keyWindow
//主界面宽
#define XJSScreenWidth CGRectGetWidth([UIApplication sharedApplication].keyWindow.bounds)
//主界面高
#define XJSScreenHeight CGRectGetHeight([UIApplication sharedApplication].keyWindow.bounds)

/**
 *  RGB颜色
 */
#define XJSRGBColor(r,g,b,a)    [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

/**
 *  Hex颜色转RGB颜色
 */
#define XJSHexRGBColorWithAlpha(rgbValue,a) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:a]

/**
 *  系统字体
 */
#define XJSSystemFont(x) [UIFont systemFontOfSize:x]
#define XJSBoldSystemFont(x) [UIFont boldSystemFontOfSize:x]

//判空
#define XJSIsNullObject(anObject) [XJSUtilities isNullObject:anObject]

#define XJSShowHud(isSuccess, aMessage) [XJSUtilities showHud:isSuccess message:aMessage]

#define XJSIsMobileNumber(aNumber) [XJSUtilities isMobileNumber:aNumber]
