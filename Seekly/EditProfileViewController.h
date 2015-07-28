//
//  EditProfileViewController.h
//  Seekly
//
//  Created by Deepinder singh on 01/06/15.
//  Copyright (c) 2015 Deepinder singh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDWebImageManager.h"
#import "UIImageView+WebCache.h"


@interface EditProfileViewController : UIViewController

{
    IBOutlet UIButton *doneEditing;
    IBOutlet UITextField *fname;
    IBOutlet UITextField *lname;
    IBOutlet UIImageView *profileImage;
    IBOutlet UIButton *profilePickBtn;
    IBOutlet UIButton *coverpickBtn;
    IBOutlet UITextField *fNameLbl;
    IBOutlet UITextField *cityLbl;
    IBOutlet UITextField *lNameLbl;
}
- (IBAction)DoneEditingAction:(id)sender;

@end
