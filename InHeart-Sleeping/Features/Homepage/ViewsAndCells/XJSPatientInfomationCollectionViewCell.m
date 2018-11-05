//
//  XJSPatientInfomationCollectionViewCell.m
//  InHeart-Sleeping
//
//  Created by 项小盆友 on 2018/3/21.
//  Copyright © 2018年 项小盆友. All rights reserved.
//

#import "XJSPatientInfomationCollectionViewCell.h"

@implementation XJSPatientInfomationCollectionViewCell
- (IBAction)recordAction:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickRecord:)]) {
        [self.delegate didClickRecord:self.patientModel];
    }
}
- (IBAction)trainingAction:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickTraining:)]) {
        [self.delegate didClickTraining:self.patientModel];
    }
}

@end
