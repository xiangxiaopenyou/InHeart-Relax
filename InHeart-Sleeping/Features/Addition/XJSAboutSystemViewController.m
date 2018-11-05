//
//  XJSAboutSystemViewController.m
//  InHeart-Sleeping
//
//  Created by 项小盆友 on 2018/4/11.
//  Copyright © 2018年 项小盆友. All rights reserved.
//

#import "XJSAboutSystemViewController.h"

@interface XJSAboutSystemViewController ()
@property (weak, nonatomic) IBOutlet UILabel *appVersionLabel;

@end

@implementation XJSAboutSystemViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSString *versionString = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    self.appVersionLabel.text = [NSString stringWithFormat:@"软件版本：v%@", versionString];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
