//
//  DatabaseProvider.m
//  MobbieApp
//
//  Created by Pablo Vieira on 22/5/18.
//  Copyright © 2018 Pablo Vieira. All rights reserved.

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
NSString *const const_database_profile_key_first_name = @"first_name";
NSString *const const_database_profile_key_last_name = @"last_name";
NSString *const const_database_profile_key_email = @"email";
NSString *const const_database_profile_key_phone_number = @"phone_number";
NSString *const const_database_node_users = @"users";
NSString *const const_database_node_profile = @"profile";
NSString *const const_database_node_cars = @"cars";
NSString *const const_database_node_map = @"map";
NSString *const const_database_range_distance_id = @"range_distance";
NSString *const const_database_storage_reference = @"gs://mobbieapp.appspot.com";
NSString *const const_image_type = @"image/jpeg";

//Constructor
-(id)init{
    @try{
        self = [super init];
        
        if(self)
        {
            //Reference to Firebase
            self.rootNode = [[FIRDatabase database] reference];
            self.usersNode = [rootNode child:const_database_node_users];
            
            //Get Current User ID
            if(USER_ID == nil){
                USER_ID = [FIRAuth auth].currentUser.uid;
            }
        }
        return self;
    }
    @catch(NSException *ex){
        @throw ex.reason;
    }
}

/**
 *
 * Insert User Data(Profile) into Firebase
 * @author Pablo Vieira
 *
 * @param user - UserModel Object
 * @param userID - NSString
 *
 */
-(void)insertUserProfileData: (UserModel *) user WithUserID:(NSString *) userID{
    @try{
        //Reference Child Firebase
        NSString *key = [[rootNode child:@"users/"] child:userID].key;
        
        //Obj to parse into Firebase
        NSDictionary *postFirebase =
        @{
          const_database_profile_key_first_name: [user firstName],
          const_database_profile_key_last_name: [user lastName],
          const_database_profile_key_email: [user email],
          const_database_profile_key_phone_number: [user phoneNumber]
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

/**
 *
 * Update User Data(Profile) into Firebase
 * @author Pablo Vieira
 *
 * @param user - UserModel Object
 * @param userID - NSString
 *
 */
-(void)updateUserProfile:(UserModel *)user WithUserID:(NSString*) userID{
    @try{
        //Get current UID
        if(userID == nil){
            userID = [FIRAuth auth].currentUser.uid;
        }
        
        //Create NSDictonary
        NSDictionary *userDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                                  user.firstName, const_database_profile_key_first_name,
                                  user.lastName, const_database_profile_key_last_name,
                                  user.phoneNumber, const_database_profile_key_phone_number,
                                  user.email, const_database_profile_key_email,nil];
        [[[[rootNode
            child:const_database_node_users]
            child:userID]
            child:const_database_node_profile]
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

/**
 *
 * Change user password into Firebase
 * @author Pablo Vieira
 *
 * @param userPwd - NSString
 *
 */
-(void)changeUserPassword:(NSString *)userPwd{
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

/**
 *
 * Insert User Map Data into Firebase
 * @author Pablo Vieira
 *
 * @param distance - MapModel Object
 * @param userId - NSString
 *
 */
-(void)insertUserMapSettings:(MapModel *) distance WithUserID:(NSString *)userId{
    @try{
        //Reference Child Firebase
        NSString *key = [[rootNode child:@"users/"] child:userId].key;
        
        //Obj to parse into Firebase
        NSDictionary *postFirebase =
        @{
          const_database_range_distance_id: [distance rangeDistance]
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

/**
 *
 * Update User Map Data into Firebase
 * @author Pablo Vieira
 *
 * @param map - MapModel Object
 * @param userId - NSString
 *
 */
-(void)updateMapSettings:(MapModel *) map WithUserID:(NSString *)userId{
    @try{
        //Get current UID
        if(userId == nil){
            userId = [FIRAuth auth].currentUser.uid;
        }
        
        //Create NSDictonary
        NSDictionary *mapDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                                 map.rangeDistance, const_database_range_distance_id,nil];
        //Set value to DB
        [[[[rootNode
            child:const_database_node_users]
           child:userId]
          child:const_database_node_map]
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

/**
 *
 * Insert Image into Firebase storage
 * @author Pablo Vieira
 *
 * @param image - UIImageView
 *
 * @return image URL from Firebase
 */
-(NSString *)insertImage:(UIImageView *) image{
    @try{
        CGFloat compressionQuality = 0.8;
        USER_ID = [FIRAuth auth].currentUser.uid;
        
        CarModel *myCar = [[CarModel alloc] init];
        
        //Semaphore to execute async func
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        
        if(image.image != nil){
            
            //Image info
            NSString *imageID = [[NSUUID UUID] UUIDString];
            NSString *imageName = [NSString stringWithFormat:@"%@ %@",[NSString stringWithFormat:@"%@", USER_ID],[NSString stringWithFormat:@"/%@.jpg",imageID]];
            
            //References
            FIRStorage *storage = [FIRStorage storage];
            storageRef = [storage referenceForURL:const_database_storage_reference];
            FIRStorageReference *imageRef = [storageRef child:imageName];
            FIRStorageMetadata *metadata = [[FIRStorageMetadata alloc]init];
            
            metadata.contentType = const_image_type;
            NSData *imageData = UIImageJPEGRepresentation(image.image, compressionQuality);
            
            [imageRef putData:imageData metadata:metadata
                   completion:^(FIRStorageMetadata *metadata,
                                NSError *error)
             {
                 if(!error){
                     //Get IMG URL
                     [imageRef downloadURLWithCompletion:^(NSURL * _Nullable URL, NSError * _Nullable error) {
                         
                         myCar.imageURL = URL.absoluteString;
                         
                         //dispatch semaphore
                         dispatch_semaphore_signal(sema);
                     }];
                 }
                 else{
                     //Error
                     AlertsViewController *alert = [[AlertsViewController alloc] init];
                     [alert displayAlertMessage:error.observationInfo];
                 }
             }];
        }
        while (dispatch_semaphore_wait(sema, DISPATCH_TIME_NOW)) {
            [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:10]];
        }
        
        return myCar.imageURL;
    }
    @catch(NSException *ex){
        @throw ex.reason;
    }
}

/**
 *
 * Insert Car Object into Firebase
 * @author Pablo Vieira
 *
 * @param car - CarModel Object
 *
 */
-(void)insertCarDetails:(CarModel *) car{
    @try{
        
        NSString *userID = [FIRAuth auth].currentUser.uid;
        NSString *CarPath = [NSString stringWithFormat:@"%@/%@/%@", const_database_node_users, userID, const_database_node_cars];
        
        //Obj to be inserted into DB
        NSDictionary *carPost = @{
                                  const_database_car_key_vin_chassis: car.vinChassis,
                                  const_database_car_key_rego_expiry: car.regoExpiry,
                                  const_database_car_key_plate_number: car.plateNumber,
                                  const_database_car_key_year: car.year,
                                  const_database_car_key_make: car.make,
                                  const_database_car_key_body_type: car.bodyType,
                                  const_database_car_key_transmission: car.transmission,
                                  const_database_car_key_colour: car.colour,
                                  const_database_car_key_fuel_type: car.fuelType,
                                  const_database_car_key_seats: car.seats,
                                  const_database_car_key_doors: car.doors,
                                  const_database_car_key_model: car.carModel,
                                  const_database_car_key_image_url: car.imageURL
                                  };
        
        NSDictionary *childUpdate = @{[NSString stringWithFormat:@"%@/%@", CarPath, car.plateNumber]: carPost};
        
        [rootNode updateChildValues:childUpdate withCompletionBlock:^(NSError * _Nullable error, FIRDatabaseReference * _Nonnull ref) {
            if(error == nil){
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
    @catch(NSException *ex){
        @throw ex.reason;
    }
}

/**
 *
 * Delete Car from Firebase
 *
 * @author Pablo Vieira
 *
 * @param car - CarModel Object
 *
 */
-(void)deleteCar:(CarModel *) car{
    @try{
        
        NSString *userID = [FIRAuth auth].currentUser.uid;
        NSString *CarPath = [NSString stringWithFormat:@"%@/%@/%@/%@",const_database_node_users, userID, const_database_node_cars,car.plateNumber];
        
        //Image reference from storage
        FIRStorage *storage = [FIRStorage storage];
        FIRStorageReference *imageRef = [storage referenceForURL:car.imageURL];
        
        // Delete Image file
        [imageRef deleteWithCompletion:^(NSError *error){
            // File deleted successfully
            if (error == nil) {
                //Delete Car
                FIRDatabaseReference *carNode = [self.rootNode child:CarPath];
                [carNode removeValue];
            }
        }];
    }
    @catch(NSException *ex){
        @throw ex.reason;
    }
}


@end
