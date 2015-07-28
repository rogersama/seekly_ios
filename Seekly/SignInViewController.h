//
//  SignInViewController.h
//  Seekly
//
//  Created by Deepinder singh on 14/05/15.
//  Copyright (c) 2015 Deepinder singh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import <Social/Social.h>
#import <Accounts/Accounts.h>
#import "InterestCategoryViewController.h"

@class ABCIntroView;
@class AppDelegate;
@class JASidePanelController;

//#import "ABCIntroView.h"


@interface SignInViewController : UIViewController<UITextFieldDelegate,UINavigationBarDelegate,UINavigationControllerDelegate>
{
    IBOutlet UIView *mainView;
    IBOutlet UITextField *emailTxtFld;
    IBOutlet UITextField *passwordTxtFld;
    NSString *accessToken;
    IBOutlet UIView *introBackView;
    IBOutlet UIImageView *logoFullImgView;
}
- (IBAction)goToSignUp:(id)sender;
- (IBAction)signInBtnAction:(id)sender;
- (IBAction)facebookLogin:(id)sender;
- (IBAction)forgetPassWordAction:(id)sender;
- (IBAction)onLogin:(id)sender;
- (IBAction)onRegister:(id)sender;
//- (IBAction)didEndOnExit:(id)sender;


@property (strong,nonatomic)ACAccountStore *accountStore;
@property ABCIntroView *introView;
@property (strong, nonatomic) JASidePanelController *viewController;


@property (strong,nonatomic)IBOutlet UIActivityIndicatorView *activityIndicator;

@end
