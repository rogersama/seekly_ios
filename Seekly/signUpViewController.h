//
//  signUpViewController.h
//  Seekly
//
//  Created by Deepinder singh on 14/05/15.
//  Copyright (c) 2015 Deepinder singh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import <Social/Social.h>
#import <Accounts/Accounts.h>
#import "AppDelegate.h"
#import "slideViewController.h"
#import "TabBarExampleViewController.h"
#import "SeeklyAPI.h"


@class JASidePanelController;


@interface signUpViewController : UIViewController<UITextFieldDelegate,UINavigationBarDelegate,UINavigationControllerDelegate>
{
    IBOutlet UIView *mainView;
    IBOutlet UITextField *emailTxtFld;
    IBOutlet UITextField *passwordTxtFld;
    IBOutlet UITextField *repeatPasswordTxtFld;
    IBOutlet UIView *containerView;
    CGRect screenSize;
    NSString *accessToken;


}
- (IBAction)moveNext:(id)sender;
- (IBAction)backAction:(id)sender;

@property (strong, nonatomic) NSDictionary *items;
@property (strong,nonatomic)ACAccountStore *accountStore;
@property (strong, nonatomic) JASidePanelController *viewController;





@end
