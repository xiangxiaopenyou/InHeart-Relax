//
//  XJSSceneModel.h
//  InHeart-Sleeping
//
//  Created by 项小盆友 on 2018/3/26.
//  Copyright © 2018年 项小盆友. All rights reserved.
//

#import "XJSBaseModel.h"

@interface XJSSceneModel : XJSBaseModel
    @property (copy, nonatomic) NSString *id;
    @property (copy, nonatomic) NSString *name;
    @property (copy, nonatomic) NSString *mtname;
    @property (copy, nonatomic) NSString *introduction;
    @property (copy, nonatomic) NSString *coverPictureUrl;
+ (void)scenesList:(NSString *)therapyId page:(NSNumber *)paging handler:(RequestResultHandler)handler;
+ (void)playScene:(NSDictionary *)params handler:(RequestResultHandler)handler;
@end
