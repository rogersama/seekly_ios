//
//  createGroupViewController.h
//  Seekly
//
//  Created by Deepinder singh on 11/06/15.
//  Copyright (c) 2015 Deepinder singh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "searchLocationViewController.h"
#import "SeeklyAPI.h"
#import "SZTextView.h"
#import "slideViewController.h"
#import "InterestCategoryViewController.h"

BOOL CreategroupPressed;

@interface createGroupViewController : UIViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate,searchLocationViewControllerDelegate,InterestCategoryViewControllerDelegate>
{
    IBOutlet UIButton*openEvntBtn;
    IBOutlet UIButton*closedEvntBtn;
    IBOutlet UIButton*secretEvntBtn;
    IBOutlet UIButton*setProfPicBtn;
    IBOutlet UIButton *locBtn;
    IBOutlet UIButton *interestBtn;
    IBOutlet UITextField *grpNameTxtFld;
    IBOutlet UIImageView*setCoverPicImgV;
    IBOutlet SZTextView *descTxtView;
    
    NSString *strEncodedProfPic;
    NSString *strEncodedCoverPic;
    NSString *addrName, *latit ,*longit;
    int isProfilePicBtn,statusVal;
    
    NSString *cat_Id,*sub_cat_Id,*cat_name;
}
-(IBAction)openEvntBtnActn:(id)sender;
-(IBAction)closedEvntBtnActn:(id)sender;
-(IBAction)secretEvntBtnActn:(id)sender;
-(IBAction)setProfPicBtnAtcn:(id)sender;
-(IBAction)setCoverPicBtnAtcn:(id)sender;
-(IBAction)locBtnAtcn:(id)sender;
-(IBAction)interestBtnActn:(id)sender;
-(IBAction)inviteOthrsBtnAtcn:(id)sender;
@end
