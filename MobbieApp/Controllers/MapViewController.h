//
//  MapViewController.h
//  MobbieApp
//
//  Created by Pablo Vieira on 14/5/18.
//  Copyright © 2018 Pablo Vieira. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "CoreLocation/CoreLocation.h"

@interface MapViewController : UIViewController

@property (weak, nonatomic) IBOutlet UISlider *sliderRange;
@property (weak, nonatomic) IBOutlet UILabel *kmLabel;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) CLLocationManager *locationManager;

- (IBAction)sliderRangeChanged:(UISlider *)sender;

//Methods
-(void)viewWillAppear: (BOOL)animated;
-(void)createBoundaryWithRadius: (float)radius;
-(MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay;

@end
