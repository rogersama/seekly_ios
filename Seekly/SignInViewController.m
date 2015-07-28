//
//  SignInViewController.m
//  Seekly
//
//  Created by Deepinder singh on 14/05/15.
//  Copyright (c) 2015 Deepinder singh. All rights reserved.
//

#import "SignInViewController.h"
#import "signUpViewController.h"
#import "InterestCategoryViewController.h"
#import "CategoryDetailViewController.h"
#import "ForgetPasswordViewController.h"
#import "TabBarExampleViewController.h"
#import "slideViewController.h"
#import "NVSlideMenuController.h"
#import "ABCIntroView.h"
#import "JASidePanelController.h"
#import "MSClient+CustomId.h"
#import "QSTodoService.h"
#import "JSON.h"
#import "SeeklyAPI.h"


@interface SignInViewController ()<ABCIntroViewDelegate>
{
    MBProgressHUD *HUD;
}

@property (strong, nonatomic) QSTodoService* todoService;


@end

@implementation SignInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    SeeklyAPI *obj =[[SeeklyAPI alloc]init];
//    [obj checkInternetConnection];

    self.todoService = [QSTodoService defaultService];

    self.navigationController.navigationBarHidden = YES;
    
    UIColor *color = [UIColor whiteColor];
    [self setIntroView];
    
    emailTxtFld.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Email" attributes:@{NSForegroundColorAttributeName: color}];
    
    passwordTxtFld.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Password" attributes:@{NSForegroundColorAttributeName: color}];
    
    // Do any additional setup after loading the view from its nib.
}


-(void) setIntroView
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (![defaults objectForKey:@"intro_screen_viewed"]) {
        
        self.introView = [[ABCIntroView alloc] initWithFrame:self.view.frame];
        self.introView.delegate = self;
        self.introView.backgroundColor = [UIColor blackColor];
        [self.view addSubview:self.introView];
    }
}

-(void) startSpinner
{
    HUD=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

- (IBAction)facebookLogin:(id)sender
{
   // [self SignInSucces];
    [self performSelector:@selector(startSpinner)];
    self.accountStore = [[ACAccountStore alloc] init];
    
    //    NSString *appID = @"1545063149107752";
    NSString *appID = @"565962363506446";
    
    
    
    ACAccountType *accountTypeFacebook= [self.accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierFacebook];
    
    //This line asks user what are the things we need permission for
    NSDictionary *fbDictionary = [NSDictionary dictionaryWithObjectsAndKeys:appID,ACFacebookAppIdKey,@[@"email",@"user_photos", @"user_videos", @"read_stream"],ACFacebookPermissionsKey, nil];
    
    [self.accountStore requestAccessToAccountsWithType:accountTypeFacebook  options:fbDictionary  completion:^(BOOL granted, NSError *error) {
        if (granted)
        {
            NSArray *fbAccounts = [self.accountStore accountsWithAccountType:accountTypeFacebook];
            ACAccount *acc=[fbAccounts objectAtIndex:0];
            
            ACAccountCredential *facebookCredential = [acc credential];
            accessToken = [facebookCredential oauthToken];
            NSLog(@"Facebook Access Token: %@", accessToken);
            NSLog(@"facebook account =%@",acc);
            
            NSString *username=[acc userFullName];
            //            usernameFB = [acc username];
            //If the permission is granted we have successfully fetched the user name
            NSLog(@"fb username:: %@", username);
            
            NSCharacterSet *separator = [NSCharacterSet whitespaceAndNewlineCharacterSet];
            NSArray *stringComponents = [username componentsSeparatedByCharactersInSet:separator];
            
            if ([stringComponents count]==2)
            {
            }
            else if ([stringComponents count]==3)
            {
            }
            [self SignInSucces];
        }
        else {
                if (FBSession.activeSession.state == FBSessionStateOpen
                || FBSession.activeSession.state == FBSessionStateOpenTokenExtended)
                {
                    [FBSession.activeSession closeAndClearTokenInformation];
                }
                else
                {
                    [FBSession openActiveSessionWithReadPermissions:@[@"public_profile",@"user_friends",@"email"]allowLoginUI:YES completionHandler:
                     ^(FBSession *session, FBSessionState state, NSError *error)
                     {
                     
                     // Retrieve the app delegate
                     
                     // Call the app delegate's sessionStateChanged:state:error method to handle session state changes
                     
                     
                     accessToken=session.accessTokenData.accessToken;
                     NSLog(@"Facebook Access Token: %@", accessToken);
                     //                     [self.activityIndicator startAnimating];
                     //                     self.activityIndicator.hidden = NO;
                     [self sessionStateChanged:session state:state error:error];
                     
                 }];
            }
        }
    }];
    
}

- (void)sessionStateChanged:(FBSession *)session state:(FBSessionState) state error:(NSError *)error
{
    // If the session was opened successfully
    if (!error && state == FBSessionStateOpen){
        NSLog(@"Session opened");
        NSString *userName = [[NSString alloc]init];
        userName = [[NSUserDefaults standardUserDefaults] objectForKey:@"userName"];
        if (userName) {
            [self SignInSucces];
        } else {
            [[FBRequest requestForMe] startWithCompletionHandler:
             ^(FBRequestConnection *connection,
               NSDictionary<FBGraphUser> *user,
               NSError *error) {
                 if (!error) {
                     
                     NSLog(@"%@",user);
                     NSString *fbuid = user.id;
                     NSURL *fbImgUrl = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large", fbuid]];
                     
                     NSURL *url = [NSURL URLWithString:@"http://seekly.azurewebsites.net/api/SignUp/SignUp"];
                     
                     // Create the request
                     ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
                     [request setRequestMethod:@"POST"];
                     
                     
                     [request setPostValue:[user valueForKey:@"first_name"] forKey:@"first_name"];
                     [request setPostValue:[user valueForKey:@"last_name"] forKey:@"last_name"];
                     [request setPostValue:[user valueForKey:@"city"] forKey:@"city"];
                     [request setPostValue:[user valueForKey:@"date_of_birth"] forKey:@"date_of_birth"];
                     [request setPostValue:[user valueForKey:@"email"] forKey:@"email"];
                     [request setPostValue:@"" forKey:@"password"];
                     [request setPostValue:[user valueForKey:@"gender"] forKey:@"gender"];
                     [request setPostValue:@"23424567" forKey:@"device_token"];
                     [request setPostValue:@"30.345" forKey:@"latitude"];
                     [request setPostValue:@"10.345" forKey:@"longitude"];
                     [request setPostValue:@"null"  forKey:@"profile_pic"];
                     [request setPostValue:@"0" forKey:@"register_type"];
                     [request setPostValue:[user valueForKey:@"id"] forKey:@"fb_id"];
                     
                     [request setDelegate:self];
                     [request startSynchronous];
                     
                     NSError *error = [request error];
                     if (!error)
                     {
                         NSString *response = [request responseString];
                         response=  [response stringByReplacingOccurrencesOfString:@"\\" withString:@""];
                         NSLog(@"%@",response);
                         
                         NSDictionary *responseDict = [response JSONValue];
                         NSLog(@"dict is :%@",responseDict);
                         if ([[NSString stringWithFormat:@"%@",[responseDict  objectForKey:@"Status"]] isEqual: @"1"])
                         {
                             [self SignInSucces];
                             [HUD hide:YES];
                         } else {
                             [HUD hide:YES];
                         }
                     }
                 }
             }];
        }
        
        // Show the user the logged-in UI
        // [self userLoggedIn];
        return;
    }
    if (state == FBSessionStateClosed || state == FBSessionStateClosedLoginFailed){
        // If the session is closed
        NSLog(@"Session closed");
        [HUD hide:YES];

        //        self.activityIndicator.hidden = YES;
        // _lblStatus.text = @"logged out";
        // Show the user the logged-out UI
        //[self userLoggedOut];
    }
    
    // Handle errors
    if (error){
        NSLog(@"Error");
        NSString *alertText;
        NSString *alertTitle;
        // If the error requires people using an app to make an action outside of the app in order to recover
        if ([FBErrorUtility shouldNotifyUserForError:error] == YES){
            alertTitle = @"Something went wrong";
            alertText = [FBErrorUtility userMessageForError:error];
            // [self showMessage:alertText withTitle:alertTitle];
        } else {
            
            // If the user cancelled login, do nothing0
            if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryUserCancelled) {
                NSLog(@"User cancelled login");
                
                // Handle session closures that happen outside of the app
            } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryAuthenticationReopenSession){
                alertTitle = @"Session Error";
                alertText = @"Your current session is no longer valid. Please log in again.";
                //  [self showMessage:alertText withTitle:alertTitle];
                
                // Here we will handle all other errors with a generic error message.
                // We recommend you check our Handling Errors guide for more information
                // https://developers.facebook.com/docs/ios/errors/
            } else {
                //Get more error information from the error
                NSDictionary *errorInformation = [[[error.userInfo objectForKey:@"com.facebook.sdk:ParsedJSONResponseKey"] objectForKey:@"body"] objectForKey:@"error"];
                
                // Show the user an error message
                alertTitle = @"Something went wrong";
                alertText = [NSString stringWithFormat:@"Please retry. \n\n If the problem persists contact us and mention this error code: %@", [errorInformation objectForKey:@"message"]];
                //   [self showMessage:alertText withTitle:alertTitle];
            }
        }
        // Clear this token
        [FBSession.activeSession closeAndClearTokenInformation];
        [HUD hide:YES];

        // Show the user the logged-out UI
        //[self userLoggedOut];
    }
}

#pragma mark - ABCIntroViewDelegate Methods

-(void)onDoneButtonPressed
{
    [UIView animateWithDuration:30 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
//        self.introView.alpha = 0;
        CATransition *transition = [CATransition animation];
        transition.duration = 0.2;
        transition.type = kCATransitionPush;
        transition.subtype = kCATransitionFromRight;
        [self.view.layer addAnimation:transition
                                    forKey:kCATransition];
    } completion:^(BOOL finished) {
        [self.introView removeFromSuperview];
    }];
 }

- (IBAction)backAction:(id)sender
{
    [self setIntroView];
    CATransition *transition = [CATransition animation];
    transition.duration = 0.2;
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromLeft;
    [self.introView.layer addAnimation:transition
                              forKey:kCATransition];
}

-(void)onsignUpButtonPressed
{
    signUpViewController *objSignup = [self.storyboard instantiateViewControllerWithIdentifier:@"signUpViewControllerID"];
    [self.navigationController pushViewController:objSignup animated:YES];
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)goToSignUp:(id)sender
{
    signUpViewController *objSignup = [self.storyboard instantiateViewControllerWithIdentifier:@"signUpViewControllerID"];
    [self.navigationController pushViewController:objSignup animated:YES];
}

- (IBAction)signInBtnAction:(id)sender
{
    [self performSelector:@selector(moveNext:) withObject:nil];
}

- (void) SignInSucces
{
    self.viewController = [[JASidePanelController alloc] init];
    self.viewController.shouldDelegateAutorotateToVisiblePanel = NO;
    self.viewController.leftPanel = [self.storyboard instantiateViewControllerWithIdentifier:@"slideMenuVC"];
    self.viewController.centerPanel = [[UINavigationController alloc] initWithRootViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"TabVCID"]];
    self.view.window.rootViewController = self.viewController;
    [self.view.window makeKeyAndVisible];
    homeSelected = YES;
}


- (IBAction)moveNext:(id)sender
{
    if (internetWorking == 0)       // 0: internet working
    {
        BOOL valid;
        [self performSelector:@selector(startSpinner)];
        valid = [self NSStringIsValidEmail:emailTxtFld.text];
        if (valid == YES)
        {
            if (emailTxtFld.text.length != 0 || passwordTxtFld.text.length != 0)
            {
                
                NSURL *url = [NSURL URLWithString:@"http://seekly.azurewebsites.net/api/SignIn/SignIn"];
                
                // Create the request
                ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
                [request setRequestMethod:@"POST"];
                
                [request setPostValue:emailTxtFld.text forKey:@"Email"];
                [request setPostValue:passwordTxtFld.text forKey:@"Password"];
                
                [request setDelegate:self];
                [request startSynchronous];
                
                
                NSError *error = [request error];
                if (!error)
                {
                    NSString *response = [request responseString];
                    response=  [response stringByReplacingOccurrencesOfString:@"\\" withString:@""];
                    NSLog(@"%@",response);
                    
                    NSDictionary *responseDict = [response JSONValue];
                    NSLog(@"dict is :%@",responseDict);
                    if ([[NSString stringWithFormat:@"%@",[responseDict  objectForKey:@"Status"]] isEqual: @"1"])
                    {
                        NSString*imgStr =[responseDict  objectForKey:@"ImageUrl"];
                        
                        if (![imgStr isKindOfClass:[NSNull class]])
                        {
                            [[NSUserDefaults standardUserDefaults]setValue:imgStr forKey:@"UImageUrl"];
                        }

                        [[NSUserDefaults standardUserDefaults]setValue:[responseDict  objectForKey:@"UserId"] forKey:@"UID"];
                        NSString *fName = [NSString stringWithFormat:@"%@",[responseDict  objectForKey:@"FirstName"]];
                        NSString *lName = [NSString stringWithFormat:@"%@",[responseDict  objectForKey:@"LastName"]];
                        
                        

                        [[NSUserDefaults standardUserDefaults]setValue:[NSString stringWithFormat:@"%@ %@",fName,lName] forKey:@"UName"];
                        
                        
                        [self SignInSucces];

                        [HUD hide:YES];
                    } else {
                        [HUD hide:YES];
                        NSLog(@"Expection is :%@",[responseDict  objectForKey:@"Exception"]);
                        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:[NSString stringWithFormat:@"%@",[responseDict  objectForKey:@"Exception"]] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                        [alert show];
                    }
                }
                
            }
            else {
                [HUD hide:YES];
                
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Please make sure that all fields entered" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [alert show];
            }
            
        } else
        {
            [HUD hide:YES];
            
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"This email is not a valid email id" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
        }

    }
    else
    {
//        NSDictionary *dictReturnCode = [[NSDictionary alloc]initWithObjectsAndKeys:[NSNumber numberWithInt:4],@"error", @"Unable to connect to network.",@"message",nil];
//        ////		NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:dictReturnCode,@"responseDict",nil];
//        //dictReturnCode = nil;
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Unable to connect to network" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    }
}

-(void)API_Response:(NSDictionary*)responseDict
{
    NSLog(@"%@",responseDict);
    if ([responseDict count]>0)
    {
        if ([[responseDict  objectForKey:@"status"]   isEqual: @"1"])
        {
            [self SignInSucces];
//            UIAlertView * registerSuccessAlert=[[UIAlertView alloc]initWithTitle:@"Sign in" message:@"successfully sign in." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
//            [registerSuccessAlert show];
            
        }
        else
        {
            UIAlertView * registerSuccessAlert=[[UIAlertView alloc]initWithTitle:@"Sign in" message:@"An error occured. Please try again later." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            [registerSuccessAlert show];
            
        }
    }
    [HUD hide:YES];
}


- (BOOL) NSStringIsValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = NO; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
    NSString *stricterFilterString = @"^[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}$";
    NSString *laxString = @"^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}

- (IBAction)onLogin:(id)sender {
    [self.todoService.client loginUsername:emailTxtFld.text
                              withPassword:passwordTxtFld.text
                                completion:^(MSUser *user, NSError *error) {
                                    if (error) {
                                        [HUD hide:YES];
                                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Login failed" message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                                        [alert show];
                                        return;
                                    }
                                    else
                                    {
                                        self.viewController = [[JASidePanelController alloc] init];
                                        self.viewController.shouldDelegateAutorotateToVisiblePanel = NO;
                                        self.viewController.leftPanel = [self.storyboard instantiateViewControllerWithIdentifier:@"slideMenuVC"];
                                        self.viewController.centerPanel = [[UINavigationController alloc] initWithRootViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"TabVCID"]];
                                        self.view.window.rootViewController = self.viewController;
                                        [self.view.window makeKeyAndVisible];
                                        homeSelected = YES;

                                    }
//                                    [self dismissModalViewControllerAnimated:YES];
                                }];
}

- (IBAction)onRegister:(id)sender {
    
    [self.todoService.client registerUsername:emailTxtFld.text
                                 withPassword:passwordTxtFld.text
                               withCompletion:^(NSDictionary *item, NSError *error) {
                                   if (error) {
                                       UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Login failed"
                                                                                       message:error.localizedDescription
                                                                                      delegate:nil
                                                                             cancelButtonTitle:@"OK"
                                                                             otherButtonTitles:nil, nil];
                                       [alert show];
                                       return;
                                   }
                                   
                                   [self onLogin:nil];                    
                               }];
}



- (IBAction)forgetPassWordAction:(id)sender {
    ForgetPasswordViewController *objSignup = [self.storyboard instantiateViewControllerWithIdentifier:@"ForgetPasswordViewControllerID"];
    [self.navigationController pushViewController:objSignup animated:YES];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [HUD hide:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
