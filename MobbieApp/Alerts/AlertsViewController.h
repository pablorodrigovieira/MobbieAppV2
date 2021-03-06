//  Helper class with Custom AlertsView and Messages
//
//  AlertsViewController.h
//  MobbieApp
//
//  Created by Pablo Vieira on 21/5/18.
//  Copyright © 2018 Pablo Vieira. All rights reserved.

#import "ViewController.h"

@interface AlertsViewController : UIViewController

//Constants
extern NSString *const const_alert_message;
extern NSString *const const_alert_title;
extern NSString *const const_alert_button;
extern NSString *const const_about_alert_message;
extern NSString *const const_about_alert_title;
extern NSString *const const_input_alert_message;
extern NSString *const const_input_alert_title;
extern NSString *const const_no_input_alert_message;
extern NSString *const const_passwords_not_matching_alert_message;
extern NSString *const const_update_db_alert_message;
extern NSString *const const_upload_db_alert_message;
extern NSString *const const_invalid_email_alert_message;
extern NSString *const const_car_input_required;
extern NSString *const const_error_terms_and_conditions;
extern NSString *const const_error_sign_out;
extern NSString *const const_error_device_no_camera;
extern NSString *const const_profile_alert_message;
extern NSString *const const_profile_alert_title;
extern NSString *const const_profile_alert_button;
extern NSString *const const_profile_alert_cancel_button;

//Methods
-(void)displayInputAlert: (NSString *) fieldName;
-(void)displayAboutAlert;
-(void)displayAlertMessage: (NSString *) message;

@end
