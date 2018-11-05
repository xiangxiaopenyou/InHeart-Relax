//
//  XJSTherapyModel.h
//  InHeart-Sleeping
//
//  Created by 项小盆友 on 2018/3/26.
//  Copyright © 2018年 项小盆友. All rights reserved.
//

#import "XJSBaseModel.h"

@interface XJSTherapyModel : XJSBaseModel
@property (copy, nonatomic) NSString *id;
@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *instructions;
@property (copy, nonatomic) NSString *attention;
+ (void)therapiesList:(RequestResultHandler)handler;

@end
