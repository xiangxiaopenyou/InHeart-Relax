//
//  XJSPatientCommonInfomationCell.m
//  InHeart-Sleeping
//
//  Created by 项小盆友 on 2018/3/22.
//  Copyright © 2018年 项小盆友. All rights reserved.
//

#import "XJSPatientCommonInfomationCell.h"

#import "XJSPatientModel.h"

@implementation XJSPatientCommonInfomationCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.viewOfInput.layer.masksToBounds = YES;
    self.viewOfInput.layer.cornerRadius = 10.f;
    self.viewOfInput.layer.borderWidth = 0.5;
    self.viewOfInput.layer.borderColor = XJSHexRGBColorWithAlpha(0xb7b7b7, 1).CGColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setupContentView:(NSInteger)tableViewType index:(NSInteger)cellIndex {
    NSArray *leftItemArray = @[@"病案号", @"姓名", @"性别", @"年龄", @"医保卡", @"身份证"];
    NSArray *leftPlaceholderArray = @[@"病案号", @"姓名", @"选择性别", @"年龄", @"卡号", @"号码"];
    NSArray *rightItemArray = @[@"症状", @"婚姻状况", @"文化程度", @"手机号", @"入院日期", @"家庭住址"];
    NSArray *rightPlaceholderArray = @[@"症状", @"选择婚姻状况", @"选择文化程度", @"号码", @"选择日期", @"住址"];
    if (tableViewType == 1) {
        self.itemNameLabel.text = leftItemArray[cellIndex];
        self.textField.placeholder = leftPlaceholderArray[cellIndex];
        self.textField.enabled = cellIndex == 2 ? NO : YES;
        self.textField.keyboardType = cellIndex == 1 ? UIKeyboardTypeDefault : UIKeyboardTypeDecimalPad;
        self.asteriskImageView.hidden = cellIndex >= 0 && cellIndex <= 3 ? NO : YES;
        if (cellIndex == 2) {
            self.tipImageView.hidden = NO;
            self.tipImageView.image = [UIImage imageNamed:@"information_pulldown"];
        } else {
            self.tipImageView.hidden = YES;
        }
    } else {
        self.itemNameLabel.text = rightItemArray[cellIndex];
        self.textField.placeholder = rightPlaceholderArray[cellIndex];
        self.textField.enabled = cellIndex == 1 || cellIndex == 2 ? NO : YES;
        self.textField.keyboardType = cellIndex == 3 ? UIKeyboardTypeDecimalPad : UIKeyboardTypeDefault;
        self.asteriskImageView.hidden = cellIndex == 0 ? NO : YES;
        if (cellIndex == 1 || cellIndex == 2) {
            self.tipImageView.hidden = NO;
            self.tipImageView.image = [UIImage imageNamed:@"information_pulldown"];
        } else if (cellIndex == 4) {
            self.tipImageView.hidden = NO;
            self.tipImageView.image = [UIImage imageNamed:@"information_date"];
            UIDatePicker *datePicker = [[UIDatePicker alloc] init];
            
            //设置地区: zh-中国
            datePicker.locale = [NSLocale localeWithLocaleIdentifier:@"zh"];
            //设置日期模式
            datePicker.datePickerMode = UIDatePickerModeDate;
            // 设置当前显示时间
            [datePicker setDate:[NSDate date] animated:YES];
            // 设置显示最大时间（此处为当前时间）
            [datePicker setMaximumDate:[NSDate date]];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd"];
            NSDate *minDate = [dateFormatter dateFromString:@"2018-01-01"];
            [datePicker setMinimumDate:minDate];
            //监听DataPicker的滚动
            [datePicker addTarget:self action:@selector(dateChange:) forControlEvents:UIControlEventValueChanged];
            //设置时间输入框的键盘框样式为时间选择器
            self.textField.inputView = datePicker;
            
        } else {
            self.tipImageView.hidden = YES;
        }
    }
}
- (void)addContentData:(XJSPatientModel *)model tableType:(NSInteger)tableViewType index:(NSInteger)cellIndex {
    if (tableViewType == 1) {
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
                self.textField.text = model.medicareNumber ? model.medicareNumber : nil;
            }
                break;
            case 5: {
                self.textField.text = model.identificationNumber ? model.identificationNumber : nil;
            }
                break;
                
            default:
                break;
        }
    } else {
        switch (cellIndex) {
            case 0: {
                self.textField.text = model.symptoms ? model.symptoms : nil;
            }
                break;
            case 1: {
                if (model.maritalStatus.integerValue == XJSMaritalStatusNone) {
                    self.textField.text = @"保密";
                } else if (model.maritalStatus.integerValue == XJSMaritalStatusNot) {
                    self.textField.text = @"未婚";
                } else {
                    self.textField.text = @"已婚";
                }
            }
                break;
            case 2: {
                switch (model.educationDegree.integerValue) {
                    case XJSEducationDegreeNone: {
                        self.textField.text = @"保密";
                    }
                        break;
                    case XJSEducationDegreeFirst: {
                        self.textField.text = @"博士";
                    }
                        break;
                    case XJSEducationDegreeSecond: {
                        self.textField.text = @"硕士";
                    }
                        break;
                    case XJSEducationDegreeThird: {
                        self.textField.text = @"本科";
                    }
                        break;
                    case XJSEducationDegreeForth: {
                        self.textField.text = @"大专";
                    }
                        break;
                    case XJSEducationDegreeFifth: {
                        self.textField.text = @"中专和中技";
                    }
                        break;
                    case XJSEducationDegreeSixth: {
                        self.textField.text = @"技工学校";
                    }
                        break;
                    case XJSEducationDegreeSeventh: {
                        self.textField.text = @"高中";
                    }
                        break;
                    case XJSEducationDegreeEighth: {
                        self.textField.text = @"初中";
                    }
                        break;
                    case XJSEducationDegreeNinth: {
                        self.textField.text = @"小学";
                    }
                        break;
                    case XJSEducationDegreeTenth: {
                        self.textField.text = @"文盲与半文盲";
                    }
                        break;
                        
                    default:
                        break;
                }
            }
                break;
            case 3: {
                self.textField.text = model.phoneNumber ? model.phoneNumber : nil;
            }
                break;
            case 4: {
                self.textField.text = model.enterTime ? [model.enterTime substringToIndex:10] : nil;
            }
                break;
            case 5: {
                self.textField.text = model.address ? model.address : nil;
            }
                break;
                
            default:
                break;
        }
    }
}
- (void)dateChange:(UIDatePicker *)datePicker {
    NSDate *selectedDate = datePicker.date;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateString = [dateFormatter stringFromDate:selectedDate];
    if (self.delegate && [self.delegate respondsToSelector:@selector(dateDidChange:)]) {
        [self.delegate dateDidChange:dateString];
    }
}

@end
