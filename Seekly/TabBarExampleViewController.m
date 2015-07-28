//
//  TabBarExampleViewController.m
//  JDFPeekaboo
//
//  Created by Joe Fryer on 02/03/2015.
//  Copyright (c) 2015 Joe Fryer. All rights reserved.
//

#import "TabBarExampleViewController.h"
// Peekaboo
#import "JDFPeekabooCoordinator.h"

// View Controllers
#import "JDFDetailViewController.h"

#import "slideViewController.h"
#import "CreateEventViewController.h"
#import "SearchViewController.h"
#import "EventDetailViewController.h"
#import "OCMapViewSampleHelpAnnotation.h"

static NSString *const kTYPE1 = @"Event Location";
static NSString *const kTYPE2 = @"Orange";
static CGFloat kDEFAULTCLUSTERSIZE = 0;


#define METERS_PER_MILE 1609.344


static NSString *const JDFSampleViewControllerCellIdentifier = @"JDFSampleViewControllerCellIdentifier";


@interface TabBarExampleViewController ()
{
    UIImage *eventImg,*logoImg;
    
    IBOutlet UIView *searchBack;
    IBOutlet UIButton *mapBtn;
    NSCache *Eventcache;
    NSMutableArray *Today;
    NSMutableArray *Tomorrow;
    NSMutableArray *Later;
    
    BOOL showMessage;


    IBOutlet UILabel *titleLbl;
    IBOutlet UIPageControl *pageController;
    MBProgressHUD *HUD;
    NSDictionary *responseDict;
    NSDictionary *dict;
    NSMutableArray *allEventArray;
    UIImage *img;
}

// Views
@property (nonatomic, weak) IBOutlet UITableView *tblView;
@property (nonatomic, weak) IBOutlet UITabBar *tabBar;

// Peekaboo
@property (nonatomic, strong) JDFPeekabooCoordinator *scrollCoordinator;
@property (nonatomic,retain) UIRefreshControl *refreshControl;

//@property (nonatomic, strong) slideViewController *slideMenuController

@end

@implementation TabBarExampleViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [mapViewContainer setHidden:YES];

    Eventcache = [[NSCache alloc]init];

    screenSize=[[UIScreen mainScreen] bounds];
    pageVal = 0;
    self.pageControl.currentPage = pageVal;
//    BlankEventTitle.text = @"";
    
    [MenuBtn addTarget:self action:@selector(toggleSlideAnimated:) forControlEvents:UIControlEventTouchUpInside];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refresh) name:@"reloadTbl" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(navigateToNextClasses:) name:@"navigateToNextClasses" object:nil];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    UIColor *blueColour = [UIColor blackColor];
    self.navigationController.navigationBarHidden = YES;
    self.tabBarController.tabBar.barTintColor = blueColour;
    self.tabBarController.tabBar.tintColor = [UIColor whiteColor];
    
//    [self refresh];
    
    UISwipeGestureRecognizer * swipeleft=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeleft:)];
    swipeleft.direction=UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:swipeleft];
    
    // SwipeRight
    
    UISwipeGestureRecognizer * swiperight=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swiperight:)];
    swiperight.direction=UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swiperight];
    
    objMap = [self.storyboard instantiateViewControllerWithIdentifier:@"EventsOnMap"];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    UIImage* tabBarBackground = [UIImage imageNamed:@"tabBack001"];
    [self.tabBarController.tabBar setBackgroundImage:tabBarBackground];
    [alertBackView setHidden:YES];
    showMessage = NO;
//    homeSelected = YES;
//    UpcomingSelected = NO;
//    AwaitingSelected = NO;
//    pastSelected = NO;
}




- (BOOL)isEndDateIsSmallerThanCurrent:(NSDate *)checkEndDate
{
    NSDate* enddate = checkEndDate;
    NSDate* currentdate = [NSDate date];
    NSTimeInterval distanceBetweenDates = [enddate timeIntervalSinceDate:currentdate];
    double secondsInMinute = 60;
    NSInteger secondsBetweenDates = distanceBetweenDates / secondsInMinute;
    
    if (secondsBetweenDates == 0)
        return YES;
    else if (secondsBetweenDates < 0)
        return YES;
    else
        return NO;
}



-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    if (homeSelected == YES) {
        [self performSelector:@selector(getEvents)];
  
    } else if (UpcomingSelected == YES)
    {
        titleLbl.text = @"UPCOMING";
    } else if (AwaitingSelected == YES)
    {
        titleLbl.text = @"AWAITING";
    }  else if (pastSelected == YES)
    {
        titleLbl.text = @"PAST";
    }
    else if (groupSelected == YES)
    {
        titleLbl.text = @"GROUP";
    }

}

-(void) getEvents
{
    HUD=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
     [alertBackView setHidden:YES];
    
#if TARGET_IPHONE_SIMULATOR
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"30.7245916,76.6921956"] forKey:@"latLong"];
    //Apps+Maven/@ 30.7245916 , 76.6921956
    
#else
    
#endif

    NSURL *url = [NSURL URLWithString:@"http://seekly.azurewebsites.net/api/EventFetch/GetEvents"];
    NSString *uid=[[NSUserDefaults standardUserDefaults]valueForKey:@"UID"];
    
    // Create the request
    NSString *latlongStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"latLong"];
    NSArray *array = [ latlongStr componentsSeparatedByString:@","];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setRequestMethod:@"POST"];
    [request setPostValue:uid forKey:@"userid"];
    [request setPostValue:[NSString stringWithFormat:@"%@",array [0]] forKey:@"latitude"];
    [request setPostValue:[NSString stringWithFormat:@"%@",array [1]]  forKey:@"longitude"];
    [request setPostValue:[NSString stringWithFormat:@"%i",[radiusStr intValue]] forKey:@"radius"];
    [request setPostValue:@"K" forKey:@"distanceUnit"];

    [request setDelegate:self];
    [request startSynchronous];
    
    NSError *error = [request error];
    if (!error)
    {
//        BlankEventTitle.text = @"Swipe to the right and see if there is something going on later,or create an event yourself today";
        NSString *response = [request responseString];
        response=  [response stringByReplacingOccurrencesOfString:@"\\" withString:@""];
        NSDate *date = [NSDate date];

        responseDict = [response JSONValue];
        NSLog(@"dict is :%@",responseDict);
        
        if ([[NSString stringWithFormat:@"%@",[responseDict  objectForKey:@"Status"]] isEqual: @"1"])
        {
            dict = [[responseDict valueForKey:@"lstEvents"] mutableCopy];
            allEventArray = [[responseDict valueForKey:@"lstEvents"] mutableCopy];
            
            NSCalendar* calendar = [NSCalendar currentCalendar];
            NSDateComponents* comps = [calendar components:(NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit)
                                                  fromDate:date];
            NSDate* theMidnightHour = [calendar dateFromComponents:comps];
            
            // set up a localized date formatter so we can see the answers are right!
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
            [dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
            
            
            Today = [[NSMutableArray alloc]init];
            Tomorrow = [[NSMutableArray alloc]init];
            Later = [[NSMutableArray alloc]init];

            for (int i = 0; i < [allEventArray count]; i++)
            {
                
                NSString *postTime;
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                formatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ssZ";
                formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
                NSDate *date = [formatter dateFromString:[[allEventArray valueForKey:@"event_date"]objectAtIndex:i]];
                NSLog(@"%@", date);
                
                NSDate *baseDate = [NSDate date];
                
                NSArray *datesToCompare = [NSArray arrayWithObjects:date,nil];
                
                
                // determine the NSDate for midnight of the base date:
                NSCalendar* calendar = [NSCalendar currentCalendar];
                NSDateComponents* comps = [calendar components:(NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit)
                                                      fromDate:baseDate];
                NSDate* theMidnightHour = [calendar dateFromComponents:comps];
                
                // set up a localized date formatter so we can see the answers are right!
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
                [dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
                
                // determine which dates in an array are on the same day as the base date:
                for (NSDate *date in datesToCompare) {
                    NSTimeInterval interval = [date timeIntervalSinceDate:theMidnightHour];
                    if (interval >= 0 && interval < 60*60*24) {
                        
                        postTime = @"today";
                        NSLog(@"%@ is on the same day ", [dateFormatter stringFromDate:date]);
                        
                    }
                    else if (interval >= 60*60*24 && interval < 120*60*24) {
                        postTime = @"tomorrow";
                        NSLog(@"%@ is on tomorrow ", [dateFormatter stringFromDate:date]);
                    }
                    else {
                        postTime = @"later";
                        NSLog(@"%@ is on later ", [dateFormatter stringFromDate:date]);
                    }
                }

                NSLog(@"After ->%@",postTime);
                if ([postTime containsString:@"today"])
                {
                    
                    [Today addObject:[allEventArray objectAtIndex:i]];
                    NSLog(@"today");
                    

                } else if ([postTime containsString:@"tomorrow"])
                {
                    [Tomorrow addObject:[allEventArray objectAtIndex:i]];
                    NSLog(@"tomorrow %@",Tomorrow);

                } else if ([postTime containsString:@"later"])
                {
                                        [Later addObject:[allEventArray objectAtIndex:i]];
                    NSLog(@"later %@",Later);
                    

                }
                
                showMessage = YES;
                
            }
            
            if ([Today count]>0) {
                allEventArray  = [Today mutableCopy];
                titleLbl.text = @"TODAY";
                self.pageControl.currentPage = 0;
            } else if ([Tomorrow count]>0)
            {
                allEventArray  = [Tomorrow mutableCopy];
                titleLbl.text = @"TOMORROW";
                self.pageControl.currentPage = 1;
            } else if ([Later count]>0)
            {
                allEventArray  = [Later mutableCopy];
                titleLbl.text = @"LATER";
                self.pageControl.currentPage = 2;
            }

            [self.tblView reloadData];

            [HUD hide:YES];
        } else {
            [HUD hide:YES];
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Exception" message:[NSString stringWithFormat:@"%@",[responseDict  objectForKey:@"Exception"]] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
        }
    }
}

-(NSString*)getPostTime: (NSInteger)index1
{
    
//    NSDate* currentTime = [NSDate date];
//    NSLog(@"%@", currentTime);
//    
//    NSCalendar *calendar = [NSCalendar currentCalendar];
//    NSUInteger unitFlags = NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond;
//    NSDateComponents *components = [calendar components:unitFlags fromDate:currentTime toDate:date options:0];
//    
//    NSInteger year  = [components year];
//    NSInteger month = [components month];
//    NSInteger day   = [components day];
//    NSInteger hour  = [components hour];
//    NSInteger minute = [components minute];
//    NSInteger second   = [components second];
//    

//
//    if (year>0)
//    {
//        postTime = [NSString stringWithFormat:@"%ldy",(long)year];
//    }
//    else if (month>0)
//    {
//        postTime = [NSString stringWithFormat:@"%ldmonth",(long)month];
//    }
//    else if (day>0)
//    {
//        postTime = [NSString stringWithFormat:@"%ldd",(long)day];
//    }
//    else if (hour>0)
//    {
//        postTime = [NSString stringWithFormat:@"%ldh",(long)hour];
//    }
//    else if (minute>0)
//    {
//        postTime = [NSString stringWithFormat:@"%ldm",(long)minute];
//    }
//    else if (second>0)
//    {
//        postTime = [NSString stringWithFormat:@"%lds",(long)second];
//    }
//    
//     NSLog(@"%ld:%ld:%ld:%ld:%ld:%ld", (long)year, (long)month,(long)day,(long)hour, (long)minute,(long)second);
    
    NSString *postTime;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ssZ";
    formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    NSDate *date = [formatter dateFromString:[[allEventArray valueForKey:@"event_date"]objectAtIndex:index1]];
    NSLog(@"%@", date);

    NSDate *baseDate = [NSDate date];
    
    NSArray *datesToCompare = [NSArray arrayWithObjects:date,nil];
    
    
    // determine the NSDate for midnight of the base date:
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* comps = [calendar components:(NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit)
                                          fromDate:baseDate];
    NSDate* theMidnightHour = [calendar dateFromComponents:comps];
    
    // set up a localized date formatter so we can see the answers are right!
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
    
    // determine which dates in an array are on the same day as the base date:
    for (NSDate *date in datesToCompare) {
        NSTimeInterval interval = [date timeIntervalSinceDate:theMidnightHour];
        if (interval >= 0 && interval < 60*60*24) {
            
            postTime = @"today";
            NSLog(@"%@ is on the same day ", [dateFormatter stringFromDate:date]);
            
        }
        else if (interval >= 60*60*24 && interval < 120*60*24) {
            postTime = @"tomorrow";
            NSLog(@"%@ is on tomorrow ", [dateFormatter stringFromDate:date]);
        }
        else {
            postTime = @"later";
            NSLog(@"%@ is on later ", [dateFormatter stringFromDate:date]);
        }
    }
    
    return postTime;
}


-(NSDate *)dateWithOutTime:(NSDate *)datDate
{
    if( datDate == nil ) {
        datDate = [NSDate date];
    }
    NSDateComponents* comps = [[NSCalendar currentCalendar] components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:datDate];
    return [[NSCalendar currentCalendar] dateFromComponents:comps];
}


-(IBAction)ShowMapView:(id)sender
{
//    CGRect frame = self.tblView.frame;
//    
//    UIImage *unselected = [UIImage imageNamed:@"location_map-icon"] ;
//    UIImage *selected = [UIImage imageNamed:@"location_icon_header"] ;
//    
//    if (dict > 0) {
//        [alertBackView setHidden:YES];
//        if (frame.origin.y == 64) {
//            [mapViewContainer setHidden:NO];
//            [mapBtn setImage:unselected forState:UIControlStateNormal];
//            [UIView animateWithDuration:0.2 animations:^{
//                CGRect frame = self.tblView.frame;
//                frame.origin.y = 264;
//                self.tblView.frame = frame;
//                self.mapView.delegate = self;
//                self.mapView.clusterSize = kDEFAULTCLUSTERSIZE;
//                self.labelNumberOfAnnotations.text = @"Number of Annotations: 0";
//                
//                [self addButtonTouchUpInside:nil];
//
//            }];
//        } else {
//            [UIView animateWithDuration:0.2 animations:^{
//                [mapBtn setImage:selected forState:UIControlStateNormal];
//                CGRect frame = self.tblView.frame;
//                frame.origin.y = 64;
//                self.tblView.frame = frame;
//                [mapViewContainer setHidden:YES];
//            }];
//        }
//    } else
//    {
//        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"No event to show" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
//        [alert show];
//    }
    
    AppDelegate *appdel = (AppDelegate*)[UIApplication sharedApplication].delegate;
    appdel.eventsAvailable = [[NSMutableArray alloc]init];
    appdel.eventsAvailable = nil;
    appdel.eventsAvailable = [allEventArray mutableCopy];
    objMap.titlelabel.text = titleLbl.text;
    [self.navigationController pushViewController:objMap animated:NO];
    
}


- (void)zoomToLocation
{
    CLLocationCoordinate2D zoomLocation;
    
    //30.70465 76.72000
    zoomLocation.latitude = 30.70465;
    
    zoomLocation.longitude= 76.72000;
    
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 18.5*METERS_PER_MILE,18.5*METERS_PER_MILE);
    
    [self.mapView setRegion:viewRegion animated:YES];
    [self.mapView regionThatFits:viewRegion];
}


#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    }
    return YES;
}

// ==============================
#pragma mark - UI actions

//- (IBAction)removeButtonTouchUpInside:(id)sender
//{
//    [self.mapView removeAnnotations:self.mapView.annotations];
//    [self.mapView removeOverlays:self.mapView.overlays];
//    self.labelNumberOfAnnotations.text = @"Number of Annotations: 0";
//}

- (IBAction)addButtonTouchUpInside:(id)sender
{
    NSArray *randomLocations = [[NSArray alloc] initWithArray:[self randomCoordinatesGenerator:1]];
    NSMutableSet *annotationsToAdd = [[NSMutableSet alloc] init];
    
    for (CLLocation *loc in randomLocations) {
        OCMapViewSampleHelpAnnotation *annotation = [[OCMapViewSampleHelpAnnotation alloc] initWithCoordinate:loc.coordinate];
        [annotationsToAdd addObject:annotation];
        
        // add to group if specified
        if (annotationsToAdd.count < (randomLocations.count)/2.0)
        {
            annotation.groupTag = kTYPE1;
        }
        else
        {
            annotation.groupTag = kTYPE1;
        }
        
    }
    
    [self.mapView addAnnotations:[annotationsToAdd allObjects]];
    self.labelNumberOfAnnotations.text = [NSString stringWithFormat:@"Number of Annotations: %zd", [self.mapView.annotations count]];
}

//- (IBAction)clusteringButtonTouchUpInside:(UIButton *)sender
//{
//    if (self.mapView.clusteringEnabled) {
//        [sender setTitle:@"turn clustering on" forState:UIControlStateNormal];
//        [sender setTitle:@"turn clustering on" forState:UIControlStateSelected];
//        [sender setTitle:@"turn clustering on" forState:UIControlStateHighlighted];
//        self.mapView.clusteringEnabled = NO;
//    }
//    else{
//        [sender setTitle:@"turn clustering off" forState:UIControlStateNormal];
//        [sender setTitle:@"turn clustering off" forState:UIControlStateSelected];
//        [sender setTitle:@"turn clustering off" forState:UIControlStateHighlighted];
//        self.mapView.clusteringEnabled = YES;
//    }
//    
//    [self.mapView doClustering];
//    [self updateOverlays];
//}
//
//- (IBAction)addOneButtonTouchupInside:(id)sender
//{
//    NSArray *randomLocations = [[NSArray alloc] initWithArray:[self randomCoordinatesGenerator:1]];
//    CLLocationCoordinate2D loc = ((CLLocation *)[randomLocations objectAtIndex:0]).coordinate;
//    OCMapViewSampleHelpAnnotation *annotation = [[OCMapViewSampleHelpAnnotation alloc] initWithCoordinate:loc];
//    
//    [self.mapView addAnnotation:annotation];
//    self.labelNumberOfAnnotations.text = [NSString stringWithFormat:@"Number of Annotations: %zd", [self.mapView.annotations count]];
//}
//
//- (IBAction)changeClusterMethodButtonTouchUpInside:(UIButton *)sender
//{
//    if (self.mapView.clusteringMethod == OCClusteringMethodBubble) {
//        [sender setTitle:@"Bubble cluster" forState:UIControlStateNormal];
//        [sender setTitle:@"Bubble cluster" forState:UIControlStateSelected];
//        [sender setTitle:@"Bubble cluster" forState:UIControlStateHighlighted];
//        self.mapView.clusteringMethod = OCClusteringMethodGrid;
//    }
//    else{
//        [sender setTitle:@"Grid cluster" forState:UIControlStateNormal];
//        [sender setTitle:@"Grid cluster" forState:UIControlStateSelected];
//        [sender setTitle:@"Grid cluster" forState:UIControlStateHighlighted];
//        self.mapView.clusteringMethod = OCClusteringMethodBubble;
//    }
//    
//    [self.mapView doClustering];
//    [self updateOverlays];
//}
//
//- (IBAction)buttonGroupByTagTouchUpInside:(UIButton *)sender
//{
//    self.mapView.clusterByGroupTag = ! self.mapView.clusterByGroupTag;
//    if(self.mapView.clusterByGroupTag){
//        [sender setTitle:@"turn groups off" forState:UIControlStateNormal];
//        self.mapView.clusterSize = kDEFAULTCLUSTERSIZE * 2.0;
//    }
//    else{
//        [sender setTitle:@"turn groups on" forState:UIControlStateNormal];
//        self.mapView.clusterSize = kDEFAULTCLUSTERSIZE;
//    }
//    
//    [self.mapView doClustering];
//    [self updateOverlays];
//}

// ==============================
#pragma mark - map delegate

- (MKAnnotationView *)mapView:(MKMapView *)aMapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    MKAnnotationView *annotationView;
    
    // if it's a cluster
    if ([annotation isKindOfClass:[OCAnnotation class]]) {
        
        OCAnnotation *clusterAnnotation = (OCAnnotation *)annotation;
        
        annotationView = (MKAnnotationView *)[aMapView dequeueReusableAnnotationViewWithIdentifier:@"ClusterView"];
        if (!annotationView) {
            annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"ClusterView"];
            annotationView.canShowCallout = NO;
            annotationView.centerOffset = CGPointMake(0, -20);
        }
        
        // set title
        clusterAnnotation.title = @"Cluster";
        clusterAnnotation.subtitle = [NSString stringWithFormat:@"Containing annotations: %zd", [clusterAnnotation.annotationsInCluster count]];
        
        // set its image
        annotationView.image = [UIImage imageNamed:@"regular.png"];
        
        // change pin image for group
        if (self.mapView.clusterByGroupTag) {
            if ([clusterAnnotation.groupTag isEqualToString:kTYPE1]) {
                annotationView.image = [UIImage imageNamed:@"location_map-icon"];
            }
            else if([clusterAnnotation.groupTag isEqualToString:kTYPE1]){
                annotationView.image = [UIImage imageNamed:@"location_map-icon"];
            }
            clusterAnnotation.title = clusterAnnotation.groupTag;
        }
    }
    // If it's a single annotation
    else if([annotation isKindOfClass:[OCMapViewSampleHelpAnnotation class]]){
        OCMapViewSampleHelpAnnotation *singleAnnotation = (OCMapViewSampleHelpAnnotation *)annotation;
        annotationView = (MKAnnotationView *)[aMapView dequeueReusableAnnotationViewWithIdentifier:@"singleAnnotationView"];
        if (!annotationView) {
            annotationView = [[MKAnnotationView alloc] initWithAnnotation:singleAnnotation reuseIdentifier:@"singleAnnotationView"];
            annotationView.canShowCallout = YES;
            annotationView.centerOffset = CGPointMake(0, -20);
        }
        singleAnnotation.title = singleAnnotation.groupTag;
        
        if ([singleAnnotation.groupTag isEqualToString:kTYPE1]) {
            annotationView.image = [UIImage imageNamed:@"location_map-icon"];
        }
        else if([singleAnnotation.groupTag isEqualToString:kTYPE1]){
            annotationView.image = [UIImage imageNamed:@"location_map-icon"];
        }
    }
    // Error
    else{
        annotationView = (MKPinAnnotationView *)[aMapView dequeueReusableAnnotationViewWithIdentifier:@"errorAnnotationView"];
        if (!annotationView) {
            annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"errorAnnotationView"];
            annotationView.canShowCallout = NO;
            ((MKPinAnnotationView *)annotationView).pinColor = MKPinAnnotationColorRed;
        }
    }
    
    return annotationView;
}
//
//- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay
//{
//    MKCircle *circle = overlay;
//    MKCircleView *circleView = [[MKCircleView alloc] initWithCircle:overlay];
//    
//    if ([circle.title isEqualToString:@"background"])
//    {
//        circleView.fillColor = [UIColor yellowColor];
//        circleView.alpha = 0.25;
//    }
//    else if ([circle.title isEqualToString:@"helper"])
//    {
//        circleView.fillColor = [UIColor redColor];
//        circleView.alpha = 0.25;
//    }
//    else
//    {
//        circleView.strokeColor = [UIColor blackColor];
//        circleView.lineWidth = 0.5;
//    }
//    
//    return circleView;
//}
//
//- (void)mapView:(MKMapView *)aMapView regionDidChangeAnimated:(BOOL)animated
//{
//    [self.mapView doClustering];
//    [self updateOverlays];
//}
//
//- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views;
//{
//    [self updateOverlays];
//}

// ==============================
#pragma mark - logic

//
// Help method which returns an array of random CLLocations
// You can specify the number of coordinates by setting numberOfCoordinates
- (NSArray *)randomCoordinatesGenerator:(int)numberOfCoordinates
{
    MKCoordinateRegion visibleRegion = self.mapView.region;
    visibleRegion.span.latitudeDelta *= 0.8;
    visibleRegion.span.longitudeDelta *= 0.8;
    
    int max = 9999;
    numberOfCoordinates = MAX(0,numberOfCoordinates);
    NSMutableArray *coordinates = [[NSMutableArray alloc] initWithCapacity:numberOfCoordinates];
    
    
    for (int i = 0; i < [dict count]; i++)
    {
        NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
        numberFormatter.numberStyle = NSNumberFormatterDecimalStyle;
        NSLog(@"%@",[[dict valueForKey:@"latitude"]objectAtIndex:i]);
        float latitude = [numberFormatter numberFromString:[NSString stringWithFormat:@"%@",[[dict valueForKey:@"latitude"]objectAtIndex:i]]].floatValue;
        float longitude = [numberFormatter numberFromString:[NSString stringWithFormat:@"%@",[[dict valueForKey:@"longitude"]objectAtIndex:i]]].floatValue;
        
        CLLocation *loc = [[CLLocation alloc]initWithLatitude:latitude longitude:longitude];

        [coordinates addObject:loc];
    }
    return  coordinates;
}

//- (void)updateOverlays
//{
//    [self.mapView removeOverlays:self.mapView.overlays];
//    
//    for (OCAnnotation *annotation in self.mapView.displayedAnnotations) {
//        if ([annotation isKindOfClass:[OCAnnotation class]]) {
//            
//            // static circle size of cluster
//            CLLocationDistance clusterRadius = self.mapView.region.span.longitudeDelta * self.mapView.clusterSize * 111000 / 2.0f;
//            clusterRadius = clusterRadius * cos([annotation coordinate].latitude * M_PI / 180.0);
//            
//            MKCircle *circle = [MKCircle circleWithCenterCoordinate:annotation.coordinate radius:clusterRadius];
//            [circle setTitle:@"background"];
//            [self.mapView addOverlay:circle];
//            
//            MKCircle *circleLine = [MKCircle circleWithCenterCoordinate:annotation.coordinate radius:clusterRadius];
//            [circleLine setTitle:@"line"];
//            [self.mapView addOverlay:circleLine];
//        }
//    }
//}

-(IBAction)toggleSlideAnimated:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"toggleLeftPan" object:nil];
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    return YES;
}

// Implement Gesture Method

-(IBAction)swipeleft:(UISwipeGestureRecognizer*)gestureRecognizer
{
    //Do what you want here
    if (homeSelected == YES) {
        pageVal = pageVal + 1;
        if (pageVal == 3) {
            pageVal = 0;
        }
        if (pageVal == 0)
        {
            titleLbl.text = @"TODAY";
            allEventArray = [Today mutableCopy];
        }
        else if (pageVal == 1) {
            titleLbl.text = @"TOMORROW";
            allEventArray = [Tomorrow mutableCopy];
        }
        else if (pageVal == 2) {
            titleLbl.text = @"LATER";
            allEventArray = [Later mutableCopy];
        }
        
        CATransition *transition = [CATransition animation];
        transition.duration = 0.3;
        transition.type = kCATransitionPush;
        transition.subtype = kCATransitionFromRight;
        [self.tblView.layer addAnimation:transition
                                  forKey:kCATransition];
        
        [self.tblView  reloadData];
        
        self.pageControl.currentPage = pageVal;
    }

}

-(IBAction)swiperight:(UISwipeGestureRecognizer*)gestureRecognizer
{
    //Do what you want here
    
    if (homeSelected == YES) {
        pageVal = pageVal - 1;
        
        if (pageVal == -1) {
            pageVal = 2;
        }
        if (pageVal == 0)
        {
            titleLbl.text = @"TODAY";
            allEventArray = [Today mutableCopy];
        }
        else if (pageVal == 1) {
            titleLbl.text = @"TOMORROW";
            allEventArray = [Tomorrow mutableCopy];
        }
        else if (pageVal == 2) {
            titleLbl.text = @"LATER";
            allEventArray = [Later mutableCopy];
        }

        
        CATransition *transition = [CATransition animation];
        transition.duration = 0.3;
        transition.type = kCATransitionPush;
        transition.subtype = kCATransitionFromLeft;
        [self.tblView.layer addAnimation:transition
                                  forKey:kCATransition];
        [self.tblView reloadData];
        
        self.pageControl.currentPage = pageVal;
    }
}

- (void) refresh
{
    [self.refreshControl beginRefreshing];
    [self.tblView reloadData];
    [self performSelector:@selector(StopRefreshing) withObject:nil afterDelay:0.10];
}

-(IBAction)navigateToNextClasses:(id)sender
{
    [pageController setHidden:YES];
    NSString *uid=[[NSUserDefaults standardUserDefaults]valueForKey:@"UID"];
    if (indexVal == 0)
    {
        [self performSelector:@selector(getEvents)];
    } else if (indexVal  == 1)
    {
        createEventSelected = YES;
        CreateEventViewController *objSignup = [self.storyboard instantiateViewControllerWithIdentifier:@"CreateEventViewControllerID"];
        [self.navigationController pushViewController:objSignup animated:YES];
    }
    else if (indexVal  == 2)
    {
        SearchViewController *objSignup = [self.storyboard instantiateViewControllerWithIdentifier:@"SearchViewControllerID"];
        [self.navigationController pushViewController:objSignup animated:YES];
    }
    else if (indexVal  == 3)
    {
//        [self performSelector:@selector(getGroupsEvents)];
        
    }
    
    if (homeSelected == YES) {
        
    } else if (UpcomingSelected == YES)
    {
        titleLbl.text = @"UPCOMING";
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://seekly.azurewebsites.net/api/UpcomingEvents/%@",uid]];
        [self getDataWithEventUrl:url];

    } else if (AwaitingSelected == YES)
    {
        titleLbl.text = @"AWAITING";
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://seekly.azurewebsites.net/api/AwaitingEvents/%@",uid]];
        [self getDataWithEventUrl:url];

    }  else if (pastSelected == YES)
    {
        titleLbl.text = @"PAST";
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://seekly.azurewebsites.net/api/PastEvents/%@",uid]];
        [self getDataWithEventUrl:url];

    }
    else if (groupSelected == YES)
    {
        titleLbl.text = @"GROUP";
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://seekly.azurewebsites.net/api/GroupFetch/%@",uid]];
        [self getDataWithEventUrl:url];
    }

}

- (void) reloadTbl
{
    [self performSelector:@selector(refresh) withObject:nil afterDelay:2.0];
}

-(void) getDataWithEventUrl:(NSURL*)EventUrl
{
    HUD=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
//    NSString *uid=[[NSUserDefaults standardUserDefaults]valueForKey:@"UID"];
//    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://seekly.azurewebsites.net/api/GroupFetch/%@",uid]];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:EventUrl cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:120.0];
    
    [NSURLConnection sendAsynchronousRequest:urlRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *responce,NSData *data, NSError *connectionError){
        NSError *error = nil;
        if (![data isKindOfClass:[NSNull class]] && data!= nil)
        {
            responseDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
            NSLog(@"dict is :%@",responseDict);

            if (error)
            {
                NSLog(@"fail  ==%@",error);
            }
            else
            {
                if (![responseDict count]<=0)
                {
                    NSString *ResponceStr ;
                    
                    if (homeSelected == YES) {
                        
                    } else if (UpcomingSelected == YES)
                    {
                        ResponceStr = @"lstEvents";
                    }
                    else if (AwaitingSelected == YES)
                    {
                        ResponceStr = @"lstEvents";
                    }
                    else if (pastSelected == YES)
                    {
                        ResponceStr = @"lstEvents";
                    }
                    else if (groupSelected == YES)
                    {
                        ResponceStr = @"lstGroups";
                    }

                    dict = [[responseDict valueForKey:ResponceStr] mutableCopy];
                    allEventArray = [dict  mutableCopy];
                }
                [self.tblView reloadData];
                [HUD hide:YES];
            }
        }
    }];
}


-(void) getUpcomingEvents
{
    HUD=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSString *uid=[[NSUserDefaults standardUserDefaults]valueForKey:@"UID"];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://seekly.azurewebsites.net/api/UpcomingEvents/%@",uid]];
    
    // Create the request
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setRequestMethod:@"POST"];
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
            dict = [[responseDict valueForKey:@"lstEvents"] mutableCopy];
            [HUD hide:YES];
        }
        else
        {
            [HUD hide:YES];
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Exception" message:[NSString stringWithFormat:@"%@",[responseDict  objectForKey:@"Exception"]] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
        }
    }
}

-(void) getPastEvents
{
    HUD=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSString *uid=[[NSUserDefaults standardUserDefaults]valueForKey:@"UID"];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://seekly.azurewebsites.net/api/PastEvents/%@",uid]];
    
    // Create the request
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setRequestMethod:@"POST"];
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
            dict = [[responseDict valueForKey:@"lstEvents"] mutableCopy];
            [HUD hide:YES];
        }
        else
        {
            [HUD hide:YES];
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Exception" message:[NSString stringWithFormat:@"%@",[responseDict  objectForKey:@"Exception"]] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
        }
    }
}

-(void) getAwaitedEvents
{
    HUD=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSString *uid=[[NSUserDefaults standardUserDefaults]valueForKey:@"UID"];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://seekly.azurewebsites.net/api/AwaitingEvents/%@",uid]];
    
    // Create the request
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setRequestMethod:@"POST"];
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
            dict = [[responseDict valueForKey:@"lstEvents"] mutableCopy];
            [HUD hide:YES];
        }
        else
        {
            [HUD hide:YES];
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Exception" message:[NSString stringWithFormat:@"%@",[responseDict  objectForKey:@"Exception"]] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
        }
    }
}

-(void) getMyEvents
{
    HUD=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSString *uid=[[NSUserDefaults standardUserDefaults]valueForKey:@"UID"];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://seekly.azurewebsites.net/api/Group/%@",uid]];
    
    // Create the request
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setRequestMethod:@"POST"];
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
            dict = [[responseDict valueForKey:@"lstEvents"] mutableCopy];
            [HUD hide:YES];
        }
        else
        {
            [HUD hide:YES];
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Exception" message:[NSString stringWithFormat:@"%@",[responseDict  objectForKey:@"Exception"]] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
        }
    }
}

- (void) StopRefreshing
{
    [self.refreshControl endRefreshing];
}

- (void)onRefresh:(id) sender
{
    [self refresh];
}


- (void)hideBtn
{
    [MenuBtn setHidden:YES];
}

- (void)unhideBtn
{
    [MenuBtn setHidden:YES];
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (homeSelected == YES)
    {
        if (allEventArray.count <= 0)
        {
            [mapViewContainer setHidden:YES];
            [tableView setHidden:YES];
//            [alertBackView setHidden:NO];
            if (showMessage == YES) {
                [alertBackView setHidden:NO];
            } else
            {
                [alertBackView setHidden:YES];
            }

            
            return 0;
        }else {
            [mapViewContainer setHidden:YES];
            [tableView setHidden:NO];
            [alertBackView setHidden:NO];
            
        }
    }
    else
    {
        if (allEventArray.count <= 0)
        {
            [mapViewContainer setHidden:YES];
            [tableView setHidden:YES];
            //            [alertBackView setHidden:NO];
            if (showMessage == YES) {
                [alertBackView setHidden:NO];
            } else
            {
                [alertBackView setHidden:YES];
            }
            
            
            return 0;
        }else {
            [mapViewContainer setHidden:YES];
            [tableView setHidden:NO];
            [alertBackView setHidden:NO];
            
        }
    }
//    else if (UpcomingSelected == YES)
//    {
//        return 3;
//    } else if (AwaitingSelected == YES)
//    {
//        return 3;
//    } else if (pastSelected == YES)
//    {
//        return 3;
//    }
    return [allEventArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *MyIdentifier = nil;
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:MyIdentifier];
        cell.backgroundColor = [UIColor whiteColor];
    }
    
    UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, screenSize.size.width, screenSize.size.height * .4402)];
    UIImageView *locationView = [[UIImageView alloc]initWithFrame:CGRectMake(7, 30, 15 , 15)];
    UIImageView *timeView = [[UIImageView alloc]initWithFrame:CGRectMake(7, 55, 15, 15)];
    UIImageView *viewerView = [[UIImageView alloc]initWithFrame:CGRectMake(7, 80, 15, 15)];
    UIImageView *logoImgView = [[UIImageView alloc]initWithFrame:CGRectMake(screenSize.size.width - 140 , 10, 120 ,80)];
    
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(25 , 5, 150, 16)];
    UILabel *LocationLbl = [[UILabel alloc]initWithFrame:CGRectMake(25 , 30, 150, 15)];
    UILabel *dateTimeLbl = [[UILabel alloc]initWithFrame:CGRectMake(25 , 55, 150, 15)];
    UILabel *viewerLbl = [[UILabel alloc]initWithFrame:CGRectMake(25 , 80, 150, 15)];
    
    UIView *titldetailBackView = [[UIView alloc]initWithFrame:CGRectMake(0 , screenSize.size.height * .4402 - 100 , screenSize.size.width, 100)];
    titldetailBackView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    UIView *titleBackView = [[UIView alloc]initWithFrame:CGRectMake(0 , 20  , 150, 20)];
    titleBackView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    
    UILabel *titleHeaderLbl = [[UILabel alloc]initWithFrame:CGRectMake(5 , 0, 140, 20)];
    titleHeaderLbl.textAlignment = NSTextAlignmentCenter;
    
    NSString *categoryStr;
    NSString *titleStr;
    NSString *LocStr;
    NSString *dateStr;
    NSString *memberCountStr;
    
    if (homeSelected == YES || UpcomingSelected == YES || AwaitingSelected == YES || pastSelected == YES ||groupSelected == YES)
    {
        NSString* img1 = [NSString stringWithFormat:@"%@",[[allEventArray valueForKey:@"sub_category_image1"]objectAtIndex:indexPath.row]];
        NSString* img2 = [NSString stringWithFormat:@"%@",[[allEventArray valueForKey:@"sub_category_image2"]objectAtIndex:indexPath.row]];
        NSString* img3 = [NSString stringWithFormat:@"%@",[[allEventArray valueForKey:@"sub_category_image3"]objectAtIndex:indexPath.row]];
        NSArray * array = [[NSArray alloc]initWithObjects:img1,img2,img3, nil];
        
        rnd = arc4random()%[array count];
        
        NSString *path = [NSString stringWithFormat:@"%@",[array objectAtIndex:rnd]];

        path = [path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        NSURL *url = [NSURL URLWithString:path];

        __block UIActivityIndicatorView *activityIndicator;
        __weak UIImageView *weakImageView = imgView;
        [imgView sd_setImageWithURL:url
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
                                           imgView.image = [UIImage imageNamed:@"eventBack"];
                                       }
                                   }];

        logoImg = [UIImage imageNamed:@"logo_01"];
        
        categoryStr = [NSString stringWithFormat:@"%@",[[allEventArray valueForKey:@"sub_category_name"]objectAtIndex:indexPath.row]];
        
        NSString *DateStr;
        if ([titleLbl.text isEqualToString:@"TODAY"]||[titleLbl.text isEqualToString:@"TOMORROW"]) {
            DateStr = [NSString stringWithFormat:@"%@",[[allEventArray valueForKey:@"event_time"] objectAtIndex:indexPath.row]];
        }
        else
        {
            DateStr = [NSString stringWithFormat:@"%@",[[allEventArray valueForKey:@"event_date"] objectAtIndex:indexPath.row]];
        }
        
        NSArray *dateArray = [DateStr componentsSeparatedByString:@"T"];

        titleStr = [NSString stringWithFormat:@"%@",[[allEventArray valueForKey:@"event_name"]objectAtIndex:indexPath.row]];
        LocStr = [NSString stringWithFormat:@"%@",[[allEventArray valueForKey:@"event_location"]objectAtIndex:indexPath.row]];
        dateStr = dateArray [0];
        
//        memberCountStr = [NSString stringWithFormat:@"%@ out of %@",[[allEventArray valueForKey:@"total_user_Joined"] objectAtIndex:indexPath.row],[[allEventArray valueForKey:@"total_user_Invited"] objectAtIndex:indexPath.row]];
        
        memberCountStr = [NSString stringWithFormat:@"0 out of 0"];

        if (homeSelected == YES) {
            [pageController setHidden:NO];
        } else
        {
            [pageController setHidden:YES];
        }
       

     }
//     else if (groupSelected == YES)
//    {
////        NSString *path = [NSString stringWithFormat:@"%@",[[allEventArray valueForKey:@"sub_category_name"]objectAtIndex:indexPath.row]];
////        
////        path = [path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
////        
////        NSURL *url = [NSURL URLWithString:path];
////        
////        __block UIActivityIndicatorView *activityIndicator;
////        __weak UIImageView *weakImageView = imgView;
////        [imgView sd_setImageWithURL:url
////                   placeholderImage:nil
////                            options:SDWebImageProgressiveDownload
////                           progress:^(NSInteger receivedSize, NSInteger expectedSize) {
////                               if (!activityIndicator) {
////                                   [weakImageView addSubview:activityIndicator = [UIActivityIndicatorView.alloc initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray]];
////                                   activityIndicator.center = weakImageView.center;
////                                   [activityIndicator startAnimating];
////                               }
////                           }
////                          completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
////                              [activityIndicator removeFromSuperview];
////                              activityIndicator = nil;
////                              if (!image)
////                              {
////                                  imgView.image = [UIImage imageNamed:@"eventBack"];
////                              }
////                          }];
//        
//        eventImg = [UIImage imageNamed:@"pic_03"];
//        logoImg = [UIImage imageNamed:@"logo_04"];
//        imgView.image = eventImg;
//        titleStr = @"DreamHack";
//        titleLbl.text = @"GROUP";
//        [pageController setHidden:YES];
//    } else if (UpcomingSelected == YES)
//    {
//        eventImg = [UIImage imageNamed:@"pic_04"];
//        logoImg = [UIImage imageNamed:@"logo_04"];
//        imgView.image = eventImg;
//        titleStr = @"DreamHack";
//        titleLbl.text = @"UPCOMING";
//        [pageController setHidden:YES];
//    } else if (AwaitingSelected == YES)
//    {
//        eventImg = [UIImage imageNamed:@"pic_05"];
//        logoImg = [UIImage imageNamed:@"logo_01"];
//        imgView.image = eventImg;
//        titleStr = @"DreamHack";
//        categoryStr = @"DreamHack";
//        titleLbl.text = @"AWAITING";
//        [pageController setHidden:YES];
//    }  else if (pastSelected == YES)
//    {
//        eventImg = [UIImage imageNamed:@"pic_06"];
//        logoImg = [UIImage imageNamed:@"logo_03"];
//        imgView.image = eventImg;
//        titleStr = @"DreamHack";
//        categoryStr = @"DreamHack";
//        titleLbl.text = @"PAST";
//        [pageController setHidden:YES];
//    }
    

    locationView.image = [UIImage imageNamed:@"location"];
    timeView.image = [UIImage imageNamed:@"time"];
    viewerView.image = [UIImage imageNamed:@"player"];
    
    logoImgView.contentMode = UIViewContentModeScaleAspectFit;
    logoImgView.image = logoImg;
    
    titleHeaderLbl.text = categoryStr;
    titleHeaderLbl.font = [UIFont fontWithName:@"Lato-Bold" size:14.0];
    titleHeaderLbl.textColor = [UIColor whiteColor];
    
    
    titleLabel.text = titleStr;
    titleLabel.font = [UIFont fontWithName:@"Lato-Regular" size:14.0];
    titleLabel.textColor = [UIColor whiteColor];
    
    LocationLbl.text = LocStr;
    LocationLbl.font = [UIFont fontWithName:@"Lato-Light" size:12.0];
    LocationLbl.textColor = [UIColor whiteColor];
    
    dateTimeLbl.text = dateStr;
    dateTimeLbl.font = [UIFont fontWithName:@"Lato-Light" size:12.0];
    dateTimeLbl.textColor = [UIColor whiteColor];

    viewerLbl.text = memberCountStr;
    viewerLbl.font = [UIFont fontWithName:@"Lato-Light" size:12.0];
    viewerLbl.textColor = [UIColor whiteColor];
    
    [cell.contentView addSubview:imgView];
    [cell.contentView addSubview:titleBackView];
    [cell.contentView addSubview:titldetailBackView];
    
    [titleBackView addSubview:titleHeaderLbl];
    
    [titldetailBackView addSubview:titleLabel];
    [titldetailBackView addSubview:LocationLbl];
    [titldetailBackView addSubview:dateTimeLbl];
    [titldetailBackView addSubview:viewerLbl];
    [titldetailBackView addSubview:logoImgView];
    [titldetailBackView addSubview:locationView];
    [titldetailBackView addSubview:timeView];
    [titldetailBackView addSubview:viewerView];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    EventDetailViewController *objEventDetail = [self.storyboard instantiateViewControllerWithIdentifier:@"EventDetailViewControllerID"];
    objEventDetail.EventID = [NSString stringWithFormat:@"%@",[[allEventArray valueForKey:@"id"] objectAtIndex:indexPath.row]];
    NSString *path = [NSString stringWithFormat:@"%@",[[dict valueForKey:[NSString stringWithFormat:@"sub_category_image%lu",(unsigned long)rnd]] objectAtIndex:indexPath.row]];
    path = [path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    objEventDetail.imgPath = path;

    NSMutableArray *tempArray = [[responseDict valueForKey:@"lstEvents"] mutableCopy];
    objEventDetail.SelectedEvent = [tempArray objectAtIndex:indexPath.row];
    tempArray = nil;
    [self.navigationController pushViewController:objEventDetail animated:NO];
}

//- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return  UITableViewCellEditingStyleDelete;
//}
//
//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (editingStyle == UITableViewCellEditingStyleDelete) {
//        NSLog(@"delete");
//    }
//}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return screenSize.size.height * .4402;
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.backgroundColor = [UIColor clearColor];
}


#pragma mark - Table view delegate


@end
// Copyright belongs to original author
// http://code4app.net (en) http://code4app.com (cn)
// From the most professional code share website: Code4App.net