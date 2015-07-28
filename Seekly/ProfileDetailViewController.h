//
//  ProfileDetailViewController.h
//  Seekly
//
//  Created by Deepinder singh on 14/05/15.
//  Copyright (c) 2015 Deepinder singh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "signUpViewController.h"
#import "QSTodoService.h"
#import "AppDelegate.h"

@interface ProfileDetailViewController : UIViewController<UITextFieldDelegate,UINavigationBarDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
{
    IBOutlet UIView *mainView;
    IBOutlet UITextField *fNameTxtFld;
    IBOutlet UITextField *sNameTxtFld;
    IBOutlet UITextField *cityNameTxtFld;
    IBOutlet UITextField *dobNameTxtFld;
    IBOutlet UIButton *profileBtn;
    IBOutlet UIButton *maleBtn;
    IBOutlet UIButton *femaleBtn;
    UIImage *checkImage;
    UIImage *UncheckImage;
    CGRect screenSize;

    IBOutlet UIView *containerView;
    IBOutlet UIToolbar *toolBar;
}


@property (strong, nonatomic) NSDictionary *items;


- (IBAction)backBtnAction:(id)sender;
- (IBAction)uploadPhotoBtnAction:(id)sender;
- (IBAction)moveToNext:(id)sender;
- (IBAction)maleBtnAction:(id)sender;
- (IBAction)femaleBtnAction:(id)sender;

@end
