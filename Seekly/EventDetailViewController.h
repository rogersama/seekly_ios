//
//  EventDetailViewController.h
//  Seekly
//
//  Created by Deepinder singh on 30/06/15.
//  Copyright (c) 2015 Deepinder singh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "SeeklyAPI.h"
#import "TabBarExampleViewController.h"
#import "EventEditViewController.h"

@interface EventDetailViewController : UIViewController<UIScrollViewDelegate,MKMapViewDelegate,CLLocationManagerDelegate>
{
    __weak IBOutlet UIButton *ActionBtn;
    __weak IBOutlet UILabel *eventTitleLbl;
    __weak IBOutlet UILabel *locLbl;
    __weak IBOutlet UILabel *timeLbl;
    __weak IBOutlet UILabel *slotLbl;
    __weak IBOutlet UIImageView *eventImgView;
    __weak IBOutlet UIImageView *logoImgView;
}

- (IBAction)EventSettingAction:(id)sender;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) NSString *lat;
@property (strong, nonatomic) NSString *loong;
@property (strong, nonatomic) NSString *EventID;
@property (strong, nonatomic) NSString *imgPath;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) NSMutableArray *SelectedEvent;
@property (strong, nonatomic) IBOutlet UIScrollView *friendzScroll;
@property (strong, nonatomic) IBOutlet UITextView *discriptionTxtView;


@end
