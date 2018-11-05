//
//  XJSModifyInformationViewController.m
//  InHeart-Sleeping
//
//  Created by 项小盆友 on 2018/3/23.
//  Copyright © 2018年 项小盆友. All rights reserved.
//

#import "XJSModifyInformationViewController.h"

@interface XJSModifyInformationViewController ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel1;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel2;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UITextField *contentTextField1;
@property (weak, nonatomic) IBOutlet UITextField *contentTextField2;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *finishItem;
@property (copy, nonatomic) NSString *oldNameString;
@property (copy, nonatomic) NSString *titleString;

@end

@implementation XJSModifyInformationViewController

#pragma mark - View controller life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    switch (self.informationType) {
        case XJSUserInformationTypeName: {
            _titleString = @"姓名修改";
            self.contentTextField1.hidden = YES;
            self.titleLabel1.text = @"治疗师:";
            self.titleLabel2.text = @"更改为:";
            _oldNameString = [[NSUserDefaults standardUserDefaults] stringForKey:USERREALNAME];
            self.contentLabel.text = _oldNameString;
        }
            break;
        case XJSUserInformationTypePassword: {
            _titleString = @"密码修改";
            self.contentLabel.hidden = YES;
            self.titleLabel1.text = @"新密码:";
            self.titleLabel2.text = @"请确认:";
            self.contentTextField1.secureTextEntry = YES;
            self.contentTextField2.secureTextEntry = YES;
        }
            break;
        default:
            break;
    }
    self.title = _titleString;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Action
- (IBAction)finishAction:(id)sender {
    [self.view endEditing:YES];
    NSDictionary *params = [NSDictionary dictionary];
    if (self.informationType == XJSUserInformationTypeName) {
        params = @{@"name" : self.contentTextField2.text};
    } else {
        if (![self.contentTextField1.text isEqualToString:self.contentTextField2.text]) {
            XJSShowHud(NO, @"两次密码输入不一致");
            return;
        }
        params = @{@"password" : self.contentTextField2.text};
    }
    [MBProgressHUD showHUDAddedTo:XJSKeyWindow animated:YES];
    [XJSUserModel modifyInformation:params handler:^(id object, NSString *msg) {
        [MBProgressHUD hideHUDForView:XJSKeyWindow animated:YES];
        if (object) {
            if (self.informationType == XJSUserInformationTypeName) {
                [[NSUserDefaults standardUserDefaults] setObject:self.contentTextField2.text forKey:USERREALNAME];
            }
            NSString *tipString = [NSString stringWithFormat:@"%@成功", self.titleString];
            XJSShowHud(YES, tipString);
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            XJSShowHud(NO, msg);
        }
    }];
}
- (IBAction)textFieldEditingChanged:(id)sender {
    if (self.informationType == XJSUserInformationTypeName) {
        if ([self.contentTextField2.text isEqualToString:_oldNameString] || XJSIsNullObject(self.contentTextField2.text)) {
            self.finishItem.enabled = NO;
        } else {
            self.finishItem.enabled = YES;
        }
    } else {
        if (XJSIsNullObject(self.contentTextField1.text) ||
            XJSIsNullObject(self.contentTextField2.text) ||
            self.contentTextField1.text.length != self.contentTextField2.text.length) {
            self.finishItem.enabled = NO;
        } else {
            self.finishItem.enabled = YES;
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

@end
