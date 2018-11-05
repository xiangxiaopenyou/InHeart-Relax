//
//  XJSAgreementViewController.m
//  InHeart-Sleeping
//
//  Created by 项小盆友 on 2018/7/25.
//  Copyright © 2018年 项小盆友. All rights reserved.
//

#import "XJSAgreementViewController.h"

@interface XJSAgreementViewController ()
@property (weak, nonatomic) IBOutlet UIView *agreementView;

@end

@implementation XJSAgreementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.agreementView.layer.masksToBounds = YES;
    self.agreementView.layer.cornerRadius = 10.f;
    self.agreementView.layer.borderWidth = 0.5;
    self.agreementView.layer.borderColor = XJSHexRGBColorWithAlpha(0x999999, 1).CGColor;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)closeAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
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
