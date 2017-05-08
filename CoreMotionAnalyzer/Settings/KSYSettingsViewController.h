//
//  SettingsViewController.h
//  CoreMotionAnalyzer
//
//  Created by Kyle Yoon on 4/3/15.
//  Copyright (c) 2015 Kyle Yoon. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KSYSettingsViewController;
@class KSYUserSettings;

@protocol KSYSettingsViewControllerDelegate

/**
 Lets the delegate know that the user tapped done. Presenting view controller should handle the dismissing logic. Also passes the current user settings.

 @param settingsViewController settings view controller to dismiss
 @param userSettings the user settings
 */
- (void)settingsViewController:(KSYSettingsViewController *)settingsViewController userDidTapDoneWithSettings:(KSYUserSettings *)userSettings;

@end

@interface KSYSettingsViewController : UIViewController

@property (nonatomic, weak) id<KSYSettingsViewControllerDelegate> delegate;

+ (instancetype)settingsViewControllerWithUserSettings:(KSYUserSettings *)userSettings;

@end
