//
//  XJSSceneCollectionViewCell.h
//  InHeart-Sleeping
//
//  Created by 项小盆友 on 2018/3/26.
//  Copyright © 2018年 项小盆友. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XJSSceneCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *sceneImageView;
@property (weak, nonatomic) IBOutlet UILabel *sceneNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *sceneInstructionsLabel;

@end
