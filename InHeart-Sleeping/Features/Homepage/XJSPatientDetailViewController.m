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
    @property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
    @property (weak, nonatomic) IBOutlet UILabel *remarksLabel;
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
    self.phoneLabel.text = XJSIsNullObject(model.phoneNumber)? @"手机号码：未知" : [NSString stringWithFormat:@"手机号码：%@", model.phoneNumber];
    self.remarksLabel.hidden = XJSIsNullObject(model.remarks)? YES : NO;
    self.remarksLabel.text = [NSString stringWithFormat:@"备注：%@", model.remarks];
}

#pragma mark - Action
- (IBAction)deleteAction:(id)sender {
    [XLAlertControllerObject showWithTitle:@"确定删除该用户吗？" message:nil cancelTitle:@"取消" ensureTitle:@"删除" ensureBlock:^{
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
