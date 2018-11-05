//
//  XJSPatientsManagementViewController.m
//  InHeart-Sleeping
//
//  Created by 项小盆友 on 2018/3/21.
//  Copyright © 2018年 项小盆友. All rights reserved.
//

#import "XJSPatientsManagementViewController.h"
#import "XJSAddPatientViewController.h"
#import "XJSTrainingCenterViewController.h"
#import "XJSSearchPatientsViewController.h"
#import "XJSPatientDetailViewController.h"
#import "XJSTrainingRecordsViewController.h"

#import "XJSPatientInfomationCollectionViewCell.h"

#import "XJSPatientModel.h"

#import <MJRefresh.h>

#define kXJSPatientInfoCellWidth (XJSScreenWidth - 80.f) / 5.f
#define kXJSPatientInfoCellHeight kXJSPatientInfoCellWidth * 23.f / 20.f

@interface XJSPatientsManagementViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, XJSPatientInfomationCellDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) UIButton *searchButton;
@property (nonatomic, strong) UIButton *addButton;
@property (strong, nonatomic) UILabel *emptyLabel;

@property (nonatomic) NSInteger paging;
@property (strong, nonatomic) NSMutableArray *patientsArray;
@end

@implementation XJSPatientsManagementViewController
#pragma mark - View controller life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIBarButtonItem *searchItem = [[UIBarButtonItem alloc] initWithCustomView:self.searchButton];
    UIBarButtonItem *addItem = [[UIBarButtonItem alloc] initWithCustomView:self.addButton];
    self.navigationItem.leftBarButtonItems = @[searchItem, addItem];
    
    //collection footer view
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FooterView"];
    
    [MBProgressHUD showHUDAddedTo:XJSKeyWindow animated:YES];
    _paging = 1;
    [self fetchPatientsList];
    
    [self addRefreshView];
    
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

#pragma mark - Private methods
- (void)addRefreshView {
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.paging = 1;
        [self fetchPatientsList];
    }];
    header.stateLabel.hidden = YES;
    header.lastUpdatedTimeLabel.hidden = YES;
    self.collectionView.mj_header = header;
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self fetchPatientsList];
    }];
    footer.stateLabel.hidden = YES;
    self.collectionView.mj_footer = footer;
}

#pragma mark - Requests
- (void)fetchPatientsList {
    [XJSPatientModel patientsList:nil page:@(_paging) handler:^(id object, NSString *msg) {
        [MBProgressHUD hideHUDForView:XJSKeyWindow animated:YES];
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView.mj_footer endRefreshing];
        if (object) {
            NSArray *resultArray = [(NSArray *)object copy];
            if (self.paging == 1) {
                self.patientsArray = [resultArray mutableCopy];
            } else {
                NSMutableArray *tempArray = [self.patientsArray mutableCopy];
                [tempArray addObjectsFromArray:resultArray];
                self.patientsArray = [tempArray mutableCopy];
            }
            if (resultArray.count < 20) {
                self.collectionView.mj_footer.hidden = YES;
                [self.collectionView.mj_footer endRefreshingWithNoMoreData];
            } else {
                self.collectionView.mj_footer.hidden = NO;
                self.paging += 1;
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                self.emptyLabel.text = self.patientsArray.count > 0 ? nil : @"暂无患者";
                [self.collectionView reloadData];
            });
        } else {
            XJSShowHud(NO, msg);
            self.emptyLabel.text = @"请检查网络";
        }
    }];
}
#pragma mark - Notification
- (void)patientDidDelete:(NSNotification *)notification {
    XJSPatientModel *tempModel = (XJSPatientModel *)notification.object;
    NSArray *tempArray = [self.patientsArray copy];
    [tempArray enumerateObjectsUsingBlock:^(XJSPatientModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.id isEqualToString:tempModel.id]) {
            [self.patientsArray removeObjectAtIndex:idx];
            //[self.collectionView deleteItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:idx inSection:0]]];
            if (self.patientsArray.count == 0) {
                self.emptyLabel.text = @"暂无患者";
            }
            [self.collectionView reloadData];
        }
    }];
    
}
- (void)patientInformationsDidModify:(NSNotification *)notification {
    XJSPatientModel *tempModel = (XJSPatientModel *)notification.object;
    NSArray *tempArray = [self.patientsArray copy];
    [tempArray enumerateObjectsUsingBlock:^(XJSPatientModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.id isEqualToString:tempModel.id]) {
            [self.patientsArray replaceObjectAtIndex:idx withObject:tempModel];
            [self.collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:idx inSection:0]]];
        }
    }];
}

#pragma mark - Action
- (void)searchAction {
    XJSSearchPatientsViewController *searchController = [self.storyboard instantiateViewControllerWithIdentifier:@"XJSSearchPatients"];
    [self.navigationController pushViewController:searchController animated:NO];
}
- (void)addAction {
    XJSAddPatientViewController *addController = [self.storyboard instantiateViewControllerWithIdentifier:@"XJSAddPatient"];
    addController. addBlock = ^{
        [self.collectionView.mj_header beginRefreshing];
    };
    [self.navigationController pushViewController:addController animated:YES];
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
    return self.patientsArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    XJSPatientInfomationCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"XJSPatientInfomationCollectionCell" forIndexPath:indexPath];
    cell.delegate = self;
    XJSPatientModel *patientModel = self.patientsArray[indexPath.row];
    cell.patientModel = patientModel;
    cell.nameLabel.text = patientModel.realname;
    cell.avatarImageView.image = patientModel.gender.integerValue == 1 ? [UIImage imageNamed:@"head_boy"] : [UIImage imageNamed:@"head_girl"];
    cell.patientNumberLabel.text = patientModel.patientNumber;
    cell.ageLabel.text = [NSString stringWithFormat:@"%@岁", patientModel.age];
    cell.diseaseLabel.text = patientModel.symptoms;
    return cell;
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if (kind == UICollectionElementKindSectionFooter) {
        UICollectionReusableView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FooterView" forIndexPath:indexPath];
        [footerView addSubview:self.emptyLabel];
        return footerView;
    }
    return nil;
}

#pragma mark - Collection view delegate flow layout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return (CGSize){kXJSPatientInfoCellWidth, kXJSPatientInfoCellHeight};
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(20, 20, 20, 20);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 18.f;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 10.f;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    return self.patientsArray.count > 0 ? (CGSize){0, 0} : (CGSize){XJSScreenWidth, XJSScreenHeight - 64};
}
#pragma mark - Collection view delegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    XJSPatientModel *model = self.patientsArray[indexPath.row];
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
- (UIButton *)searchButton {
    if (!_searchButton) {
        _searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _searchButton.frame = CGRectMake(0, 0, 40, 40);
        [_searchButton setImage:[UIImage imageNamed:@"navigation_search"] forState:UIControlStateNormal];
        [_searchButton addTarget:self action:@selector(searchAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _searchButton;
}
- (UIButton *)addButton {
    if (!_addButton) {
        _addButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _addButton.frame = CGRectMake(0, 0, 40, 40);
        [_addButton setImage:[UIImage imageNamed:@"navigation_add"] forState:UIControlStateNormal];
        [_addButton addTarget:self action:@selector(addAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addButton;
}
- (UILabel *)emptyLabel {
    if (!_emptyLabel) {
        _emptyLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, XJSScreenWidth, XJSScreenHeight - 300)];
        _emptyLabel.textColor = XJSHexRGBColorWithAlpha(0x999999, 1);
        _emptyLabel.font = XJSBoldSystemFont(15);
        _emptyLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _emptyLabel;
}
- (NSMutableArray *)patientsArray {
    if (!_patientsArray) {
        _patientsArray = [[NSMutableArray alloc] init];
    }
    return _patientsArray;
}

@end
