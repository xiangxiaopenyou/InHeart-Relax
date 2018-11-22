//
//  XJSTrainingRecordsViewController.m
//  InHeart-Sleeping
//
//  Created by 项小盆友 on 2018/4/8.
//  Copyright © 2018年 项小盆友. All rights reserved.
//

#import "XJSTrainingRecordsViewController.h"
#import "XJSTrainingRecordCell.h"

#import "XJSPatientModel.h"
#import "XJSRecordModel.h"

#import <MJRefresh.h>
#import <PGDatePickManager.h>

@interface XJSTrainingRecordsViewController () <UITableViewDelegate, UITableViewDataSource, PGDatePickerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *patientNumberLabel;
@property (weak, nonatomic) IBOutlet UIView *viewOfDate;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIView *viewOfTitle;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *allButton;
@property (nonatomic) NSInteger selectedYear;
@property (nonatomic) NSInteger selectedMonth;
@property (nonatomic) NSInteger paging;
@property (strong, nonatomic) NSMutableArray *recordsArray;

@end

@implementation XJSTrainingRecordsViewController

#pragma mark - View controller life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createViews];
    self.patientNumberLabel.text = [NSString stringWithFormat:@"编号：%@", self.patientModel.patientNumber];
    self.nameLabel.text = [NSString stringWithFormat:@"姓名：%@", self.patientModel.realname];
    
    self.tableView.tableFooterView = [UIView new];
    [self addRefreshView];
    
    [MBProgressHUD showHUDAddedTo:XJSKeyWindow animated:YES];
    _paging = 1;
    [self fetchRecordsList];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private methods
- (void)createViews {
    self.viewOfDate.layer.masksToBounds = YES;
    self.viewOfDate.layer.cornerRadius = 16.f;
    self.viewOfDate.layer.borderWidth = 1;
    self.viewOfDate.layer.borderColor = XJSHexRGBColorWithAlpha(0xd0d0d0, 1).CGColor;
    self.viewOfDate.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDate)];
    [self.viewOfDate addGestureRecognizer:tapGesture];
    
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.path = [UIBezierPath bezierPathWithRoundedRect:self.viewOfTitle.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(5.f, 5.f)].CGPath;
    self.viewOfTitle.layer.masksToBounds = YES;
    self.viewOfTitle.layer.mask = maskLayer;
}
- (void)addRefreshView {
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.paging = 1;
        [self fetchRecordsList];
    }];
    header.stateLabel.hidden = YES;
    header.lastUpdatedTimeLabel.hidden = YES;
    self.tableView.mj_header = header;
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self fetchRecordsList];
    }];
    footer.stateLabel.hidden = YES;
    self.tableView.mj_footer = footer;
}
- (void)refreshAllButtonStatus {
    if (_selectedYear > 0 && _selectedMonth > 0) {
        self.allButton.hidden = NO;
    } else {
        self.allButton.hidden = YES;
    }
}

#pragma mark - Action
- (void)tapDate {
    PGDatePickManager *pickManager = [[PGDatePickManager alloc] init];
    pickManager.style = PGDatePickManagerStyle2;
    PGDatePicker *datePicker = pickManager.datePicker;
    datePicker.maximumDate = [NSDate date];
    NSDate *minDate = [NSDate setYear:2018 month:1];
    datePicker.minimumDate = minDate;
    datePicker.delegate = self;
    datePicker.datePickerMode = PGDatePickerModeYearAndMonth;
    datePicker.datePickerType = PGPickerViewType2;
    if (_selectedYear > 0 && _selectedMonth > 0) {
        NSDate *selectedDate = [NSDate setYear:_selectedYear month:_selectedMonth];
        [datePicker setDate:selectedDate];
    }
    [self presentViewController:pickManager animated:YES completion:nil];
}
- (IBAction)allRecordsAction:(id)sender {
    _selectedYear = 0;
    _selectedMonth = 0;
    self.dateLabel.text = @"全部记录";
    [self refreshAllButtonStatus];
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark - Requests
- (void)fetchRecordsList {
    NSString *selectedDateString = nil;
    if (_selectedYear > 0 && _selectedMonth > 0) {
        selectedDateString = [NSString stringWithFormat:@"%ld-%02ld", (long)_selectedYear, (long)_selectedMonth];
    }
    [XJSRecordModel recordsList:self.patientModel.id date:selectedDateString page:@(_paging) handler:^(id object, NSString *msg) {
        [MBProgressHUD hideHUDForView:XJSKeyWindow animated:YES];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if (object) {
            NSArray *resultArray = [(NSArray *)object copy];
            if (self.paging == 1) {
                self.recordsArray = [resultArray mutableCopy];
            } else {
                NSMutableArray *tempArray = [self.recordsArray mutableCopy];
                [tempArray addObjectsFromArray:resultArray];
                self.recordsArray = [tempArray mutableCopy];
            }
            if (resultArray.count < 20) {
                self.tableView.mj_footer.hidden = YES;
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            } else {
                self.tableView.mj_footer.hidden = NO;
                self.paging += 1;
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
                if (self.recordsArray.count == 0) {
                    XJSShowHud(NO, @"暂无记录");
                }
            });
        } else {
            XJSShowHud(NO, msg);
        }
    }];
}

#pragma mark - PGDate picker delegate
- (void)datePicker:(PGDatePicker *)datePicker didSelectDate:(NSDateComponents *)dateComponents {
    _selectedYear = dateComponents.year;
    _selectedMonth = dateComponents.month;
    self.dateLabel.text = [NSString stringWithFormat:@"%@年%@月", @(_selectedYear), @(_selectedMonth)];
    [self refreshAllButtonStatus];
    //[self.tableView.mj_header beginRefreshing];
    _paging = 1;
    [self fetchRecordsList];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.recordsArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XJSTrainingRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XJSTrainingRecordCell" forIndexPath:indexPath];
    XJSRecordModel *model = self.recordsArray[indexPath.row];
    cell.sceneLabel.text = model.sceneName;
    cell.dateLabel.text = [model.time substringToIndex:19];
    return cell;
}

#pragma mark - Table view delegate

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Getters
- (NSMutableArray *)recordsArray {
    if (!_recordsArray) {
        _recordsArray = [[NSMutableArray alloc] init];
    }
    return _recordsArray;
}

@end
