//
//  XJSPatientCommonInfomationCell.h
//  InHeart-Sleeping
//
//  Created by 项小盆友 on 2018/3/22.
//  Copyright © 2018年 项小盆友. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XJSPatientModel;

@protocol XJSPatientCommonInfomationCellDelegate<NSObject>
- (void)dateDidChange:(NSString *)dateString;
@end

@interface XJSPatientCommonInfomationCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *itemNameLabel;
@property (weak, nonatomic) IBOutlet UIView *viewOfInput;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIImageView *tipImageView;
@property (weak, nonatomic) IBOutlet UIImageView *asteriskImageView;
@property (weak, nonatomic) id<XJSPatientCommonInfomationCellDelegate> delegate;

- (void)setupContentView:(NSInteger)tableViewType index:(NSInteger)cellIndex;
- (void)addContentData:(XJSPatientModel *)model tableType:(NSInteger)tableViewType index:(NSInteger)cellIndex;

@end
