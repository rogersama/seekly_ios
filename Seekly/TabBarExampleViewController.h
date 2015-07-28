//
//  TabBarExampleViewController.h
//  JDFPeekaboo
//
//  Created by Joe Fryer on 02/03/2015.
//  Copyright (c) 2015 Joe Fryer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "SettingViewController.h"
#import "SDWebImageManager.h"
#import "UIImageView+WebCache.h"
#import "OCMapView.h"
#import "searchLocationViewController.h"
#import "EventsMapViewController.h"

//#import "NVSlideMenuController.h"
@interface TabBarExampleViewController : UIViewController <UITableViewDataSource, UITableViewDelegate,MKMapViewDelegate,CLLocationManagerDelegate,MKAnnotation,OCGrouping>
{
    
    BOOL eventFetchDone;
    CGRect screenSize;
    IBOutlet UIButton *MenuBtn;
    int pageVal;
    CLLocationCoordinate2D coordinate;
    NSString *latStr;
    NSString *longStr;
    IBOutlet UILabel *addressFld;
    IBOutlet MKMapView *mapView;
    IBOutlet UIView *mapViewContainer;
    __weak IBOutlet UILabel *BlankEventTitle;
    NSUInteger rnd;
    NSMutableArray *mainArray;
    IBOutlet UIView *alertBackView;
    EventsMapViewController *objMap;
}

@property (nonatomic, strong) IBOutlet UILabel *labelNumberOfAnnotations;
@property (nonatomic, strong) IBOutlet OCMapView *mapView;

- (IBAction)removeButtonTouchUpInside:(id)sender;
- (IBAction)addButtonTouchUpInside:(id)sender;
- (IBAction)clusteringButtonTouchUpInside:(UIButton *)sender;
- (IBAction)addOneButtonTouchupInside:(id)sender;
- (IBAction)changeClusterMethodButtonTouchUpInside:(UIButton *)sender;
- (IBAction)buttonGroupByTagTouchUpInside:(UIButton *)sender;

- (NSArray *)randomCoordinatesGenerator:(int)numberOfCoordinates;

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, strong)CLLocationManager *locationManager;

//@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic)  IBOutlet UIPageControl *pageControl;

 -(id)initWithLocation:(CLLocationCoordinate2D)coord;

@end
// Copyright belongs to original author
// http://code4app.net (en) http://code4app.com (cn)
// From the most professional code share website: Code4App.net