//  Controller for Profile Screen (View)
//
//  ProfileViewController.h
//  MobbieApp
//
//  Created by Pablo Vieira on 12/5/18.
//  Copyright © 2018 Pablo Vieira. All rights reserved.

#import "../Customs/CustomTextField.h"
#import "../Models/UserModel.h"
#import "../Providers/DatabaseProvider.h"

@interface ProfileViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *firstNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *lastNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumberTextField;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingActivity;

- (IBAction)changePasswordButton:(id)sender;
- (IBAction)updateProfileButton:(id)sender;

@end
