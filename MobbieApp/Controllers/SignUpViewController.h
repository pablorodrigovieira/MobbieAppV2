//  Sign up view controller, manages Sign up screen
//
//  SignUpViewController.h
//  MobbieApp
//
//  Created by Pablo Vieira on 12/5/18.
//  Copyright © 2018 Pablo Vieira. All rights reserved.

#import "../Customs/CustomTextField.h"
#import "../Providers/DatabaseProvider.h"
#import "../Alerts/AlertsViewController.h"
@import Firebase;

@interface SignUpViewController : UIViewController

- (IBAction)cancelButton:(id)sender;
- (IBAction)confirmButton:(id)sender;

@property (strong, nonatomic) FIRDatabaseReference *ref;
@property (weak, nonatomic) IBOutlet UISwitch *termsAndConditionsSwitch;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingActivityIndicator;
@property (weak, nonatomic) IBOutlet UITextField *firstNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *lastNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *confirmPasswordTextField;

@end
