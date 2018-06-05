//
//  DatabaseProvider.m
//  MobbieApp
//
//  Created by Pablo Vieira on 22/5/18.
//  Copyright © 2018 Pablo Vieira. All rights reserved.
//

#import "DatabaseProvider.h"

@implementation DatabaseProvider

@synthesize rootNode, usersNode, USER_ID, storageRef;

NSString *const const_database_car_key_vin_chassis = @"vin-chassis";
NSString *const const_database_car_key_rego_expiry = @"rego-expiry";
NSString *const const_database_car_key_plate_number = @"plate-number";
NSString *const const_database_car_key_year = @"year";
NSString *const const_database_car_key_make = @"make";
NSString *const const_database_car_key_body_type = @"body-type";
NSString *const const_database_car_key_transmission = @"transmission";
NSString *const const_database_car_key_colour = @"colour";
NSString *const const_database_car_key_fuel_type = @"fuel-type";
NSString *const const_database_car_key_seats = @"seats";
NSString *const const_database_car_key_doors = @"doors";
NSString *const const_database_car_key_model = @"model";
NSString *const const_database_car_key_image_url = @"image-url";
NSString *const const_database_car_key_status = @"status";

//Constructor
-(id)init{
    
    self = [super init];
    
    if(self)
    {
        //Reference to Firebase
        self.rootNode = [[FIRDatabase database] reference];
        self.usersNode = [rootNode child:@"users"];
        
        //Get Current User ID
        if(USER_ID == nil){
            USER_ID = [FIRAuth auth].currentUser.uid;
        }
    }
    return self;
}

//Insert User Profile - FIREBASE
-(void)InsertUserProfileData: (UserModel *) user WithUserID:(NSString *) userID{
    @try{
        //Reference Child Firebase
        NSString *key = [[rootNode child:@"users/"] child:userID].key;
        
        //Obj to parse into Firebase
        NSDictionary *postFirebase =
        @{
          @"first_name": [user firstName],
          @"last_name": [user lastName],
          @"email": [user email],
          @"phone_number": [user phoneNumber]
          };
        
        //Append User info to Obj
        NSDictionary *childUpdate = @{[[@"/users/" stringByAppendingString:key] stringByAppendingString:@"/profile"]: postFirebase};
        
        //Insert into DB
        [rootNode updateChildValues:childUpdate
                withCompletionBlock:^(NSError * _Nullable error,
                                      FIRDatabaseReference * _Nonnull ref)
        {
            if(error != nil){
                //Error
                AlertsViewController *alert = [[AlertsViewController alloc] init];
                [alert displayAlertMessage:error.localizedDescription];
            }
            else{
                return;
            }
        }];
        
    }
    @catch(NSException *ex){
        @throw ex.reason;
    }
}

-(void)UpdateUserProfile:(UserModel *)user WithUserID:(NSString*) userID{
    @try{
        //Get current UID
        if(userID == nil){
            userID = [FIRAuth auth].currentUser.uid;
        }
        
        //Create NSDictonary
        NSDictionary *userDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                                  user.firstName, @"first_name",
                                  user.lastName, @"last_name",
                                  user.phoneNumber, @"phone_number",nil];
        [[[[rootNode
            child:@"users"]
            child:userID]
            child:@"profile"]
         setValue:userDic
         withCompletionBlock:^(NSError * _Nullable error,
                               FIRDatabaseReference * _Nonnull ref)
        {
            if(error == nil){
                //Update successed
                AlertsViewController *alert = [[AlertsViewController alloc] init];
                [alert displayAlertMessage:const_update_db_alert_message];
            }
            else{
                //Error
                AlertsViewController *alert = [[AlertsViewController alloc] init];
                [alert displayAlertMessage:error.observationInfo];
            }
        }];
    }
    @catch(NSException *ex){
        @throw ex.reason;
    }
}

-(void)ChangeUserPassword:(NSString *)userPwd{
    @try{
        [[FIRAuth auth].currentUser
         updatePassword:userPwd
         completion:^(NSError * _Nullable error) {
             if(error == nil)
                 return;
         }];
    }
    @catch(NSException *ex){
        @throw ex.reason;
    }
}

-(void)InsertUserMapSettings:(MapModel *) distance WithUserID:(NSString *)userId{
    @try{
        //Reference Child Firebase
        NSString *key = [[rootNode child:@"users/"] child:userId].key;
        
        //Obj to parse into Firebase
        NSDictionary *postFirebase =
        @{
          @"range_distance": [distance rangeDistance]
          };
        
        //Append map info to Obj
        NSDictionary *childUpdate = @{[[@"/users/" stringByAppendingString:key] stringByAppendingString:@"/map"]: postFirebase};
        
        //Insert into DB
        [rootNode updateChildValues:childUpdate
                withCompletionBlock:^(NSError * _Nullable error,
                                      FIRDatabaseReference * _Nonnull ref)
         {
             if(error != nil){
                 //Error
                 AlertsViewController *alert = [[AlertsViewController alloc] init];
                 [alert displayAlertMessage:error.localizedDescription];
             }
             else{
                 return;
             }
         }];
    }
    @catch(NSException *ex){
        @throw ex.reason;
    }
}

-(void)UpdateMapSettings:(MapModel *) map WithUserID:(NSString *)userId{
    @try{
        //Get current UID
        if(userId == nil){
            userId = [FIRAuth auth].currentUser.uid;
        }
        
        //Create NSDictonary
        NSDictionary *mapDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                                 map.rangeDistance, @"range_distance",nil];
        //Set value to DB
        [[[[rootNode
            child:@"users"]
           child:userId]
          child:@"map"]
         setValue:mapDic
         withCompletionBlock:^(NSError * _Nullable error,
                               FIRDatabaseReference * _Nonnull ref)
         {
             if(error == nil){
                 //Update successed
                 AlertsViewController *alert = [[AlertsViewController alloc] init];
                 [alert displayAlertMessage:const_update_db_alert_message];
             }
             else{
                 //Error
                 AlertsViewController *alert = [[AlertsViewController alloc] init];
                 [alert displayAlertMessage:error.observationInfo];
             }
         }];
    }
    @catch(NSException *ex){
        @throw ex.reason;
    }
}

-(void)InsertCarImage:(UIImageView *) image{
    @try{
        //
        CGFloat compressionQuality = 0.8;
        USER_ID = [FIRAuth auth].currentUser.uid;
        
        if(image.image != nil){
            
            FIRStorage *storage = [FIRStorage storage];
            storageRef = [storage referenceForURL:@"gs://mobbieapp.appspot.com"];
            
            NSString *imageID = [[NSUUID UUID] UUIDString];
            NSString *imageName = [NSString stringWithFormat:@"%@ %@",[NSString stringWithFormat:@"%@", USER_ID],[NSString stringWithFormat:@"/%@.jpg",imageID]];
            
            FIRStorageReference *imageRef = [storageRef child:imageName];
            FIRStorageMetadata *metadata = [[FIRStorageMetadata alloc]init];
            
            metadata.contentType = @"image/jpeg";
            NSData *imageData = UIImageJPEGRepresentation(image.image, compressionQuality);
            
            [imageRef putData:imageData metadata:metadata
                   completion:^(FIRStorageMetadata *metadata,
                                NSError *error)
            {
                if(!error){
                     //Get IMG URL
                    [imageRef downloadURLWithCompletion:^(NSURL * _Nullable URL, NSError * _Nullable error) {
                        
                        //TODO
                        //Add URL to CarObj
                        
                        AlertsViewController *alert = [[AlertsViewController alloc] init];
                        [alert displayAlertMessage:URL.absoluteString];
                    }];
                    //Update successed
                    AlertsViewController *alert = [[AlertsViewController alloc] init];
                    [alert displayAlertMessage:const_upload_db_alert_message];
                }
                else{
                    //Error
                    AlertsViewController *alert = [[AlertsViewController alloc] init];
                    [alert displayAlertMessage:error.observationInfo];
                }
            }];
            
            
        }
    }
    @catch(NSException *ex){
        @throw ex.reason;
    }
}

@end
