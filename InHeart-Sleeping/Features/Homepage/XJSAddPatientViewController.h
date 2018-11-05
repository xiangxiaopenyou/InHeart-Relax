//
//  XJSAddPatientViewController.h
//  InHeart-Sleeping
//
//  Created by 项小盆友 on 2018/3/22.
//  Copyright © 2018年 项小盆友. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XJSPatientModel.h"
@interface XJSAddPatientViewController : UIViewController

@property (strong, nonatomic) XJSPatientModel *patientModel;
@property (nonatomic) BOOL isModifyInformations;
@property (copy, nonatomic) void (^modifyBlock)(XJSPatientModel *model);
@property (copy, nonatomic) void (^addBlock)(void);
@end
