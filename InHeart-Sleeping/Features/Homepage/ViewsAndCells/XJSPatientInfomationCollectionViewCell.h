//
//  XJSPatientInfomationCollectionViewCell.h
//  InHeart-Sleeping
//
//  Created by 项小盆友 on 2018/3/21.
//  Copyright © 2018年 项小盆友. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XJSPatientModel.h"
@protocol XJSPatientInfomationCellDelegate<NSObject>
- (void)didClickTraining:(XJSPatientModel *)model;
- (void)didClickRecord:(XJSPatientModel *)model;
@end

@interface XJSPatientInfomationCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *avatarBackground;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *ageLabel;
@property (weak, nonatomic) IBOutlet UIImageView *genderImageView;
@property (weak, nonatomic) IBOutlet UILabel *diseaseLabel;
@property (weak, nonatomic) IBOutlet UILabel *patientNumberLabel;

@property (strong, nonatomic) XJSPatientModel *patientModel;

@property (weak, nonatomic) id<XJSPatientInfomationCellDelegate> delegate;

@end
