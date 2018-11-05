//
//  XJSSearchPatientsViewController.m
//  InHeart-Sleeping
//
//  Created by 项小盆友 on 2018/3/26.
//  Copyright © 2018年 项小盆友. All rights reserved.
//

#import "XJSSearchPatientsViewController.h"
#import "XJSPatientDetailViewController.h"
#import "XJSTrainingCenterViewController.h"
#import "XJSTrainingRecordsViewController.h"

#import "XJSSearchView.h"
#import "XJSPatientInfomationCollectionViewCell.h"

#import "XJSPatientModel.h"

#define kXJSPatientInfoCellWidth (XJSScreenWidth - 80.f) / 5.f
#define kXJSPatientInfoCellHeight kXJSPatientInfoCellWidth * 23.f / 20.f

@interface XJSSearchPatientsViewController () <XJSSearchViewDelegate, XJSPatientInfomationCellDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UICollectionView *resultCollectionView;
@property (strong, nonatomic) XJSSearchView *searchView;

@property (strong, nonatomic) NSMutableArray *resultArray;

@end

@implementation XJSSearchPatientsViewController
#pragma mark - View controller life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.titleView = self.searchView;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] init];
    
    [self.searchView.textField becomeFirstResponder];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(patientDidDelete:) name:XJSPatientDidDelete object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(patientInformationsDidModify:) name:XJSPatientInformationsDidModify object:nil];
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:XJSPatientDidDelete object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:XJSPatientInformationsDidModify object:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Request
- (void)searchRequest:(NSString *)keywords {
    [MBProgressHUD showHUDAddedTo:XJSKeyWindow animated:YES];
    [XJSPatientModel patientsList:keywords page:@1 handler:^(id object, NSString *msg) {
        [MBProgressHUD hideHUDForView:XJSKeyWindow animated:YES];
        if (object) {
            self.resultArray = [(NSArray *)object mutableCopy];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.resultCollectionView reloadData];
                if (self.resultArray.count == 0) {
                    XJSShowHud(NO, @"无搜索结果");
                }
            });
        } else {
            XJSShowHud(NO, msg);
        }
    }];
}

#pragma mark - Notification
- (void)patientDidDelete:(NSNotification *)notification {
    XJSPatientModel *tempModel = (XJSPatientModel *)notification.object;
    NSArray *tempArray = [self.resultArray copy];
    [tempArray enumerateObjectsUsingBlock:^(XJSPatientModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.id isEqualToString:tempModel.id]) {
            [self.resultArray removeObjectAtIndex:idx];
            [self.resultCollectionView deleteItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:idx inSection:0]]];
        }
    }];
    
}
- (void)patientInformationsDidModify:(NSNotification *)notification {
    XJSPatientModel *tempModel = (XJSPatientModel *)notification.object;
    NSArray *tempArray = [self.resultArray copy];
    [tempArray enumerateObjectsUsingBlock:^(XJSPatientModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.id isEqualToString:tempModel.id]) {
            [self.resultArray replaceObjectAtIndex:idx withObject:tempModel];
            [self.resultCollectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:idx inSection:0]]];
        }
    }];
}

#pragma mark - Search view delegate
- (void)searchViewDidClickCancel {
    [self.navigationController popViewControllerAnimated:NO];
}
- (void)searchViewDidClickSearch:(NSString *)keyword {
    if (keyword) {
        [self searchRequest:keyword];
    }
}

#pragma mark - Patient infomation cell delegate
- (void)didClickTraining:(XJSPatientModel *)model {
    XJSTrainingCenterViewController *trainingCenterController = [[UIStoryboard storyboardWithName:@"Training" bundle:nil] instantiateViewControllerWithIdentifier:@"XJSTrainingCenter"];
    trainingCenterController.patientModel = model;
    [self.navigationController pushViewController:trainingCenterController animated:YES];
}
- (void)didClickRecord:(XJSPatientModel *)model {
    XJSTrainingRecordsViewController *recordsController = [[UIStoryboard storyboardWithName:@"Training" bundle:nil] instantiateViewControllerWithIdentifier:@"XJSTrainingRecords"];
    recordsController.patientModel = model;
    [self.navigationController pushViewController:recordsController animated:YES];
}

#pragma mark - Collection view data source
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _resultArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    XJSPatientInfomationCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"XJSPatientInfomationCollectionCell" forIndexPath:indexPath];
    cell.delegate = self;
    XJSPatientModel *patientModel = self.resultArray[indexPath.row];
    cell.patientModel = patientModel;
    cell.nameLabel.text = patientModel.realname;
    cell.avatarImageView.image = patientModel.gender.integerValue == 1 ? [UIImage imageNamed:@"head_boy"] : [UIImage imageNamed:@"head_girl"];
    cell.patientNumberLabel.text = patientModel.patientNumber;
    cell.ageLabel.text = [NSString stringWithFormat:@"%@岁", patientModel.age];
    cell.diseaseLabel.text = patientModel.symptoms;
    return cell;
}
#pragma mark - Collection view delegate flow layout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return (CGSize){kXJSPatientInfoCellWidth, kXJSPatientInfoCellHeight};
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    //return (UIEdgeInsets){18, 18, 18, 18};
    return UIEdgeInsetsMake(20, 20, 20, 20);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 18.f;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 10.f;
}
#pragma mark - Collection view delegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    XJSPatientModel *model = self.resultArray[indexPath.row];
    XJSPatientDetailViewController *detailController = [self.storyboard instantiateViewControllerWithIdentifier:@"XJSPatientDetail"];
    detailController.patientModel = model;
    [self.navigationController pushViewController:detailController animated:YES];
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
- (XJSSearchView *)searchView {
    if (!_searchView) {
        _searchView = [[XJSSearchView alloc] initWithFrame:CGRectMake(0, 0, 415, 44)];
        _searchView.delegate = self;
    }
    return _searchView;
}
- (NSMutableArray *)resultArray {
    if (!_resultArray) {
        _resultArray = [[NSMutableArray alloc] init];
    }
    return _resultArray;
}

@end
