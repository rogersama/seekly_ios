//
//  EventEditViewController.h
//  Seekly
//
//  Created by Deepinder singh on 22/07/15.
//  Copyright (c) 2015 Deepinder singh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SeeklyAPI.h"
#import "EventDetailViewController.h"

@interface EventEditViewController : UIViewController
{
    IBOutlet UITextField *locTxtFld;
    IBOutlet UITextField *dateTxtFld;
    IBOutlet UITextField *slot;
}
- (IBAction)BackAction:(id)sender;
- (IBAction)SaveAction:(id)sender;
@property (strong, nonatomic) NSString *EventID;
@property (strong, nonatomic) NSString *imgPath;
@property (strong, nonatomic) NSMutableArray *SelectedEvent;
@property (strong, nonatomic) IBOutlet UITextView *discriptionTxtView;

@end
