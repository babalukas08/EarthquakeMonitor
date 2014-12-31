//
//  DetailController.m
//  EarthquakeMonitor
//
//  Created by VaD on 31/12/14.
//  Copyright (c) 2014 PlayInteractive. All rights reserved.
//

#import "DetailController.h"

@interface DetailController ()

@end

@implementation DetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"Data Is %@",self.dataEarthquake);
    _mapView.showsUserLocation = YES;
    [self setDataEarthquake];
}
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setDataEarthquake{
    
    [mag setText:[NSString stringWithFormat:@"%0.2f",[[[self.dataEarthquake valueForKey:@"properties"]valueForKey:@"mag"] floatValue]]];
    
    [location setText:[NSString stringWithFormat:@"%@ with depth: %0.2f",[[self.dataEarthquake valueForKey:@"properties"]valueForKey:@"place"],[[[[self.dataEarthquake valueForKey:@"geometry"]valueForKey:@"coordinates"]objectAtIndex:2] floatValue]]];
    
    [location setAdjustsFontSizeToFitWidth:YES];
    
    NSTimeInterval timeInMiliseconds = [[[self.dataEarthquake valueForKey:@"properties"]valueForKey:@"time"] integerValue];
    
    [date setText:[self ConvertDate:timeInMiliseconds]];
    [date setAdjustsFontSizeToFitWidth:YES];
    
    [self SetLocationWithLatitude:[[[[self.dataEarthquake valueForKey:@"geometry"]valueForKey:@"coordinates"]objectAtIndex:1] floatValue] withLongitude:[[[[self.dataEarthquake valueForKey:@"geometry"]valueForKey:@"coordinates"]objectAtIndex:0] floatValue] withTitle:[[self.dataEarthquake valueForKey:@"properties"]valueForKey:@"type"]];
}
-(NSString*)ConvertDate:(NSTimeInterval)value{
    
    NSDate* dates = [NSDate dateWithTimeIntervalSince1970:value];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss zzz"];

    
    NSString *stringFromDate = [formatter stringFromDate:dates];
    return stringFromDate;
}

- (IBAction)backAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)SetLocationWithLatitude:(float)lat withLongitude:(float)lon withTitle:(NSString*)title{
    
    CLLocationCoordinate2D  ctrpoint;
    ctrpoint.latitude = lat;
    ctrpoint.longitude =lon;
    AddressAnnotation *addAnnotation = [[AddressAnnotation alloc] initWithCoordinate:ctrpoint];
    
    
    addAnnotation.title = title;
    [_mapView addAnnotation:addAnnotation];
    
    CLLocation * LocationAtual = [[CLLocation alloc]initWithLatitude:ctrpoint.latitude longitude:ctrpoint.longitude];
    
    [self updateMapZoomLocation:LocationAtual];
}
- (void)updateMapZoomLocation:(CLLocation *)newLocation
{
    MKCoordinateRegion region;
    region.center.latitude = newLocation.coordinate.latitude;
    region.center.longitude = newLocation.coordinate.longitude;
    region.span.latitudeDelta = 4.8;
    region.span.longitudeDelta = 4.8;
    [_mapView setRegion:region animated:YES];
}

#pragma mark MKMapView Delegate

- (MKAnnotationView *)mapView:(MKMapView *)theMapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    // if it's the user location, just return nil.
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    
    MKPinAnnotationView *annView=[[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"MyPin"];
    annView.animatesDrop=TRUE;
    annView.canShowCallout = YES;
    [annView setSelected:YES];
    annView.pinColor = self.ColorPin;
    annView.calloutOffset = CGPointMake(-2, 2);
    return annView;
}

@end
