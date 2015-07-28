//
//  EventDetailViewController.m
//  Seekly
//
//  Created by Deepinder singh on 30/06/15.
//  Copyright (c) 2015 Deepinder singh. All rights reserved.
//

#import "EventDetailViewController.h"

#define METERS_PER_MILE 1609.344


@interface EventDetailViewController ()
{
    MBProgressHUD *HUD;
    NSDictionary *responseDict;
    NSDictionary *dict;
    int pageIndex;

}
@end

@implementation EventDetailViewController

@synthesize EventID,imgPath,SelectedEvent;

- (void)viewDidLoad {
    [super viewDidLoad];

    self.scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width, 910);
    self.scrollView.backgroundColor = [UIColor whiteColor];
    self.friendzScroll.contentSize = CGSizeMake(700, _friendzScroll.frame.size.height);
    self.friendzScroll.backgroundColor = [UIColor clearColor];

    [ActionBtn addTarget:self action:@selector(SendInvitation) forControlEvents:UIControlEventTouchUpInside];
    [self performSelector:@selector(getDetail)];
    
    eventTitleLbl.text = [NSString stringWithFormat:@"%@",[SelectedEvent valueForKey:@"event_name"]];
    locLbl.text = [NSString stringWithFormat:@"%@",[SelectedEvent valueForKey:@"event_location"]];
    timeLbl.text = [NSString stringWithFormat:@"%@",[SelectedEvent valueForKey:@"event_time"]];
    _discriptionTxtView.text = [NSString stringWithFormat:@"%@",[SelectedEvent valueForKey:@"event_description"]];
    
    
    
    
    NSURL *url = [NSURL URLWithString:imgPath];
    
    __block UIActivityIndicatorView *activityIndicator;
    __weak UIImageView *weakImageView = eventImgView;
    [eventImgView sd_setImageWithURL:url
               placeholderImage:nil
                        options:SDWebImageProgressiveDownload
                       progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                           if (!activityIndicator) {
                               [weakImageView addSubview:activityIndicator = [UIActivityIndicatorView.alloc initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray]];
                               activityIndicator.center = weakImageView.center;
                               [activityIndicator startAnimating];
                           }
                       }
                      completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                          [activityIndicator removeFromSuperview];
                          activityIndicator = nil;
                          if (!image)
                          {
                              eventImgView.image = [UIImage imageNamed:@"pic_01"];
                          }
                      }];

    
    [self zoomToLocation];
}

- (IBAction)addButtonTouchUpInside:(id)sender
{
    NSArray *randomLocations = [[NSArray alloc] initWithArray:[self randomCoordinatesGenerator:1]];
}


- (NSArray *)randomCoordinatesGenerator:(int)numberOfCoordinates
{
    MKCoordinateRegion visibleRegion = self.mapView.region;
    visibleRegion.span.latitudeDelta *= 0.8;
    visibleRegion.span.longitudeDelta *= 0.8;
    
    numberOfCoordinates = MAX(0,numberOfCoordinates);
    NSMutableArray *coordinates = [[NSMutableArray alloc] initWithCapacity:numberOfCoordinates];
    
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    numberFormatter.numberStyle = NSNumberFormatterDecimalStyle;
    NSLog(@"ltaitude--->%@  longitude--->%@",[dict valueForKey:@"latitude"],[dict valueForKey:@"longitude"]);
    
    float latitude = [numberFormatter numberFromString:[NSString stringWithFormat:@"%@",[dict valueForKey:@"latitude"]]].floatValue;
    float longitude = [numberFormatter numberFromString:[NSString stringWithFormat:@"%@",[dict valueForKey:@"longitude"]]].floatValue;
    
    CLLocation *loc = [[CLLocation alloc]initWithLatitude:latitude longitude:longitude];
    
    [coordinates addObject:loc];
    
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(loc.coordinate, 1500, 1500);
    [self.mapView setRegion:[self.mapView regionThatFits:region] animated:YES];
    
    // Add an annotation
    MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
    point.coordinate = loc.coordinate;
    point.title = @"Where am I?";
    point.subtitle = @"I'm here!!!";
    
    UIImage *image = [UIImage imageNamed:@"map"];
    
    [self.mapView removeAnnotations:self.mapView.annotations];
    [self.mapView removeOverlays:self.mapView.overlays];
    
    // MKAnnotationView *annotationView;
    //    annotationView.image = [UIImage imageNamed:@"location_map-icon"];
    //
    
    [self.mapView addAnnotation:point];
    [[self.mapView viewForAnnotation:point] setImage:image];
    
    
    // [self.mapView viewForAnnotation:annotationView];
    
    
    return  coordinates;
}


- (void)zoomToLocation
{
    //    self.mapView.showsUserLocation=TRUE;
    
    CLLocationCoordinate2D zoomLocation;
    
    //30.70465 76.72000
    zoomLocation.latitude = 30.70465;
    
    zoomLocation.longitude= 76.72000;
    
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 18.5*METERS_PER_MILE,18.5*METERS_PER_MILE);
    
    [self.mapView setRegion:viewRegion animated:YES];
    [self.mapView regionThatFits:viewRegion];
}


-(IBAction) getDetail
{
//    HUD=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://seekly.azurewebsites.net/api/Event/%@",EventID]] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:120.0];
    
    [NSURLConnection sendAsynchronousRequest:urlRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *responce,NSData *data, NSError *connectionError){
        NSError *error = nil;
        if (![data isKindOfClass:[NSNull class]] && data!= nil)
        {
            dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
            if (error)
            {
                NSLog(@"fail  ==%@",error);
            }
            else
            {
                NSLog(@"success  ==%@",dict);
                [HUD hide:YES];
                if (dict.count > 0)
                {
                    dict = [dict valueForKey:@"EventInfo"];
                    pageIndex = 0 ;
                    
                    slotLbl.text = [NSString stringWithFormat:@"%@ out of %@",[dict valueForKey:@"total_user_Joined"],[dict valueForKey:@"total_user_Invited"]];
                    [self addButtonTouchUpInside:self];
                    
                }
            }
        }
    }];
}

-(IBAction) SendInvitation
{
    HUD=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSURL *url = [NSURL URLWithString:@"http://seekly.azurewebsites.net/api/EventInvitation/EventInvitation"];
    NSString *uid=[[NSUserDefaults standardUserDefaults]valueForKey:@"UID"];
    
    // Create the request
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setRequestMethod:@"POST"];
    [request setPostValue:uid forKey:@"user_id_whos_event"];
    [request setPostValue:[NSString stringWithFormat:@"%@",[dict  objectForKey:@"Status"]] forKey:@"event_id"];
    [request setPostValue:[NSString stringWithFormat:@"%@",[dict  objectForKey:@"Status"]] forKey:@"user_id_whos_invited"];

    [request setDelegate:self];
    [request startSynchronous];
    
    NSError *error = [request error];
    if (!error)
    {
        NSString *response = [request responseString];
        response=  [response stringByReplacingOccurrencesOfString:@"\\" withString:@""];
        NSLog(@"%@",response);
        
        dict = [response JSONValue];
        NSLog(@"dict is :%@",dict);
        if ([[NSString stringWithFormat:@"%@",[dict  objectForKey:@"Status"]] isEqual: @"1"])
        {
            [HUD hide:YES];
            dict = [[responseDict valueForKey:@"lstEvents"] mutableCopy];
            [ActionBtn setTitle:@"Decline" forState:UIControlStateNormal];
            ActionBtn.backgroundColor = [UIColor redColor];
            [ActionBtn addTarget:self action:@selector(DeclineInvitation) forControlEvents:UIControlEventTouchUpInside];
        } else {
            [HUD hide:YES];
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Exception" message:[NSString stringWithFormat:@"%@",[responseDict  objectForKey:@"Exception"]] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
        }
    }
}

-(IBAction) DeclineInvitation
{
    
    HUD=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSURL *url = [NSURL URLWithString:@"http://seekly.azurewebsites.net/api/EventDecline/EventDecline"];
    
    // Create the request
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setRequestMethod:@"POST"];
    [request setPostValue:@"cdadfd95-bbd2-40a4-93c7-30015e633a40" forKey:@"user_id_whos_event"];
    [request setPostValue:@"9122cab3-6038-45dd-af36-e689dab80992" forKey:@"event_id"];
    [request setPostValue:@"bd959c1f-d076-40e2-835d-ea665f9dac65" forKey:@"user_id_whos_invited"];
    [request setDelegate:self];
    [request startSynchronous];
    
    NSError *error = [request error];
    if (!error)
    {
        NSString *response = [request responseString];
        response=  [response stringByReplacingOccurrencesOfString:@"\\" withString:@""];
        NSLog(@"%@",response);
        
        responseDict = [response JSONValue];
        NSLog(@"dict is :%@",responseDict);
        if ([[NSString stringWithFormat:@"%@",[responseDict  objectForKey:@"Status"]] isEqual: @"1"])
        {
            [HUD hide:YES];
            [ActionBtn setTitle:@"Join" forState:UIControlStateNormal];
            ActionBtn.backgroundColor = [UIColor colorWithRed:129.0 green:175.0 blue:81.0 alpha:0];
            [ActionBtn addTarget:self action:@selector(SendInvitation) forControlEvents:UIControlEventTouchUpInside];
        } else {
            [HUD hide:YES];
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Exception" message:[NSString stringWithFormat:@"%@",[responseDict  objectForKey:@"Exception"]] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
        }
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:NO];
}

- (void) callBack
{
    [self.navigationController popViewControllerAnimated:NO];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)EventSettingAction:(id)sender
{
    EventEditViewController *ObjEdit = [self.storyboard instantiateViewControllerWithIdentifier:@"EventEditViewControllerID"];
    ObjEdit.SelectedEvent = [SelectedEvent mutableCopy];
    [self.navigationController pushViewController:ObjEdit animated:YES];
}
@end
