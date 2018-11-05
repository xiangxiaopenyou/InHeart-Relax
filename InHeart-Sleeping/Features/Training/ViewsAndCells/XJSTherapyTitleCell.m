//
//  XJSTherapyTitleCell.m
//  InHeart-Sleeping
//
//  Created by 项小盆友 on 2018/3/26.
//  Copyright © 2018年 项小盆友. All rights reserved.
//

#import "XJSTherapyTitleCell.h"

@implementation XJSTherapyTitleCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.nameLabel];
        [self.contentView addSubview:self.pointImageView];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    if (selected) {
        self.nameLabel.textColor = XJSHexRGBColorWithAlpha(0x3f5c7a, 1);
        self.pointImageView.hidden = NO;
    } else {
        self.nameLabel.textColor = XJSHexRGBColorWithAlpha(0x999999, 1);
        self.pointImageView.hidden = YES;
    }
}

#pragma mark - Getters
- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = [UIFont systemFontOfSize:13];
        _nameLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _nameLabel;
}
- (UIImageView *)pointImageView {
    if (!_pointImageView) {
        _pointImageView = [[UIImageView alloc] init];
        _pointImageView.image = [UIImage imageNamed:@"therapy_choose"];
    }
    return _pointImageView;
}
@end
