//
//  XJSBaseModel.h
//  InHeart-Sleeping
//
//  Created by 项小盆友 on 2018/3/26.
//  Copyright © 2018年 项小盆友. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <YYModel.h>
#import "XJSBaseRequest.h"

@interface XJSBaseModel : NSObject <YYModel>
+ (NSArray *)modelArrayFromArray:(NSArray *)array;

@end
