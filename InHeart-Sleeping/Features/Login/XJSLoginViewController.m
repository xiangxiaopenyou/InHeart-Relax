//
//  XJSLoginViewController.m
//  InHeart-Sleeping
//
//  Created by 项小盆友 on 2018/3/20.
//  Copyright © 2018年 项小盆友. All rights reserved.
//

#import "XJSLoginViewController.h"
#import "XJSAgreementViewController.h"
#import "XJSUserModel.h"
#import <TTTAttributedLabel.h>

@interface XJSLoginViewController () <UITextFieldDelegate, TTTAttributedLabelDelegate>
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *centerYConstraintOfContentView;
@property (weak, nonatomic) IBOutlet UIView *contentView;

@property (nonatomic, strong) TTTAttributedLabel *serviceLabel;

@end

@implementation XJSLoginViewController
#pragma mark - View controller life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [self addServiceLabelView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 添加服务协议
- (void)addServiceLabelView {
    NSString *text = @"登录表示同意服务条款";
    self.serviceLabel.text = text;
    [self.serviceLabel addLinkToURL:nil withRange:[self.serviceLabel.text rangeOfString:@"服务条款"]];
    [self.contentView addSubview:self.serviceLabel];
}

#pragma mark - IBAction
- (IBAction)loginAction:(id)sender {
    [self.view endEditing:YES];
    if (XJSIsNullObject(self.usernameTextField.text)) {
        XJSShowHud(NO, @"请输入用户名");
        return;
    }
    if (XJSIsNullObject(self.passwordTextField.text)) {
        XJSShowHud(NO, @"请输入密码");
        return;
    }
    [MBProgressHUD showHUDAddedTo:XJSKeyWindow animated:YES];
    NSDictionary *params = @{@"username" : self.usernameTextField.text,
                             @"password" : self.passwordTextField.text
                             };
    [XJSUserModel login:params handler:^(id object, NSString *msg) {
        [MBProgressHUD hideHUDForView:XJSKeyWindow animated:YES];
        if (object) {
            XJSUserModel *model = (XJSUserModel *)object;
            [[XJSUserManager sharedUserInfo] saveUserInfo:model];
            [[NSNotificationCenter defaultCenter] postNotificationName:XJSLoginStatusDidChange object:@YES];
        } else {
            XJSShowHud(NO, msg);
        }
    }];
}
#pragma mark - Notification
- (void)keyboardWillShow:(NSNotification *)notification {
    self.centerYConstraintOfContentView.constant = - 150;
    [UIView animateWithDuration:0.5 animations:^{
        [self.view layoutIfNeeded];
    }];
    
}
- (void)keyboardWillHide:(NSNotification *)notification {
    self.centerYConstraintOfContentView.constant = - 80;
    [UIView animateWithDuration:0.5 animations:^{
        [self.view layoutIfNeeded];
    }];
}
#pragma mark - Text field delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.usernameTextField) {
        [textField resignFirstResponder];
        [self.passwordTextField becomeFirstResponder];
    } else {
        [textField resignFirstResponder];
    }
    return YES;
}

#pragma mark - TTTAttributedLabelDelegate
- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url {
    XJSAgreementViewController *agreementViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"XJSAgreement"];
    [self presentViewController:agreementViewController animated:YES completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (TTTAttributedLabel *)serviceLabel {
    if (!_serviceLabel) {
        _serviceLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectMake(63, 345, 150, 20)];
        _serviceLabel.font = XJSSystemFont(13);
        _serviceLabel.delegate = self;
        _serviceLabel.enabledTextCheckingTypes = NSTextCheckingTypeLink;
        self.serviceLabel.linkAttributes = @{
                                             (NSString *)kCTForegroundColorAttributeName : (__bridge id)XJSRGBColor(92, 160, 196, 1).CGColor,
                                             (NSString *)kCTUnderlineStyleAttributeName : [NSNumber numberWithInteger:kCTUnderlineStyleNone]
                                             };
        self.serviceLabel.activeLinkAttributes = @{ (NSString *)kCTForegroundColorAttributeName : (__bridge id)[UIColor blackColor].CGColor };
    }
    return _serviceLabel;
}

@end
