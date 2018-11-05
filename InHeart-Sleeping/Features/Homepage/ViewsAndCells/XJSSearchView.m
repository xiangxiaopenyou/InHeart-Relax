//
//  XJSSearchView.m
//  InHeart-Sleeping
//
//  Created by 项小盆友 on 2018/3/26.
//  Copyright © 2018年 项小盆友. All rights reserved.
//

#import "XJSSearchView.h"
@interface XJSSearchView () <UITextFieldDelegate>
@property (strong, nonatomic) UIView *viewOfContent;
@property (strong, nonatomic) UIButton *cancelButton;
@property (strong, nonatomic) UIImageView *iconImageView;
@end

@implementation XJSSearchView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self addSubview:self.viewOfContent];
        [self addSubview:self.cancelButton];
        [self.viewOfContent addSubview:self.iconImageView];
        [self.viewOfContent addSubview:self.textField];
    }
    return self;
}

- (void)cancelAction {
    self.textField.text = nil;
    [self.textField resignFirstResponder];
    if (self.delegate && [self.delegate respondsToSelector:@selector(searchViewDidClickCancel)]) {
        [self.delegate searchViewDidClickCancel];
    }
}

#pragma mark - Text field delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (self.delegate && [self.delegate respondsToSelector:@selector(searchViewDidClickSearch:)]) {
        [textField resignFirstResponder];
        [self.delegate searchViewDidClickSearch:textField.text];
    }
    return YES;
}

#pragma mark - Getters
- (UIView *)viewOfContent {
    if (!_viewOfContent) {
        _viewOfContent = [[UIView alloc] initWithFrame:CGRectMake(60, 6, 284, 32)];
        _viewOfContent.layer.masksToBounds = YES;
        _viewOfContent.layer.cornerRadius = 16.f;
        _viewOfContent.layer.borderWidth = 0.5;
        _viewOfContent.layer.borderColor = XJSHexRGBColorWithAlpha(0x999999, 1).CGColor;
        
    }
    return _viewOfContent;
}
- (UIButton *)cancelButton {
    if (!_cancelButton) {
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelButton.frame = CGRectMake(340, 0, 60, 44);
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelButton setTitleColor:XJSHexRGBColorWithAlpha(0x999999, 1) forState:UIControlStateNormal];
        _cancelButton.titleLabel.font = XJSSystemFont(14);
        [_cancelButton addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelButton;
}
- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 8.5, 15, 15)];
        _iconImageView.image = [UIImage imageNamed:@"search_icon"];
    }
    return _iconImageView;
}
- (UITextField *)textField {
    if (!_textField) {
        _textField = [[UITextField alloc] initWithFrame:CGRectMake(25, 0, 255, 32)];
        _textField.textColor = XJSHexRGBColorWithAlpha(0x666666, 1);
        _textField.placeholder = @"病案号/姓名/手机号";
        _textField.font = XJSSystemFont(12);
        _textField.returnKeyType = UIReturnKeySearch;
        _textField.enablesReturnKeyAutomatically = YES;
        _textField.delegate = self;
    }
    return _textField;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
 */

@end
