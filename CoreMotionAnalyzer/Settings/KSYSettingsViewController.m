//
//  SettingsViewController.m
//  CoreMotionAnalyzer
//
//  Created by Kyle Yoon on 4/3/15.
//  Copyright (c) 2015 Kyle Yoon. All rights reserved.
//

#import "KSYSettingsViewController.h"
#import "KSYMotionViewController.h"
#import "KSYUserSettings.h"

@interface KSYSettingsViewController ()

@property (strong, nonatomic) IBOutlet UISegmentedControl *userAccelerationSegmentedControl;
@property (strong, nonatomic) IBOutlet UISegmentedControl *gravitySegmentedControl;
@property (strong, nonatomic) IBOutlet UISegmentedControl *rotationSegmentedControl;

@property (nonatomic, strong) KSYUserSettings *userSettings;

@end

@implementation KSYSettingsViewController

+ (instancetype)settingsViewControllerWithUserSettings:(KSYUserSettings *)userSettings {
    KSYSettingsViewController *settingsViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]
                                                         instantiateViewControllerWithIdentifier:NSStringFromClass([KSYSettingsViewController class])];
    settingsViewController.userSettings = userSettings;
    return settingsViewController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.userAccelerationSegmentedControl.selectedSegmentIndex = self.userSettings.isUserAccelerationOn ? 0 : 1;
    self.gravitySegmentedControl.selectedSegmentIndex = self.userSettings.isGravityOn ? 0 : 1;
    self.rotationSegmentedControl.selectedSegmentIndex = self.userSettings.isRotationOn ? 0 : 1;
}

- (IBAction)didTapDone:(id)sender {
    KSYUserSettings *newUserSettings = [KSYUserSettings userSettingsWithAccelerationOn:self.userAccelerationSegmentedControl.selectedSegmentIndex == 0
                                                                             gravityOn:self.gravitySegmentedControl.selectedSegmentIndex == 0
                                                                            rotationOn:self.rotationSegmentedControl.selectedSegmentIndex == 0];
    [self.delegate settingsViewController:self userDidTapDoneWithSettings:newUserSettings];
}

@end
