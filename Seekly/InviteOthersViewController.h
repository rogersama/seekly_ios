//
//  InviteOthersViewController.h
//  Seekly
//
//  Created by Deepinder singh on 06/07/15.
//  Copyright (c) 2015 Deepinder singh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SeeklyAPI.h"

@interface InviteOthersViewController : UIViewController
{
    IBOutlet UIButton *groupBtn;
    IBOutlet UIButton *friendBtn;
    BOOL friendselected;
    BOOL groupselected;
}
- (IBAction)friendAction:(id)sender;
- (IBAction)groupAction:(id)sender;
@property (nonatomic,strong) NSString *eventId;

@end
