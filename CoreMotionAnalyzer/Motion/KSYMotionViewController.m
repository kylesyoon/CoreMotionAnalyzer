//
//  ViewController.m
//  CoreMotionAnalyzer
//
//  Created by Kyle Yoon on 4/2/15.
//  Copyright (c) 2015 Kyle Yoon. All rights reserved.
//

#import "KSYMotionViewController.h"
#import <CoreMotion/CoreMotion.h>
#import "KSYGraphViewController.h"
#import "KSYSettingsViewController.h"
#import "KSYMotionDataSource.h"
#import "KSYMotionDataTableViewCell.h"
#import "KSYMotionTimestampHeaderView.h"
#import "KSYUserSettings.h"

static NSString * const kGraphViewControllerSegueIdentifier = @"graphViewControllerSegueIdentifier";
static CGFloat const kMotionUpdateInterval = 0.05;
static CGFloat const kEstimatedRowHeight = 180.0;

@interface KSYMotionViewController () <UITableViewDataSource, UITableViewDelegate, KSYSettingsViewControllerDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) CMMotionManager *motionManager;
@property (nonatomic, copy) NSArray <CMDeviceMotion *> *motionData;
@property (nonatomic, strong) KSYMotionDataSource *motionDataSource;
@property (nonatomic, strong) KSYUserSettings *settings;

@end

@implementation KSYMotionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.motionManager = [[CMMotionManager alloc] init];
    self.motionManager.deviceMotionUpdateInterval = kMotionUpdateInterval;
    
    self.motionData = @[];
    self.motionDataSource = [KSYMotionDataSource new];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([KSYMotionDataTableViewCell class]) bundle:nil]
         forCellReuseIdentifier:NSStringFromClass([KSYMotionDataTableViewCell class])];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([KSYMotionTimestampHeaderView class]) bundle:nil]
forHeaderFooterViewReuseIdentifier:NSStringFromClass([KSYMotionTimestampHeaderView class])];
    self.tableView.estimatedRowHeight = kEstimatedRowHeight;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.settings = [[KSYUserSettings alloc] init]; // defaults everything to YES
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:kGraphViewControllerSegueIdentifier]) {
        KSYGraphViewController *graphViewController = segue.destinationViewController;
        NSMutableArray *selectedData = [NSMutableArray array];
        for (NSIndexPath *indexPath in self.tableView.indexPathsForSelectedRows) {
            CMDeviceMotion *motionData = [self.motionDataSource dataForIndexPath:indexPath];
            [selectedData addObject:motionData];
        }
        graphViewController.data = [selectedData copy];
    }
}

- (CMDeviceMotionHandler)handleDeviceMotionUpdates {
    typeof(self) __weak weakSelf = self;
    return ^(CMDeviceMotion *motion, NSError *error) {
        NSMutableArray *tempMotionData = [self.motionData mutableCopy];
        [tempMotionData addObject:motion];
        weakSelf.motionData = [tempMotionData copy];
        [weakSelf.motionDataSource appendMotionData:motion];
        [weakSelf.tableView reloadData];
    };
}

- (IBAction)didTapStartStopButton:(UIBarButtonItem *)button {
    if (self.motionManager.isDeviceMotionActive) {
        button.title = NSLocalizedString(@"Start", @"Stop title");
        [self.motionManager stopDeviceMotionUpdates];
    }
    else {
        if (self.motionManager.deviceMotionAvailable) {
            button.title = NSLocalizedString(@"Stop", @"Stop title");
            [self.motionManager startDeviceMotionUpdatesToQueue:[NSOperationQueue mainQueue]
                                                    withHandler:[self handleDeviceMotionUpdates]];
        }
        else {
            // TODO: Show alert
        }
    }
}

- (IBAction)didTapSelectAllButton:(UIBarButtonItem *)button {
    if (self.tableView.indexPathsForSelectedRows.count < [self.motionDataSource numberOfSections]) {
        for (int i = 0; i < [self.motionDataSource numberOfSections]; i++) {
            [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:i]
                                        animated:true
                                  scrollPosition:UITableViewScrollPositionNone];
        }
        button.title = NSLocalizedString(@"Deselect All", @"Deselect All button title");
    }
    else {
        for (int i = 0; i < [self.motionDataSource numberOfSections]; i++) {
            [self.tableView deselectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:i]
                                          animated:true];
        }
        button.title = NSLocalizedString(@"Select All", @"Select All button title");
    }
}

- (IBAction)didTapClearButton:(id)sender {
    self.motionData = @[];
    self.motionDataSource = [KSYMotionDataSource new];
    [self.tableView reloadData];
}

- (IBAction)didTapSettingsButton:(id)sender {
    KSYSettingsViewController *settingsViewController = [KSYSettingsViewController settingsViewControllerWithUserSettings:self.settings];
    settingsViewController.delegate = self;
    UINavigationController *settingsNav = [[UINavigationController alloc] initWithRootViewController:settingsViewController];
    [self presentViewController:settingsNav
                       animated:YES
                     completion:nil];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    KSYMotionDataTableViewCell *cell = [tableView
                                        dequeueReusableCellWithIdentifier:NSStringFromClass([KSYMotionDataTableViewCell class])
                                        forIndexPath:indexPath];
    CMDeviceMotion *motionData = [self.motionDataSource dataForIndexPath:indexPath];
    [cell configureWithDeviceMotion:motionData andUserSettings:self.settings];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.motionDataSource numberOfRowsForSection:section];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.motionDataSource numberOfSections];
}

#pragma mark - UITableViewDelegate

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    KSYMotionTimestampHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass([KSYMotionTimestampHeaderView class])];
    headerView.timestampLabel.text = [self.motionDataSource titleForHeaderForSection:section];
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return KSYMotionTimestampHeaderView.headerViewHeight;
}

#pragma mark - KSYSettingsViewControllerDelegate

- (void)settingsViewController:(KSYSettingsViewController *)settingsViewController userDidTapDoneWithSettings:(KSYUserSettings *)userSettings {
    [self dismissViewControllerAnimated:YES completion:nil];
    self.settings = userSettings;
    [self.tableView reloadData];
}

@end
