//
//  LaunchScreenViewController.h
//  Seekly
//
//  Created by Deepinder singh on 18/05/15.
//  Copyright (c) 2015 Deepinder singh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JASidePanelController.h"
#import "slideViewController.h"
#import "searchLocationViewController.h"

@interface LaunchScreenViewController : UIViewController<UINavigationBarDelegate,UINavigationControllerDelegate>
{
    IBOutlet UIImageView *LogoImg;
    CGRect screenSize;
}
@property (strong, nonatomic) JASidePanelController *viewController;
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, strong)CLLocationManager *locationManager;



@end
