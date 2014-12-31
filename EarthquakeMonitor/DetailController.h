//
//  DetailController.h
//  EarthquakeMonitor
//
//  Created by VaD on 31/12/14.
//  Copyright (c) 2014 PlayInteractive. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "AddressAnnotation.h"

@interface DetailController : UIViewController<MKMapViewDelegate>{
    
    __weak IBOutlet UILabel *mag;
    __weak IBOutlet UILabel *date;
    __weak IBOutlet UILabel *location;
}

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (strong,nonatomic) NSMutableArray *dataEarthquake;
@property int ColorPin;
- (IBAction)backAction:(UIButton *)sender;

@end
