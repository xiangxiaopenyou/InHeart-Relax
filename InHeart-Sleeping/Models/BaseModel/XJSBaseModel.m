//
//  XJSBaseModel.m
//  InHeart-Sleeping
//
//  Created by 项小盆友 on 2018/3/26.
//  Copyright © 2018年 项小盆友. All rights reserved.
//

#import "XJSBaseModel.h"

@implementation XJSBaseModel
+ (NSArray *)modelArrayFromArray:(NSArray *)array {
    NSMutableArray *resultArray = [NSMutableArray array];
    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        XJSBaseModel *model = [self yy_modelWithDictionary:(NSDictionary *)obj];
        [resultArray addObject:model];
    }];
    return resultArray;
}
@end
