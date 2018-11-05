//
//  XJSPatientDetailViewController.m
//  InHeart-Sleeping
//
//  Created by 项小盆友 on 2018/3/30.
//  Copyright © 2018年 项小盆友. All rights reserved.
//

#import "XJSPatientDetailViewController.h"
#import "XJSAddPatientViewController.h"

#import "XLAlertControllerObject.h"

#import "XJSPatientModel.h"

@interface XJSPatientDetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *patientNumberLabel;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *genderLabel;
@property (weak, nonatomic) IBOutlet UILabel *ageLabel;
@property (weak, nonatomic) IBOutlet UILabel *diseaseLabel;
@property (weak, nonatomic) IBOutlet UILabel *educationLabel;
@property (weak, nonatomic) IBOutlet UILabel *maritalLabel;
@property (weak, nonatomic) IBOutlet UILabel *enterTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *identificationLabel;
@property (weak, nonatomic) IBOutlet UILabel *medicareLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (weak, nonatomic) IBOutlet UIButton *modifyButton;

@end

@implementation XJSPatientDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.deleteButton.layer.borderWidth = 0.5;
    self.deleteButton.layer.borderColor = XJSHexRGBColorWithAlpha(0xc37777, 1).CGColor;
    self.modifyButton.layer.borderWidth = 0.5;
    self.modifyButton.layer.borderColor = XJSHexRGBColorWithAlpha(0xabb4ec, 1).CGColor;
    [self fetchPatientDetail];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private methods
- (void)setupInformations:(XJSPatientModel *)model {
    self.patientNumberLabel.text = model.patientNumber;
    self.avatarImageView.image = model.gender.integerValue == 1? [UIImage imageNamed:@"head_boy"] : [UIImage imageNamed:@"head_girl"];
    self.nameLabel.text = model.realname;
    self.genderLabel.text = model.gender.integerValue == 1? @"男" : @"女";
    self.ageLabel.text = [NSString stringWithFormat:@"%@岁", model.age];
    self.diseaseLabel.text = model.symptoms;
    NSString *educationString = nil;
    switch (model.educationDegree.integerValue) {
        case XJSEducationDegreeNone:
            educationString = @"保密";
            break;
        case XJSEducationDegreeFirst:
            educationString = @"博士";
            break;
        case XJSEducationDegreeSecond:
            educationString = @"硕士";
            break;
        case XJSEducationDegreeThird:
            educationString = @"本科";
            break;
        case XJSEducationDegreeForth:
            educationString = @"大专";
            break;
        case XJSEducationDegreeFifth:
            educationString = @"中专和中技";
            break;
        case XJSEducationDegreeSixth:
            educationString = @"技工学校";
            break;
        case XJSEducationDegreeSeventh:
            educationString = @"高中";
            break;
        case XJSEducationDegreeEighth:
            educationString = @"初中";
            break;
        case XJSEducationDegreeNinth:
            educationString = @"小学";
            break;
        case XJSEducationDegreeTenth:
            educationString = @"文盲与半文盲";
            break;
        default:
            break;
    }
    self.educationLabel.text = [NSString stringWithFormat:@"学       历：%@", educationString];
    NSString *maritalString = nil;
    switch (model.maritalStatus.integerValue) {
        case XJSMaritalStatusNone:
            maritalString = @"保密";
            break;
        case XJSMaritalStatusNot:
            maritalString = @"未婚";
            break;
        case XJSMaritalStatusMarried:
            maritalString = @"已婚";
            break;
        default:
            break;
    }
    self.maritalLabel.text = [NSString stringWithFormat:@"婚姻状况：%@", maritalString];
    self.enterTimeLabel.text = [NSString stringWithFormat:@"入院时间：%@", [model.enterTime substringToIndex:10]];
    self.phoneLabel.text = XJSIsNullObject(model.phoneNumber)? @"手机号码：未知" : [NSString stringWithFormat:@"手机号码：%@", model.phoneNumber];
    self.medicareLabel.text = XJSIsNullObject(model.medicareNumber)? @"医保卡号：未知" : [NSString stringWithFormat:@"医保卡号：%@", model.medicareNumber];
    self.identificationLabel.text = XJSIsNullObject(model.identificationNumber)? @"身份证号：未知" : [NSString stringWithFormat:@"身份证号：%@", model.identificationNumber];
    self.addressLabel.text = XJSIsNullObject(model.address)? @"家庭住址：未知" : [NSString stringWithFormat:@"家庭住址：%@", model.address];
    
}

#pragma mark - Action
- (IBAction)deleteAction:(id)sender {
    [XLAlertControllerObject showWithTitle:@"确定删除该患者吗？" message:nil cancelTitle:@"取消" ensureTitle:@"删除" ensureBlock:^{
        [self deletePatientRequest];
    }];
}
- (IBAction)modifyAction:(id)sender {
    XJSAddPatientViewController *addPatientController = [self.storyboard instantiateViewControllerWithIdentifier:@"XJSAddPatient"];
    addPatientController.patientModel = self.patientModel;
    addPatientController.isModifyInformations = YES;
    addPatientController.modifyBlock = ^(XJSPatientModel *model) {
        self.patientModel = model;
        [self fetchPatientDetail];
        [[NSNotificationCenter defaultCenter] postNotificationName:XJSPatientInformationsDidModify object:self.patientModel];
    };
    [self.navigationController pushViewController:addPatientController animated:YES];
}

#pragma mark - Request
- (void)fetchPatientDetail {
    [MBProgressHUD showHUDAddedTo:XJSKeyWindow animated:YES];
    [XJSPatientModel patientDetail:self.patientModel.id handler:^(id object, NSString *msg) {
        [MBProgressHUD hideHUDForView:XJSKeyWindow animated:YES];
        if (object) {
            self.patientModel = (XJSPatientModel *)object;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self setupInformations:self.patientModel];
            });
        } else {
            XJSShowHud(NO, msg);
        }
    }];
}
- (void)deletePatientRequest {
    [MBProgressHUD showHUDAddedTo:XJSKeyWindow animated:YES];
    [XJSPatientModel deletePatient:self.patientModel.id handle:^(id object, NSString *msg) {
        [MBProgressHUD hideHUDForView:XJSKeyWindow animated:YES];
        if (object) {
            XJSShowHud(YES, @"删除成功");
            [self.navigationController popViewControllerAnimated:YES];
            [[NSNotificationCenter defaultCenter] postNotificationName:XJSPatientDidDelete object:self.patientModel];
        } else {
            XJSShowHud(NO, msg);
        }
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
