//
//  XJSPatientModel.h
//  InHeart-Sleeping
//
//  Created by 项小盆友 on 2018/3/27.
//  Copyright © 2018年 项小盆友. All rights reserved.
//

#import "XJSBaseModel.h"

@interface XJSPatientModel : XJSBaseModel
@property (copy, nonatomic) NSString *id;
@property (copy, nonatomic) NSString *patientNumber;
@property (copy, nonatomic) NSString *realname;
@property (strong, nonatomic) NSNumber *gender;
@property (strong, nonatomic) NSNumber *age;
@property (copy, nonatomic) NSString *medicareNumber;
@property (copy, nonatomic) NSString *identificationNumber;
@property (copy, nonatomic) NSString *symptoms;
@property (strong, nonatomic) NSNumber *maritalStatus;
@property (strong, nonatomic) NSNumber *educationDegree;
@property (copy, nonatomic) NSString *phoneNumber;
@property (copy, nonatomic) NSString *enterTime;
@property (copy, nonatomic) NSString *address;
@property (copy, nonatomic) NSString *ts;
+ (void)addPatient:(NSDictionary *)params handler:(RequestResultHandler)handler;
+ (void)patientsList:(NSString *)keyword page:(NSNumber *)paging handler:(RequestResultHandler)handler;
+ (void)patientDetail:(NSString *)patientId handler:(RequestResultHandler)handler;
+ (void)modifyPatientInformations:(NSDictionary *)params handler:(RequestResultHandler)handler;
+ (void)deletePatient:(NSString *)patientId handle:(RequestResultHandler)handler;
@end
