//
//  searchLocationViewController.m
//  Seekly
//
//  Created by Deepinder singh on 28/05/15.
//  Copyright (c) 2015 Deepinder singh. All rights reserved.
//

#import "searchLocationViewController.h"
#import "MBProgressHUD.h"
#define METERS_PER_MILE 1609.344

@interface searchLocationViewController ()
{
    BOOL stopLocMgr;

    GMSMarker *marker;
    CLLocation *myCurrLoc;
    MBProgressHUD *HUD,*HUD2;
}
@end

@implementation searchLocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:35/255.0 green:35/255.0 blue:35/255.0 alpha:1];

    
    
    searchAddrLbl.text=_addrName;
    
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
    
    self.locationManager.delegate = self;
    _mapView.delegate=self;
    _mapView.settings.compassButton = YES;
    _mapView.settings.myLocationButton = YES;
    // Check for iOS 8. Without this guard the code will crash with "unknown selector" on iOS 7.
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    [self.locationManager startUpdatingLocation];
    
    marker = [[GMSMarker alloc] init];
    //    marker.icon = [UIImage imageNamed:@"myLocatnMarkerImg"];
    marker.map = _mapView;
}





#pragma mark - CLLocationManagerDelegate

#pragma mark Location Manager Delegate


- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    if (stopLocMgr==NO) {
        
        HUD=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
        UIFont * myFont = [UIFont systemFontOfSize:13];
        HUD.labelFont=myFont;
        HUD.labelText=[NSString stringWithFormat:@"Fetching results..."];
        
        
    stopLocMgr=YES;
    
    CLLocation * currentLocation = [locations lastObject];
    
    
    latitude =currentLocation.coordinate.latitude;
    longitude =currentLocation.coordinate.longitude;
    latStr=[NSString stringWithFormat:@"%f",latitude];
    longStr=[NSString stringWithFormat:@"%f",longitude];
    camera = [GMSCameraPosition cameraWithLatitude:latitude
                                         longitude:longitude
                                              zoom:14];
    
    _mapView.camera=camera;
    _mapView.delegate=self;
    myCurrLoc=[[CLLocation alloc]initWithLatitude:latitude longitude:longitude];
    CLLocationCoordinate2D newPos = CLLocationCoordinate2DMake(latitude, longitude);
    marker.position=newPos;
        
        
        
        CLGeocoder *geocoder = [[CLGeocoder alloc] init];
        [geocoder reverseGeocodeLocation:myCurrLoc completionHandler:^(NSArray *placemarks, NSError *error)
         {
             NSLog(@"Found placemarks: %@, error: %@", placemarks, error);
             if (error == nil && [placemarks count] > 0)
             {
                 CLPlacemark *placemark = [placemarks lastObject];
                 
                 // strAdd -> take bydefault value nil
                 NSString *strAdd = nil;
                 
//                 if ([placemark.subThoroughfare length] != 0)
//                 {
//                     strAdd = placemark.subThoroughfare;
//                 }
//                 if ([placemark.thoroughfare length] != 0)
//                 {
//                     // strAdd -> store value of current location
//                     if ([strAdd length] != 0)
//                         strAdd = [NSString stringWithFormat:@"%@, %@",strAdd,[placemark thoroughfare]];
//                     else
//                     {
//                         // strAdd -> store only this value,which is not null
//                         strAdd = placemark.thoroughfare;
//                     }
//                 }
                 
//                 if ([placemark.postalCode length] != 0)
//                 {
//                     if ([strAdd length] != 0)
//                         strAdd = [NSString stringWithFormat:@"%@, %@",strAdd,[placemark postalCode]];
//                     else
//                         strAdd = placemark.postalCode;
//                 }
                 
                 if ([placemark.locality length] != 0)
                 {
                     if ([strAdd length] != 0)
                         strAdd = [NSString stringWithFormat:@"%@, %@",strAdd,[placemark locality]];
                     else
                         strAdd = placemark.locality;
                 }
                 
//                 if ([placemark.administrativeArea length] != 0)
//                 {
//                     if ([strAdd length] != 0)
//                         strAdd = [NSString stringWithFormat:@"%@, %@",strAdd,[placemark administrativeArea]];
//                     else
//                         strAdd = placemark.administrativeArea;
//                 }
                 
                 if ([placemark.country length] != 0)
                 {
                     if ([strAdd length] != 0)
                         strAdd = [NSString stringWithFormat:@"%@, %@",strAdd,[placemark country]];
                     else
                         strAdd = placemark.country;
                 }
                 
                 searchAddrLbl.text=strAdd;
                 
                  [HUD hide:YES];
             }
             else
             {
                 
                 UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Location Search" message:@"There occured some error finding name of your location" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                 [alert show];
                  [HUD hide:YES];
             }
         }];
}
    
//    [self getAddressFromLatLong:myCurrLoc];
    
    
}

- (void)mapView:(GMSMapView *)mapView didTapAtCoordinate:(CLLocationCoordinate2D)coordinate
{
    HUD=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    UIFont * myFont = [UIFont systemFontOfSize:13];
    HUD.labelFont=myFont;
    HUD.labelText=[NSString stringWithFormat:@"Fetching results..."];
    
    
    NSLog(@"You tapped at %f,%f", coordinate.latitude, coordinate.longitude);
    latStr=[NSString stringWithFormat:@"%f",coordinate.latitude];
    longStr=[NSString stringWithFormat:@"%f",coordinate.longitude];
    CLLocationCoordinate2D newPos = CLLocationCoordinate2DMake(coordinate.latitude, coordinate.longitude);
    GMSCameraUpdate *updatedCamera = [GMSCameraUpdate setTarget:newPos zoom:14];
    [_mapView animateWithCameraUpdate:updatedCamera];
    marker.position=newPos;
    myCurrLoc=[[CLLocation alloc]initWithLatitude:coordinate.latitude longitude:coordinate.longitude];
    
    
    
    
    
    
    
    
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    
    
    [geocoder reverseGeocodeLocation:myCurrLoc completionHandler:^(NSArray *placemarks, NSError *error)
     {
         NSLog(@"Found placemarks: %@, error: %@", placemarks, error);
         if (error == nil && [placemarks count] > 0)
         {
             CLPlacemark *placemark = [placemarks lastObject];
             
             // strAdd -> take bydefault value nil
             NSString *strAdd = nil;
             
             if ([placemark.subThoroughfare length] != 0)
             {
                 strAdd = placemark.subThoroughfare;
             }
             if ([placemark.thoroughfare length] != 0)
             {
                 // strAdd -> store value of current location
                 if ([strAdd length] != 0)
                     strAdd = [NSString stringWithFormat:@"%@, %@",strAdd,[placemark thoroughfare]];
                 else
                 {
                     // strAdd -> store only this value,which is not null
                     strAdd = placemark.thoroughfare;
                 }
             }
             
//             if ([placemark.postalCode length] != 0)
//             {
//                 if ([strAdd length] != 0)
//                     strAdd = [NSString stringWithFormat:@"%@, %@",strAdd,[placemark postalCode]];
//                 else
//                     strAdd = placemark.postalCode;
//             }
             
             if ([placemark.locality length] != 0)
             {
                 if ([strAdd length] != 0)
                     strAdd = [NSString stringWithFormat:@"%@, %@",strAdd,[placemark locality]];
                 else
                     strAdd = placemark.locality;
             }
             
//             if ([placemark.administrativeArea length] != 0)
//             {
//                 if ([strAdd length] != 0)
//                     strAdd = [NSString stringWithFormat:@"%@, %@",strAdd,[placemark administrativeArea]];
//                 else
//                     strAdd = placemark.administrativeArea;
//             }
             
//             if ([placemark.country length] != 0)
//             {
//                 if ([strAdd length] != 0)
//                     strAdd = [NSString stringWithFormat:@"%@, %@",strAdd,[placemark country]];
//                 else
//                     strAdd = placemark.country;
//             }
             
             searchAddrLbl.text=strAdd;

             
         }
         else
         {
             
             UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Location Search" message:@"There occured some error finding name of your location" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
             [alert show];
         }
         
         [HUD hide:YES];
         
     }];

    
    
    
    
    
}



-(IBAction)doneBtnActn:(id)sender
{
    
    
    HUD2=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    UIFont * myFont = [UIFont systemFontOfSize:13];
    HUD2.labelFont=myFont;
    HUD2.labelText=[NSString stringWithFormat:@"Fetching results..."];
    
    NSString * strAdd = searchAddrLbl.text;
    [HUD hide:YES];
    if ([_isComingFrmScreen isEqualToString:@"1"]) {
        
        [self.delegate enteredAddress:self didFinishEnteringItem:strAdd : latStr : longStr];
        [self dismissViewControllerAnimated:YES completion:nil];
        
    }
    else if ([_isComingFrmScreen isEqualToString:@"0"])
    {
        [self.delegate enteredAddress:self didFinishEnteringItem:strAdd : latStr : longStr];
        [self.navigationController popViewControllerAnimated:YES];
        
    }
    else if ([_isComingFrmScreen isEqualToString:@"2"]) {
        
        [self.delegate enteredAddress:self didFinishEnteringItem:strAdd : latStr : longStr];
        [self dismissViewControllerAnimated:YES completion:nil];
        
    }

    
//    [self.locationManager stopUpdatingLocation];
//    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
//
//
//    [geocoder reverseGeocodeLocation:myCurrLoc completionHandler:^(NSArray *placemarks, NSError *error)
//     {
//         NSLog(@"Found placemarks: %@, error: %@", placemarks, error);
//         if (error == nil && [placemarks count] > 0)
//         {
//             CLPlacemark *placemark = [placemarks lastObject];
//             
//             // strAdd -> take bydefault value nil
//             NSString *strAdd = nil;
//             
//             if ([placemark.subThoroughfare length] != 0)
//             {
//                 strAdd = placemark.subThoroughfare;
//             }
//             if ([placemark.thoroughfare length] != 0)
//             {
//                 // strAdd -> store value of current location
//                 if ([strAdd length] != 0)
//                     strAdd = [NSString stringWithFormat:@"%@, %@",strAdd,[placemark thoroughfare]];
//                 else
//                 {
//                     // strAdd -> store only this value,which is not null
//                     strAdd = placemark.thoroughfare;
//                 }
//             }
//             
//             if ([placemark.postalCode length] != 0)
//             {
//                 if ([strAdd length] != 0)
//                     strAdd = [NSString stringWithFormat:@"%@, %@",strAdd,[placemark postalCode]];
//                 else
//                     strAdd = placemark.postalCode;
//             }
//             
//             if ([placemark.locality length] != 0)
//             {
//                 if ([strAdd length] != 0)
//                     strAdd = [NSString stringWithFormat:@"%@, %@",strAdd,[placemark locality]];
//                 else
//                     strAdd = placemark.locality;
//             }
//             
//             if ([placemark.administrativeArea length] != 0)
//             {
//                 if ([strAdd length] != 0)
//                     strAdd = [NSString stringWithFormat:@"%@, %@",strAdd,[placemark administrativeArea]];
//                 else
//                     strAdd = placemark.administrativeArea;
//             }
//             
//             if ([placemark.country length] != 0)
//             {
//                 if ([strAdd length] != 0)
//                     strAdd = [NSString stringWithFormat:@"%@, %@",strAdd,[placemark country]];
//                 else
//                     strAdd = placemark.country;
//             }
//             
////             searchAddrLbl.text=strAdd;
//             strAdd = searchAddrLbl.text;
//              [HUD hide:YES];
//             if ([_isComingFrmScreen isEqualToString:@"1"]) {
//                 
//                 [self.delegate enteredAddress:self didFinishEnteringItem:strAdd : latStr : longStr];
//                 [self dismissViewControllerAnimated:YES completion:nil];
//
//             }
//             else if ([_isComingFrmScreen isEqualToString:@"0"])
//             {
//                 [self.delegate enteredAddress:self didFinishEnteringItem:strAdd : latStr : longStr];
//                 [self.navigationController popViewControllerAnimated:YES];
//             
//             }
//             else if ([_isComingFrmScreen isEqualToString:@"2"]) {
//                 
//                 [self.delegate enteredAddress:self didFinishEnteringItem:strAdd : latStr : longStr];
//                 [self dismissViewControllerAnimated:YES completion:nil];
//                 
//             }
//            
//         }
//         else
//         {
//         
//             UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Location Search" message:@"There occured some error finding name of your location" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
//             [alert show];
//              [HUD hide:YES];
//         }
//     }];

}


-(IBAction)searchBtnActn:(id)sender
{
    [addrTxtFld resignFirstResponder];
//
    HUD=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    UIFont * myFont = [UIFont fontWithName:@"Avenir Next Regular" size:13];
    HUD.labelFont=myFont;
    HUD.labelText=[NSString stringWithFormat:@"Fetching results..."];
    
    NSString *location =addrTxtFld.text;
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    
    [geocoder geocodeAddressString:location
                 completionHandler:^(NSArray *placemarks, NSError *error){
                     if (!error) {
                         if (placemarks && placemarks.count > 0) {
                             CLPlacemark *placemark = [placemarks objectAtIndex:0];
                             CLLocation *location = placemark.location;
                             CLLocationCoordinate2D newcoordinate = location.coordinate;
                             //                         NSLog(@"coordinate = (%f, %f)", coordinate.latitude, coordinate.longitude);
                             GMSCameraUpdate *updatedCamera = [GMSCameraUpdate setTarget:newcoordinate zoom:14];
                             [_mapView animateWithCameraUpdate:updatedCamera];
                             marker.position=newcoordinate;
                             
                             
                             
                             latStr=[NSString stringWithFormat:@"%f",location.coordinate.latitude];
                             longStr=[NSString stringWithFormat:@"%f",location.coordinate.longitude];
                             [HUD hide:YES];
                         }
                         else
                         {
                             [HUD hide:YES];
                             UIAlertView *alert =[[UIAlertView alloc]initWithTitle:nil message:@"No results found." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                             [alert show];
                             
                         }
                         
                     }
                     else
                     {
                         [HUD hide:YES];
                         UIAlertView *alert =[[UIAlertView alloc]initWithTitle:@"OOPS" message:@"There was error with the address you entered. Please try again." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                         [alert show];
                     }
                 }
     ];
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (IBAction)backAction:(id)sender
{
    if ([_isComingFrmScreen isEqualToString:@"1"]) {
        
        [self dismissViewControllerAnimated:YES completion:nil];
        
    }
    else if ([_isComingFrmScreen isEqualToString:@"0"])
    {
        [self.navigationController popViewControllerAnimated:YES];
        
    }
    else if ([_isComingFrmScreen isEqualToString:@"2"])
    {
        [self dismissViewControllerAnimated:YES completion:nil];

    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}




@end
