//
//  EventsMapViewController.m
//  Seekly
//
//  Created by Gursimran on 13/07/15.
//  Copyright (c) 2015 Deepinder singh. All rights reserved.
//

#import "EventsMapViewController.h"


static NSString *const kTYPE1 = @"Event Location";
static NSString *const kTYPE2 = @"Orange";
static CGFloat kDEFAULTCLUSTERSIZE = 0;

@interface EventsMapViewController ()

{
    int pageIndex;
}
@end

@implementation EventsMapViewController
@synthesize eventsArray;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    AppDelegate *appDel = (AppDelegate*)[UIApplication sharedApplication].delegate;
    eventsArray = appDel.eventsAvailable;
    NSLog(@"%@",eventsArray );
    [self setEventsView];
//    self.mapView.delegate = self;
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated
{
    if (eventsArray.count > 0)
    {
        pageIndex = 0 ;
        [self addButtonTouchUpInside:self];

    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) setEventsView
{
        self.eventsView = [[EventScrollView alloc] initWithFrame:self.eventsView.frame];
        self.eventsView.delegate = self;
        self.eventsView.backgroundColor = [UIColor blackColor];
        [self.view addSubview:self.eventsView];
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
        NSLog(@"ltaitude--->%@  longitude--->%@",[[eventsArray valueForKey:@"latitude"]objectAtIndex:pageIndex],[[eventsArray valueForKey:@"longitude"]objectAtIndex:pageIndex]);
    
    
    
    
    
        float latitude = [numberFormatter numberFromString:[NSString stringWithFormat:@"%@",[[eventsArray valueForKey:@"latitude"]objectAtIndex:pageIndex]]].floatValue;
        float longitude = [numberFormatter numberFromString:[NSString stringWithFormat:@"%@",[[eventsArray valueForKey:@"longitude"]objectAtIndex:pageIndex]]].floatValue;
        
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

- (IBAction)addButtonTouchUpInside:(id)sender
{
    NSArray *randomLocations = [[NSArray alloc] initWithArray:[self randomCoordinatesGenerator:[eventsArray count]]];
}


// ==============================
#pragma mark - map delegate

- (MKAnnotationView *)mapView:(MKMapView *)aMapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    MKAnnotationView *annotationView;
     OCAnnotation *clusterAnnotation = (OCAnnotation *)annotation;
    
    
//    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(loc.coordinate, 1500, 1500);
//    [self.mapView setRegion:[self.mapView regionThatFits:region] animated:YES];
//    
//    // Add an annotation
//    MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
//    point.coordinate = loc.coordinate;
//    point.title = @"Where am I?";
//    point.subtitle = @"I'm here!!!";
//    
//    
//    [self.mapView removeAnnotations:self.mapView.annotations];
//    [self.mapView removeOverlays:self.mapView.overlays];
//    
//    MKAnnotationView *annotationView;
//    annotationView.image = [UIImage imageNamed:@"location_map-icon"];
    
    
    //    self.mapView addAnnotation:point];
//    [self.mapView addAnnotation:point];

    
    annotationView.image = [UIImage imageNamed:@"location_map-icon"];
    clusterAnnotation.title = clusterAnnotation.groupTag;

    
    // if it's a cluster
//    if ([annotation isKindOfClass:[OCAnnotation class]]) {
//        
//        OCAnnotation *clusterAnnotation = (OCAnnotation *)annotation;
//        
//        annotationView = (MKAnnotationView *)[aMapView dequeueReusableAnnotationViewWithIdentifier:@"ClusterView"];
//        if (!annotationView) {
//            annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"ClusterView"];
//            annotationView.canShowCallout = NO;
//            annotationView.centerOffset = CGPointMake(0, -20);
//        }
//        
//        // set title
//        clusterAnnotation.title = @"Cluster";
//        clusterAnnotation.subtitle = [NSString stringWithFormat:@"Containing annotations: %zd", [clusterAnnotation.annotationsInCluster count]];
//        
//        // set its image
//        annotationView.image = [UIImage imageNamed:@"regular.png"];
//        
//        // change pin image for group
//        if (self.mapView.clusterByGroupTag) {
//            if ([clusterAnnotation.groupTag isEqualToString:kTYPE1]) {
//                annotationView.image = [UIImage imageNamed:@"location_map-icon"];
//            }
//            else if([clusterAnnotation.groupTag isEqualToString:kTYPE1]){
//                annotationView.image = [UIImage imageNamed:@"location_map-icon"];
//            }
//            clusterAnnotation.title = clusterAnnotation.groupTag;
//        }
//    }
//    // If it's a single annotation
//    else if([annotation isKindOfClass:[OCMapViewSampleHelpAnnotation class]]){
//        OCMapViewSampleHelpAnnotation *singleAnnotation = (OCMapViewSampleHelpAnnotation *)annotation;
//        annotationView = (MKAnnotationView *)[aMapView dequeueReusableAnnotationViewWithIdentifier:@"singleAnnotationView"];
//        if (!annotationView) {
//            annotationView = [[MKAnnotationView alloc] initWithAnnotation:singleAnnotation reuseIdentifier:@"singleAnnotationView"];
//            annotationView.canShowCallout = YES;
//            annotationView.centerOffset = CGPointMake(0, -20);
//        }
//        singleAnnotation.title = singleAnnotation.groupTag;
//        
//        if ([singleAnnotation.groupTag isEqualToString:kTYPE1]) {
//            annotationView.image = [UIImage imageNamed:@"location_map-icon"];
//        }
//        else if([singleAnnotation.groupTag isEqualToString:kTYPE1]){
//            annotationView.image = [UIImage imageNamed:@"location_map-icon"];
//        }
//    }
//    // Error
//    else{
//        annotationView = (MKPinAnnotationView *)[aMapView dequeueReusableAnnotationViewWithIdentifier:@"errorAnnotationView"];
//        if (!annotationView) {
//            annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"errorAnnotationView"];
//            annotationView.canShowCallout = NO;
//            ((MKPinAnnotationView *)annotationView).pinColor = MKPinAnnotationColorRed;
//        }
//    }
    
    return annotationView;
}

-(void) onViewScroll:(NSString*)indexString
{
    
        NSLog(@"%@",indexString);
        pageIndex = [indexString intValue];
        [self addButtonTouchUpInside:self];
   
    
}

-(IBAction)mapButton:(id)sender
{
    [self.navigationController popViewControllerAnimated:NO];
}


@end
