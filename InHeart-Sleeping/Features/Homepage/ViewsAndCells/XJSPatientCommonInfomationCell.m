//
//  XJSPatientCommonInfomationCell.m
//  InHeart-Sleeping
//
//  Created by 项小盆友 on 2018/3/22.
//  Copyright © 2018年 项小盆友. All rights reserved.
//

#import "XJSPatientCommonInfomationCell.h"
#import "UIView+XPYRoundedCorner.h"

#import "XJSPatientModel.h"

@implementation XJSPatientCommonInfomationCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
//    self.viewOfInput.layer.masksToBounds = YES;
//    self.viewOfInput.layer.cornerRadius = 10.f;
//    self.viewOfInput.layer.borderWidth = 0.5;
//    self.viewOfInput.layer.borderColor = XJSHexRGBColorWithAlpha(0xb7b7b7, 1).CGColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setupContentView:(NSInteger)cellIndex {
    //输入框圆角
    [self.viewOfInput borderWithRadius:10.f borderWidth:0.5 borderColor:XJSHexRGBColorWithAlpha(0xb7b7b7, 1) cornerType:UIRectCornerAllCorners];
    
    NSArray *itemArray = @[@"编号", @"姓名", @"性别", @"年龄", @"手机号", @"备注"];
    NSArray *placeholderArray = @[@"输入编号", @"输入姓名", @"选择性别", @"输入年龄", @"输入手机号", @"输入备注"];
    self.itemNameLabel.text = itemArray[cellIndex];
    self.textField.placeholder = placeholderArray[cellIndex];
    self.textField.enabled = cellIndex == 2 ? NO : YES;
    self.textField.keyboardType = cellIndex == 1 || cellIndex == 5 ? UIKeyboardTypeDefault : UIKeyboardTypeDecimalPad;
    self.asteriskImageView.hidden = cellIndex >= 0 && cellIndex <= 3 ? NO : YES;
    if (cellIndex == 2) {
        self.tipImageView.hidden = NO;
        self.tipImageView.image = [UIImage imageNamed:@"information_pulldown"];
    } else {
        self.tipImageView.hidden = YES;
    }
}
- (void)addContentData:(XJSPatientModel *)model index:(NSInteger)cellIndex {
    switch (cellIndex) {
        case 0: {
            self.textField.text = model.patientNumber ? model.patientNumber : nil;
        }
            break;
        case 1: {
            self.textField.text = model.realname ? model.realname : nil;
        }
            break;
        case 2: {
            if (model.gender) {
                self.textField.text = model.gender.integerValue == XJSUserGenderMale ? @"男" : @"女";
            } else {
                self.textField.text = nil;
            }
        }
            break;
        case 3: {
            if (model.age) {
                self.textField.text = [NSString stringWithFormat:@"%d", model.age.intValue];
            } else {
                self.textField.text = nil;
            }
        }
            break;
        case 4: {
            self.textField.text = model.phoneNumber ? model.phoneNumber : nil;
        }
            break;
        case 5: {
            self.textField.text = model.identificationNumber ? model.identificationNumber : nil;
        }
            break;
        
        default:
            break;
    }
}

@end
