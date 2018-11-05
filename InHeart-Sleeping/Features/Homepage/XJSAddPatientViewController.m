//
//  XJSAddPatientViewController.m
//  InHeart-Sleeping
//
//  Created by 项小盆友 on 2018/3/22.
//  Copyright © 2018年 项小盆友. All rights reserved.
//

#import "XJSAddPatientViewController.h"
#import "XJSPatientCommonInfomationCell.h"


@interface XJSAddPatientViewController () <UITableViewDelegate, UITableViewDataSource, XJSPatientCommonInfomationCellDelegate, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITableView *leftTableView;
@property (weak, nonatomic) IBOutlet UITableView *rightTableView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *rightItem;

@end

@implementation XJSAddPatientViewController
#pragma mark - View controller life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (self.isModifyInformations) {
        self.title = @"修改患者信息";
        self.rightItem.title = @"修改";
    }
    if (!self.patientModel.maritalStatus) {
        self.patientModel.maritalStatus = @(XJSMaritalStatusNone);
    }
    if (!self.patientModel.educationDegree) {
        self.patientModel.educationDegree = @(XJSEducationDegreeNone);
    }
    if (!self.patientModel.enterTime) {
        NSDate *currentDate = [NSDate date];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSString *dateString = [dateFormatter stringFromDate:currentDate];
        self.patientModel.enterTime = dateString;
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
        XJSShowHud(NO, @"请输入病案号");
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
    if (XJSIsNullObject(self.patientModel.symptoms)) {
        XJSShowHud(NO, @"请输入症状");
        return;
    }
    NSString *timeString = self.patientModel.enterTime;
    if (timeString.length == 10) {
        timeString = [timeString stringByAppendingString:@" 00:00:00"];
    }
    NSMutableDictionary *params = [@{@"patientNumber" : self.patientModel.patientNumber,
                                     @"realname": self.patientModel.realname,
                                     @"gender" : self.patientModel.gender,
                                     @"age" : self.patientModel.age,
                                     @"symptoms" : self.patientModel.symptoms,
                                     @"maritalStatus" : self.patientModel.maritalStatus,
                                     @"educationDegree" : self.patientModel.educationDegree,
                                     @"enterTime" : timeString
                                     } mutableCopy];
    if (!XJSIsNullObject(self.patientModel.medicareNumber)) {
        [params setObject:self.patientModel.medicareNumber forKey:@"medicareNumber"];
    }
    if (!XJSIsNullObject(self.patientModel.identificationNumber)) {
        [params setObject:self.patientModel.identificationNumber forKey:@"identificationNumber"];
    }
    if (!XJSIsNullObject(self.patientModel.phoneNumber)) {
        if (!XJSIsMobileNumber(self.patientModel.phoneNumber)) {
            XJSShowHud(NO, @"请输入正确的手机号");
            return;
        }
        [params setObject:self.patientModel.phoneNumber forKey:@"phoneNumber"];
    }
    if (!XJSIsNullObject(self.patientModel.address)) {
        [params setObject:self.patientModel.address forKey:@"address"];
    }
    [MBProgressHUD showHUDAddedTo:XJSKeyWindow animated:YES];
    if (self.isModifyInformations) {    //修改患者信息
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
    } else {                           //添加患者
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
            self.patientModel.medicareNumber = textField.text;
        }
            break;
        case 15: {
            self.patientModel.identificationNumber = textField.text;
        }
            break;
        case 20: {
            self.patientModel.symptoms = textField.text;
        }
            break;
        case 23: {
            self.patientModel.phoneNumber = textField.text;
        }
            break;
        case 25: {
            self.patientModel.address = textField.text;
        }
            break;
        default:
            break;
    }
}
#pragma mark - Patient common infomation cell delegate
- (void)dateDidChange:(NSString *)dateString {
    self.patientModel.enterTime = dateString;
    UITextField *dateTextField = (UITextField *)[self.rightTableView viewWithTag:24];
    dateTextField.text = dateString;
}

#pragma mark - Text field delegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([string isEqualToString:@" "]) {
        return NO;
    }
    if (textField.tag == 13) {
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
    if (tableView == self.leftTableView) {
        [cell setupContentView:1 index:indexPath.row];
        [cell addContentData:self.patientModel tableType:1 index:indexPath.row];
        cell.textField.tag = 10 + indexPath.row;
    } else {
        [cell setupContentView:2 index:indexPath.row];
        [cell addContentData:self.patientModel tableType:2 index:indexPath.row];
        cell.textField.tag = 20 + indexPath.row;
    }
    [cell.textField addTarget:self action:@selector(infoTextFieldEditingChanged:) forControlEvents:UIControlEventEditingChanged];
    cell.textField.delegate = self;
    cell.delegate = self;
    return cell;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    XJSPatientCommonInfomationCell *cell = (XJSPatientCommonInfomationCell *)[tableView cellForRowAtIndexPath:indexPath];
    if (tableView == self.leftTableView) {
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
    } else {
        if (indexPath.row == 1) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"选择婚姻状况" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
            UIAlertAction *destructiveAction = [UIAlertAction actionWithTitle:@"保密" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                self.patientModel.maritalStatus = @(XJSMaritalStatusNone);
                cell.textField.text = @"保密";
            }];
            UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"未婚" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                self.patientModel.maritalStatus = @(XJSMaritalStatusNot);
                cell.textField.text = @"未婚";
            }];
            UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"已婚" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                self.patientModel.maritalStatus = @(XJSMaritalStatusMarried);
                cell.textField.text = @"已婚";
            }];
            [alert addAction:destructiveAction];
            [alert addAction:action1];
            [alert addAction:action2];
            UIPopoverPresentationController *popover = alert.popoverPresentationController;
            if (popover) {
                popover.sourceView = cell.contentView;
                popover.sourceRect = cell.contentView.bounds;
                popover.permittedArrowDirections = UIPopoverArrowDirectionUp;
            }
            [self presentViewController:alert animated:YES completion:nil];
        } else if (indexPath.row == 2) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"选择文化程度" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
            NSString *actionTitle = nil;
            for (NSInteger i = 0; i < 11; i ++) {
                switch (i) {
                    case 0: {
                        actionTitle = @"保密";
                    }
                        break;
                    case 1: {
                        actionTitle = @"博士";
                    }
                        break;
                    case 2: {
                        actionTitle = @"硕士";
                    }
                        break;
                    case 3: {
                        actionTitle = @"本科";
                    }
                        break;
                    case 4: {
                        actionTitle = @"大专";
                    }
                        break;
                    case 5: {
                        actionTitle = @"中专和中技";
                    }
                        break;
                    case 6: {
                        actionTitle = @"技工学校";
                    }
                        break;
                    case 7: {
                        actionTitle = @"高中";
                    }
                        break;
                    case 8: {
                        actionTitle = @"初中";
                    }
                        break;
                    case 9: {
                        actionTitle = @"小学";
                    }
                        break;
                    case 10: {
                        actionTitle = @"文盲与半文盲";
                    }
                        break;
                        
                    default:
                        break;
                }
                if (i == 0) {
                    UIAlertAction *destructiveAction = [UIAlertAction actionWithTitle:actionTitle style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                        self.patientModel.educationDegree = @(XJSEducationDegreeNone);
                        cell.textField.text = @"保密";
                    }];
                    [alert addAction:destructiveAction];
                } else {
                    UIAlertAction *action = [UIAlertAction actionWithTitle:actionTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        switch (i) {
                            case 1: {
                                self.patientModel.educationDegree = @(XJSEducationDegreeFirst);
                                cell.textField.text = @"博士";
                            }
                                break;
                            case 2: {
                                self.patientModel.educationDegree = @(XJSEducationDegreeSecond);
                                cell.textField.text = @"硕士";
                            }
                                break;
                            case 3: {
                                self.patientModel.educationDegree = @(XJSEducationDegreeThird);
                                cell.textField.text = @"本科";
                            }
                                break;
                            case 4: {
                                self.patientModel.educationDegree = @(XJSEducationDegreeForth);
                                cell.textField.text = @"大专";
                            }
                                break;
                            case 5: {
                                self.patientModel.educationDegree = @(XJSEducationDegreeFifth);
                                cell.textField.text = @"中专和中技";
                            }
                                break;
                            case 6: {
                                self.patientModel.educationDegree = @(XJSEducationDegreeSixth);
                                cell.textField.text = @"技工学校";
                            }
                                break;
                            case 7: {
                                self.patientModel.educationDegree = @(XJSEducationDegreeSeventh);
                                cell.textField.text = @"高中";
                            }
                                break;
                            case 8: {
                                self.patientModel.educationDegree = @(XJSEducationDegreeEighth);
                                cell.textField.text = @"初中";
                            }
                                break;
                            case 9: {
                                self.patientModel.educationDegree = @(XJSEducationDegreeNinth);
                                cell.textField.text = @"小学";
                            }
                                break;
                            case 10: {
                                self.patientModel.educationDegree = @(XJSEducationDegreeTenth);
                                cell.textField.text = @"文盲与半文盲";
                            }
                                break;
                                
                            default:
                                break;
                        }
                    }];
                    [alert addAction:action];
                }
                
            }
            UIPopoverPresentationController *popover = alert.popoverPresentationController;
            if (popover) {
                popover.sourceView = cell.contentView;
                popover.sourceRect = cell.contentView.bounds;
                popover.permittedArrowDirections = UIPopoverArrowDirectionUp;
            }
            [self presentViewController:alert animated:YES completion:nil];
        }
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
