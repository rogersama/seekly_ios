//
//  EventsMapViewController.h
//  Seekly
//
//  Created by Gursimran on 13/07/15.
//  Copyright (c) 2015 Deepinder singh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "SeeklyAPI.h"
#import "OCMapView.h"
#import "OCMapViewSampleHelpAnnotation.h"
#import "EventScrollView.h"
#import <MapKit/MapKit.h>




@interface EventsMapViewController : UIViewController<MKMapViewDelegate,CLLocationManagerDelegate,EventScrollViewDelegate,MKAnnotation>

{
    MBProgressHUD *HUD;

//    NSDictionary *responseDict;
//    NSDictionary *dict;
//    NSMutableArray *allEventArray;
    IBOutlet UIView *events;
    IBOutlet UILabel *title;

}

@property (strong ,nonatomic) NSMutableArray *eventsArray;
@property (nonatomic, strong) IBOutlet MKMapView *mapView;
@property (nonatomic, strong) IBOutlet UILabel *labelNumberOfAnnotations;
@property IBOutlet EventScrollView *eventsView;
@property (nonatomic ,strong) IBOutlet UILabel *titlelabel;

-(IBAction)mapButton:(id)sender;


@end
