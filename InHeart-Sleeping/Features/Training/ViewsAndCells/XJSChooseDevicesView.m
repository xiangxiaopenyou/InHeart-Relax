//
//  XJSChooseDevicesView.m
//  InHeart-Sleeping
//
//  Created by 项小盆友 on 2018/4/2.
//  Copyright © 2018年 项小盆友. All rights reserved.
//

#import "XJSChooseDevicesView.h"
#import "XJSDeviceModel.h"

#import <Masonry.h>

@interface XJSChooseDevicesView () <UITableViewDelegate, UITableViewDataSource>
@property (copy, nonatomic) NSArray *devicesArray;
@property (strong, nonatomic) XJSDeviceModel *selectedModel;
@property (strong, nonatomic) UIView *contentView;
@property (strong, nonatomic) UIButton *cancelButton;
@property (strong, nonatomic) UIButton *comfirmButton;
@property (strong, nonatomic) UIView *selectView;
@property (strong, nonatomic) UIButton *selectButton;
@property (strong, nonatomic) UILabel *selectLabel;
@property (strong, nonatomic) UIImageView *selectImageView;
@property (strong, nonatomic) UITableView *tableView;
@end

@implementation XJSChooseDevicesView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0.4 alpha:0.5];
        //self.devicesArray = [deviceArray copy];
        [self createContentView];
    }
    return self;
}

#pragma mark - methods
- (void)createContentView {
    [self addSubview:self.contentView];
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"移动播放设备";
    titleLabel.font = XJSSystemFont(18);
    titleLabel.textColor = XJSHexRGBColorWithAlpha(0x333333, 1);
    [self.contentView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).with.mas_offset(45);
        make.centerX.equalTo(self.contentView);
    }];
    
    [self.contentView addSubview:self.cancelButton];
    [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_offset(CGSizeMake(72, 38));
        make.centerX.equalTo(self.contentView).with.mas_offset(- 50);
        make.bottom.equalTo(self.contentView.mas_bottom).with.mas_offset(- 50);
    }];
    
    [self.contentView addSubview:self.comfirmButton];
    [self.comfirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_offset(CGSizeMake(72, 38));
        make.centerX.equalTo(self.contentView).with.mas_offset(50);
        make.bottom.equalTo(self.contentView.mas_bottom).with.mas_offset(- 50);
    }];
    
    [self.contentView addSubview:self.selectView];
    [self.selectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.centerY.equalTo(self.contentView).with.mas_offset(- 20);
        make.size.mas_offset(CGSizeMake(151, 32));
    }];
    
    [self.selectView addSubview:self.selectLabel];
    [self.selectLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.selectView.mas_leading).with.mas_offset(5);
        make.centerY.equalTo(self.selectView);
    }];
    
    [self.selectView addSubview:self.selectImageView];
    [self.selectImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.selectView.mas_trailing).with.mas_offset(- 10);
        make.centerY.equalTo(self.selectView);
        make.size.mas_offset(CGSizeMake(12, 10));
    }];
    
    [self.selectView addSubview:self.selectButton];
    [self.selectButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_offset(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    [self.contentView addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.selectView.mas_bottom);
        make.centerX.equalTo(self.contentView);
        make.width.mas_offset(151);
        make.height.mas_offset(0);
    }];
}

- (void)show {
    self.alpha = 1.f;
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    CAKeyframeAnimation *popAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    popAnimation.duration = 0.4;
    popAnimation.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.01f, 0.01f, 1.0f)],
                            [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1f, 1.1f, 1.0f)],
                            [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9f, 0.9f, 1.0f)],
                            [NSValue valueWithCATransform3D:CATransform3DIdentity]];
    popAnimation.keyTimes = @[@0.2f, @0.5f, @0.75f, @1.0f];
    popAnimation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                     [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                     [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                     [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [self.contentView.layer addAnimation:popAnimation forKey:nil];
}
- (void)dismiss {
    [UIView animateWithDuration:0.4 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    CAKeyframeAnimation *hideAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    hideAnimation.duration = 0.4;
    hideAnimation.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1f, 1.1f, 1.0f)],
                             [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0f, 1.0f, 1.0f)],
                             [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.00f, 0.00f, 0.00f)]];
    hideAnimation.keyTimes = @[@0.2f, @0.5f, @0.75f];
    hideAnimation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                      [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                      [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [self.contentView.layer addAnimation:hideAnimation forKey:nil];
}
- (void)setupContentData:(NSArray *)deviceArray device:(XJSDeviceModel *)deviceModel {
    if (deviceArray) {
        self.devicesArray = [deviceArray copy];
        [self.tableView reloadData];
    }
    if (deviceModel) {
        self.selectedModel = deviceModel;
        self.selectLabel.text = self.selectedModel.deviceName;
    }
}

#pragma mark - Action
//- (void)backgroundTap {
//    if (self.selectButton.selected) {
//        [self selectAction];
//    }
//    [self dismiss];
//}
- (void)cancelAction {
    [self dismiss];
}
- (void)comfirmAction {
    if (self.comfirmBlock) {
        self.comfirmBlock(_selectedModel);
    }
    [self dismiss];
}
- (void)selectAction {
    if (self.selectButton.selected) {
        self.selectButton.selected = NO;
        [UIView animateWithDuration:0.2 animations:^{
            [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_offset(0);
            }];
            [self layoutIfNeeded];
        }];
    } else {
        self.selectButton.selected = YES;
        [UIView animateWithDuration:0.2 animations:^{
            [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
                CGFloat height = self.devicesArray.count >= 3 ? 120.f : self.devicesArray.count * 40.f;
                make.height.mas_offset(height);
            }];
            [self layoutIfNeeded];
        }];
        
    }
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.devicesArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40.f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.backgroundColor = [UIColor clearColor];
    XJSDeviceModel *deviceModel = self.devicesArray[indexPath.row];
    cell.textLabel.font = XJSSystemFont(14);
    cell.textLabel.textColor = XJSHexRGBColorWithAlpha(0x666666, 1);
    cell.textLabel.text = deviceModel.deviceName;
    return cell;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    XJSDeviceModel *deviceModel = self.devicesArray[indexPath.row];
    self.selectedModel = deviceModel;
    self.selectLabel.text = self.selectedModel.deviceName;
    [self selectAction];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
#pragma mark - Getters
- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(XJSScreenWidth * 0.5 - 155, XJSScreenHeight * 0.5 - 160, 310, 244)];
        _contentView.layer.masksToBounds = YES;
        _contentView.layer.cornerRadius = 13.f;
        _contentView.backgroundColor = [UIColor whiteColor];
    }
    return _contentView;
}
- (UIButton *)cancelButton {
    if (!_cancelButton) {
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelButton setTitleColor:XJSHexRGBColorWithAlpha(0x999999, 1) forState:UIControlStateNormal];
        _cancelButton.titleLabel.font = XJSSystemFont(14);
        _cancelButton.layer.masksToBounds = YES;
        _cancelButton.layer.cornerRadius = 14.f;
        _cancelButton.layer.borderWidth = 1;
        _cancelButton.layer.borderColor = XJSHexRGBColorWithAlpha(0xc9c9c9, 1).CGColor;
        [_cancelButton addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelButton;
}
- (UIButton *)comfirmButton {
    if (!_comfirmButton) {
        _comfirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_comfirmButton setTitle:@"确定" forState:UIControlStateNormal];
        [_comfirmButton setTitleColor:XJSHexRGBColorWithAlpha(0x55c06f, 1) forState:UIControlStateNormal];
        _comfirmButton.titleLabel.font = XJSSystemFont(14);
        _comfirmButton.layer.masksToBounds = YES;
        _comfirmButton.layer.cornerRadius = 14.f;
        _comfirmButton.layer.borderWidth = 1;
        _comfirmButton.layer.borderColor = XJSHexRGBColorWithAlpha(0x55c06f, 1).CGColor;
        [_comfirmButton addTarget:self action:@selector(comfirmAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _comfirmButton;
}
- (UIView *)selectView {
    if (!_selectView) {
        _selectView = [[UIView alloc] init];
        _selectView.layer.masksToBounds = YES;
        _selectView.layer.cornerRadius = 8.f;
        _selectView.layer.borderWidth = 1;
        _selectView.layer.borderColor = XJSHexRGBColorWithAlpha(0xd0d0d0, 1).CGColor;
    }
    return _selectView;
}
- (UILabel *)selectLabel {
    if (!_selectLabel) {
        _selectLabel = [[UILabel alloc] init];
        _selectLabel.font = XJSSystemFont(14);
        _selectLabel.textColor = XJSHexRGBColorWithAlpha(0x666666, 1);
    }
    return _selectLabel;
}
- (UIImageView *)selectImageView {
    if (!_selectImageView) {
        _selectImageView = [[UIImageView alloc] init];
        _selectImageView.image = [UIImage imageNamed:@"equipment_pulldown"];
    }
    return _selectImageView;
}
- (UIButton *)selectButton {
    if (!_selectButton) {
        _selectButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_selectButton addTarget:self action:@selector(selectAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _selectButton;
}
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.9];
        _tableView.layer.masksToBounds = YES;
        _tableView.layer.cornerRadius = 8.f;
        _tableView.tableFooterView = [UIView new];
        //_tableView.bounces = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

@end
