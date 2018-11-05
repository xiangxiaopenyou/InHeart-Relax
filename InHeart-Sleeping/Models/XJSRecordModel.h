//
//  XJSRecordModel.h
//  InHeart-Sleeping
//
//  Created by 项小盆友 on 2018/4/8.
//  Copyright © 2018年 项小盆友. All rights reserved.
//

#import "XJSBaseModel.h"

@interface XJSRecordModel : XJSBaseModel
@property (copy, nonatomic) NSString *id;
@property (copy, nonatomic) NSString *patientId;
@property (copy, nonatomic) NSString *patientName;
@property (copy, nonatomic) NSString *hospitalId;
@property (copy, nonatomic) NSString *hospitalName;
@property (copy, nonatomic) NSString *time;
@property (copy, nonatomic) NSString *sceneId;
@property (copy, nonatomic) NSString *sceneName;
@property (copy, nonatomic) NSString *doctorId;
@property (copy, nonatomic) NSString *doctorName;
+ (void)recordsList:(NSString *)patientId date:(NSString *)dateString page:(NSNumber *)paging handler:(RequestResultHandler)handler;
@end
