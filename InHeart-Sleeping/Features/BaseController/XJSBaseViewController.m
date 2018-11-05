//
//  XJSBaseViewController.m
//  InHeart-Sleeping
//
//  Created by 项小盆友 on 2018/3/28.
//  Copyright © 2018年 项小盆友. All rights reserved.
//

#import "XJSBaseViewController.h"
#import "XJSModifyInformationViewController.h"
#import "XJSAboutSystemViewController.h"

#import "ZWPullMenuView.h"
#import "XLAlertControllerObject.h"

@interface XJSBaseViewController ()
@property (nonatomic, strong) UIImageView *arrowImageView;

@end

@implementation XJSBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIBarButtonItem *userItem = [[UIBarButtonItem alloc] initWithCustomView:self.userButton];
    UIBarButtonItem *moreItem = [[UIBarButtonItem alloc] initWithCustomView:self.moreButton];
    self.navigationItem.rightBarButtonItems = @[moreItem, userItem];
}
- (void)viewWillAppear:(BOOL)animated {
    NSString *nameString = [[NSUserDefaults standardUserDefaults] stringForKey:USERREALNAME];
    CGSize nameSize = [nameString sizeWithAttributes:@{NSFontAttributeName : XJSSystemFont(16)}];
    [self.userButton setTitle:nameString forState:UIControlStateNormal];
    self.userButton.frame = CGRectMake(0, 0, nameSize.width + 40.f, 44.f);
    self.arrowImageView.frame = CGRectMake(nameSize.width + 25, 0, 10, 44);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Action
- (void)userAction {
    NSArray *titlesArray = @[@"姓名修改", @"密码修改"/*, @"手机号修改"*/];
    NSArray *imagesArray = @[@"setting_name", @"setting_password"/*, @"setting_phone"*/];
    ZWPullMenuView *menuView = [ZWPullMenuView pullMenuAnchorView:self.userButton titleArray:titlesArray imageArray:imagesArray];
    menuView.zwPullMenuStyle = PullMenuLightStyle;
    menuView.blockSelectedMenu = ^(NSInteger menuRow) {
        XJSModifyInformationViewController *modifyInformationController = [[UIStoryboard storyboardWithName:@"Homepage" bundle:nil] instantiateViewControllerWithIdentifier:@"XJSModifyInformation"];
        modifyInformationController.informationType = menuRow;
        [self.navigationController pushViewController:modifyInformationController animated:YES];
    };
}
- (void)moreAction {
    NSArray *titlesArray = @[@"注销", /*@"清理缓存",*/ @"关于系统"];
    NSArray *imagesArray = @[@"system_logout", /*@"system_clean",*/ @"system_about"];
    ZWPullMenuView *menuView = [ZWPullMenuView pullMenuAnchorView:self.moreButton titleArray:titlesArray imageArray:imagesArray];
    menuView.zwPullMenuStyle = PullMenuLightStyle;
    menuView.blockSelectedMenu = ^(NSInteger menuRow) {
        switch (menuRow) {
            case 0: {
                [XLAlertControllerObject showWithTitle:@"确定要注销吗？" message:nil cancelTitle:@"取消" ensureTitle:@"注销" ensureBlock:^{
                    [[XJSUserManager sharedUserInfo] removeUserInfo];
                    [[NSNotificationCenter defaultCenter] postNotificationName:XJSLoginStatusDidChange object:@NO];
                }];
            }
                break;
            case 1: {
                XJSAboutSystemViewController *aboutController = [[UIStoryboard storyboardWithName:@"Addition" bundle:nil] instantiateViewControllerWithIdentifier:@"XJSAboutSystem"];
                [self.navigationController pushViewController:aboutController animated:YES];
            }
                break;
            default:
                break;
        }
    };
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
- (UIButton *)userButton {
    if (!_userButton) {
        _userButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_userButton setTitleColor:XJSHexRGBColorWithAlpha(0x666666, 1) forState:UIControlStateNormal];
        _userButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [_userButton addSubview:self.arrowImageView];
        [_userButton addTarget:self action:@selector(userAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _userButton;
}
- (UIButton *)moreButton {
    if (!_moreButton) {
        _moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _moreButton.frame = CGRectMake(0, 0, 40, 40);
        [_moreButton setImage:[UIImage imageNamed:@"navigation_more"] forState:UIControlStateNormal];
        [_moreButton addTarget:self action:@selector(moreAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _moreButton;
}
- (UIImageView *)arrowImageView {
    if (!_arrowImageView) {
        _arrowImageView = [[UIImageView alloc] init];
        _arrowImageView.image = [UIImage imageNamed:@"navigation_arrow_down"];
    }
    return _arrowImageView;
}

@end
