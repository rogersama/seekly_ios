//
//  LaunchScreenViewController.m
//  Seekly
//
//  Created by Deepinder singh on 18/05/15.
//  Copyright (c) 2015 Deepinder singh. All rights reserved.
//

#import "LaunchScreenViewController.h"
#import "SignInViewController.h"

@interface LaunchScreenViewController ()
{
    double latitude,longitude;
    NSString *latString;
    NSString *longString;
    BOOL stopLocMgr;
}

@end

@implementation LaunchScreenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view bringSubviewToFront:LogoImg];
    screenSize=[[UIScreen mainScreen] bounds];

    LogoImg.frame = CGRectMake(screenSize.size.width / 2, screenSize.size.height / 2, 0, 0);

    self.navigationController.navigationBarHidden = YES;
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
    
    self.locationManager.delegate = self;
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    [self.locationManager startUpdatingLocation];
    // Do any additional setup after loading the view.
}

-(void)viewDidAppear:(BOOL)animated
{
    LogoImg.frame = CGRectMake(screenSize.size.width / 2, screenSize.size.height / 2, 0, 0);
    [self performSelector:@selector(AnimateLogo) withObject:nil afterDelay:2.0];
//    [self performSelector:@selector(MoveToVC) withObject:nil afterDelay:0.8];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) AnimateLogo
{
    [UIView animateWithDuration:0.5 animations:^ {
        CGRect frame = LogoImg.frame;
        frame.origin.x = screenSize.size.width / 2 - 49;
        frame.origin.y = screenSize.size.height / 2 - 49;
        frame.size.width = 98;
        frame.size.height = 98;
        LogoImg.frame = frame;
    }];
    
    /* 
     NSArray * imageArray  = [[NSArray alloc] initWithObjects:[UIImage imageNamed:@"1.png"], [UIImage imageNamed:@"2.png"], nil]; //this will be the frames of animation images in sequence.
     ringImage = [[UIImageView alloc]initWithFrame:CGRectMake(100,200,600,600)];
     ringImage.animationImages = imageArray;
     ringImage.animationDuration = 1.5;//this the animating speed which you can modify
     ringImage.contentMode = UIViewContentModeScaleAspectFill;
     [ringImage startAnimating]
     */
}
- (void) MoveToVC
{
    NSString *uid=[[NSUserDefaults standardUserDefaults]valueForKey:@"UID"];
    if (uid.length>0 && ![uid isEqual:[NSNull null]])
    {
        self.viewController = [[JASidePanelController alloc] init];
        self.viewController.shouldDelegateAutorotateToVisiblePanel = NO;
        self.viewController.leftPanel = [self.storyboard instantiateViewControllerWithIdentifier:@"slideMenuVC"];
        self.viewController.centerPanel = [[UINavigationController alloc] initWithRootViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"TabVCID"]];
        self.view.window.rootViewController = self.viewController;
        [self.view.window makeKeyAndVisible];
        homeSelected = YES;
    }
    else
    {
        SignInViewController *objProfile  = [self.storyboard instantiateViewControllerWithIdentifier:@"SignInViewControllerID"];
        [self.navigationController pushViewController:objProfile animated:YES];
    }

}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    
    if (stopLocMgr==NO) {
        
        stopLocMgr=YES;
        
        CLLocation * currentLocation = [locations lastObject];
        
        
        latitude =currentLocation.coordinate.latitude;
        longitude =currentLocation.coordinate.longitude;
        latString=[NSString stringWithFormat:@"%f",latitude];
        longString=[NSString stringWithFormat:@"%f",longitude];
        
        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@,%@",latString,longString] forKey:@"latLong"];
        [self performSelector:@selector(MoveToVC) withObject:nil afterDelay:0.8];

    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
