//
//  XJSSearchView.h
//  InHeart-Sleeping
//
//  Created by 项小盆友 on 2018/3/26.
//  Copyright © 2018年 项小盆友. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol XJSSearchViewDelegate<NSObject>
- (void)searchViewDidClickCancel;
- (void)searchViewDidClickSearch:(NSString *)keyword;
@end

@interface XJSSearchView : UIView
@property (strong, nonatomic) UITextField *textField;
@property (weak, nonatomic) id<XJSSearchViewDelegate> delegate;
@end
