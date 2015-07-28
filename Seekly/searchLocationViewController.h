//
//  searchLocationViewController.h
//  Seekly
//
//  Created by Deepinder singh on 28/05/15.
//  Copyright (c) 2015 Deepinder singh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import <GoogleMaps/GoogleMaps.h>
@class searchLocationViewController;


@protocol searchLocationViewControllerDelegate <NSObject>
- (void)enteredAddress:(searchLocationViewController *)controller didFinishEnteringItem:(NSString *)address : (NSString *)lati :  (NSString *)longi ;
@end


@interface searchLocationViewController : UIViewController<MKMapViewDelegate,CLLocationManagerDelegate,GMSMapViewDelegate>
{
    double latitude,longitude;
    CLLocationCoordinate2D *mapCurrentCentre;
    GMSCameraPosition *camera;
    NSString *latStr;
    NSString *longStr;
    IBOutlet UILabel *addressFld;
    IBOutlet UITextField *addrTxtFld;
    IBOutlet UILabel *searchAddrLbl;
    
    
}
@property  CLLocationManager *locationManager;
-(IBAction)searchBtnActn:(id)sender;
@property (nonatomic,retain) NSString *latt;
@property (nonatomic,retain) NSString *longg;
@property (nonatomic,retain) NSString *isComingFrmScreen;

@property (nonatomic,retain) NSString *addrName;

@property (strong, nonatomic) IBOutlet GMSMapView *mapView;
@property (nonatomic, weak) id <searchLocationViewControllerDelegate> delegate;
@end
