//
//  XJSAddPatientViewController.m
//  InHeart-Sleeping
//
//  Created by 项小盆友 on 2018/3/22.
//  Copyright © 2018年 项小盆友. All rights reserved.
//

#import "XJSAddPatientViewController.h"
#import "XJSPatientCommonInfomationCell.h"


@interface XJSAddPatientViewController () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITableView *leftTableView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *rightItem;

@end

@implementation XJSAddPatientViewController
#pragma mark - View controller life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (self.isModifyInformations) {
        self.title = @"修改用户信息";
        self.rightItem.title = @"修改";
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Action
- (IBAction)addAction:(id)sender {
    [self.view endEditing:YES];
    if (XJSIsNullObject(self.patientModel.patientNumber)) {
        XJSShowHud(NO, @"请输入编号");
        return;
    }
    if (XJSIsNullObject(self.patientModel.realname)) {
        XJSShowHud(NO, @"请输入姓名");
        return;
    }
    if (XJSIsNullObject(self.patientModel.gender)) {
        XJSShowHud(NO, @"请选择性别");
        return;
    }
    if (XJSIsNullObject(self.patientModel.age)) {
        XJSShowHud(NO, @"请输入年龄");
        return;
    }
    NSMutableDictionary *params = [@{@"patientNumber" : self.patientModel.patientNumber,
                                     @"realname": self.patientModel.realname,
                                     @"gender" : self.patientModel.gender,
                                     @"age" : self.patientModel.age,
                                     } mutableCopy];
    if (!XJSIsNullObject(self.patientModel.phoneNumber)) {
        if (!XJSIsMobileNumber(self.patientModel.phoneNumber)) {
            XJSShowHud(NO, @"请输入正确的手机号");
            return;
        }
        [params setObject:self.patientModel.phoneNumber forKey:@"phoneNumber"];
    }
    if (!XJSIsNullObject(self.patientModel.remarks)) {
        [params setObject:self.patientModel.remarks forKey:@"remarks"];
    }
    [MBProgressHUD showHUDAddedTo:XJSKeyWindow animated:YES];
    if (self.isModifyInformations) {    //修改用户信息
        [params setObject:self.patientModel.id forKey:@"id"];
        [params setObject:self.patientModel.ts forKey:@"ts"];
        [XJSPatientModel modifyPatientInformations:params handler:^(id object, NSString *msg) {
            [MBProgressHUD hideHUDForView:XJSKeyWindow animated:YES];
            if (object) {
                XJSShowHud(YES, @"修改成功");
                [self.navigationController popViewControllerAnimated:YES];
                if (self.modifyBlock) {
                    self.modifyBlock(self.patientModel);
                }
            } else {
                XJSShowHud(NO, msg);
            }
        }];
    } else {                           //添加用户
        [XJSPatientModel addPatient:params handler:^(id object, NSString *msg) {
            [MBProgressHUD hideHUDForView:XJSKeyWindow animated:YES];
            if (object) {
                XJSShowHud(YES, @"添加成功");
                [self.navigationController popViewControllerAnimated:YES];
                if (self.addBlock) {
                    self.addBlock();
                }
            } else {
                XJSShowHud(NO, msg);
            }
        }];
    }
}
- (void)infoTextFieldEditingChanged:(UITextField *)textField {
    switch (textField.tag) {
        case 10: {
            self.patientModel.patientNumber = textField.text;
        }
            break;
        case 11: {
            self.patientModel.realname = textField.text;
        }
            break;
        case 13: {
            self.patientModel.age = textField.text.length > 0 ? @(textField.text.integerValue) : nil;
        }
            break;
        case 14: {
            self.patientModel.phoneNumber = textField.text;
        }
            break;
        case 15: {
            self.patientModel.remarks = textField.text;
        }
            break;
        default:
            break;
    }
}

#pragma mark - Text field delegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([string isEqualToString:@" "]) {
        return NO;
    }
    if (textField.tag == 13 || textField.tag == 14) {
        NSString *numbers = @"0123456789";
        NSCharacterSet *set = [[NSCharacterSet characterSetWithCharactersInString:numbers] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:set] componentsJoinedByString:@""];
        if (![string isEqualToString:filtered]) {
            return NO;
        } else {
            if (textField.text.length == 0 && [string isEqualToString:@"0"]) {
                return NO;
            }
        }
    }
    return YES;
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 6;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70.f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XJSPatientCommonInfomationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XJSPatientCommonInfomationCell" forIndexPath:indexPath];
    [cell setupContentView:indexPath.row];
    [cell addContentData:self.patientModel index:indexPath.row];
    cell.textField.tag = 10 + indexPath.row;
    [cell.textField addTarget:self action:@selector(infoTextFieldEditingChanged:) forControlEvents:UIControlEventEditingChanged];
    cell.textField.delegate = self;
    return cell;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    XJSPatientCommonInfomationCell *cell = (XJSPatientCommonInfomationCell *)[tableView cellForRowAtIndexPath:indexPath];
    if (indexPath.row == 2) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"选择性别" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *maleAction = [UIAlertAction actionWithTitle:@"男" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            self.patientModel.gender = @(XJSUserGenderMale);
            cell.textField.text = @"男";
        }];
        UIAlertAction *femaleAction = [UIAlertAction actionWithTitle:@"女" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            self.patientModel.gender = @(XJSUserGenderFemale);
            cell.textField.text = @"女";
        }];
        [alert addAction:maleAction];
        [alert addAction:femaleAction];
        UIPopoverPresentationController *popover = alert.popoverPresentationController;
        if (popover) {
            popover.sourceView = cell.contentView;
            popover.sourceRect = cell.contentView.bounds;
            popover.permittedArrowDirections = UIPopoverArrowDirectionUp;
        }
        [self presentViewController:alert animated:YES completion:nil];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Getters
- (XJSPatientModel *)patientModel {
    if (!_patientModel) {
        _patientModel = [[XJSPatientModel alloc] init];
    }
    return _patientModel;
}

@end
