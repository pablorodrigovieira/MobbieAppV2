//
//  AlertsViewController.m
//  MobbieApp
//
//  Created by Pablo Vieira on 21/5/18.
//  Copyright © 2018 Pablo Vieira. All rights reserved.
//

#import "AlertsViewController.h"

@interface AlertsViewController ()

@end

@implementation AlertsViewController

NSString *const const_alert_message = @"DEFAULT..";
NSString *const const_alert_title = @"Mobbie";
NSString *const const_alert_button = @"Ok";

NSString *const const_about_alert_message = @"Perform Sign Up or Login to access the features that Mobbie App allows the users..";
NSString *const const_about_alert_title = @"About Mobbie";

NSString *const const_input_alert_message = @"Please fill up the Information at: ";
NSString *const const_input_alert_title = @"Empty Field";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIViewController *)topViewController {
    return [self topViewController:[UIApplication sharedApplication].keyWindow.rootViewController];
}

//Get current view controller
- (UIViewController *)topViewController:(UIViewController *)rootViewController {
    if (rootViewController.presentedViewController == nil) {
        return rootViewController;
    }
    
    if ([rootViewController.presentedViewController isMemberOfClass:[UINavigationController class]]) {
        UINavigationController *navigationController = (UINavigationController *)rootViewController.presentedViewController;
        UIViewController *lastViewController = [[navigationController viewControllers] lastObject];
        return [self topViewController:lastViewController];
    }
    
    UIViewController *presentedViewController = (UIViewController *)rootViewController.presentedViewController;
    return [self topViewController:presentedViewController];
}


-(void)displayInputAlert: (NSString *) fieldName{
    
    UIAlertController *alert = [UIAlertController
                                alertControllerWithTitle: const_input_alert_title
                                message: [const_input_alert_message stringByAppendingString: fieldName]
                                preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okButton = [UIAlertAction actionWithTitle: const_alert_button
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * _Nonnull action)
                               {
                                   [alert dismissViewControllerAnimated:YES completion:nil];
                               }];
    
    //Add ok button
    [alert addAction: okButton];
    
    //Display Alert
    UIViewController *rootViewController = self.topViewController;
    [rootViewController presentViewController:alert animated:YES completion:nil];
}

-(void)displayAboutAlert{
    
    UIAlertController *alert = [UIAlertController
                                alertControllerWithTitle: const_about_alert_title
                                message: const_about_alert_message
                                preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okButton = [UIAlertAction actionWithTitle: const_alert_button
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * _Nonnull action)
                               {
                                   [alert dismissViewControllerAnimated:YES completion:nil];
                               }];
    
    //Add ok button
    [alert addAction: okButton];
    
    //Display Alert
    UIViewController *rootViewController = self.topViewController;
    [rootViewController presentViewController:alert animated:YES completion:nil];
}
@end
