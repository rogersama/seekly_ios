//
//  GroupProfileViewController.m
//  Seekly
//
//  Created by Deepinder singh on 07/07/15.
//  Copyright (c) 2015 Deepinder singh. All rights reserved.
//

#import "GroupProfileViewController.h"
#import "MBProgressHUD.h"
#import "GroupEditViewController.h"
#import <FacebookSDK/FacebookSDK.h>
#import "AppDelegate.h"
@interface GroupProfileViewController ()
{

    NSMutableArray *mainArr;
    MBProgressHUD *HUD;
    NSDictionary *dict;
    CGRect screenSize;

}
@end

@implementation GroupProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    grpLocnlbl.text=_grpLocn;
    grpProfileImgV.layer.cornerRadius=35;
    grpProfileImgV.layer.borderColor=[UIColor whiteColor].CGColor;
    grpProfileImgV.layer.borderWidth=2.2;
    grpProfileImgV.layer.masksToBounds = YES;
    
    //group status
    if ([_status intValue]== 0)
    {
        statusLbl.text = @"Open group";
    }
    else if ([_status intValue]== 1)
    {
        statusLbl.text = @"Closed group";
    }
    else
    {
        statusLbl.text = @"Secret group";
    }

    
    
    screenSize=[[UIScreen mainScreen] bounds];
    
    objInvite = [self.storyboard instantiateViewControllerWithIdentifier:@"FriendsFromGroupDetail"];
    objchat = [self.storyboard instantiateViewControllerWithIdentifier:@"chatViewControllerID"];
   
    self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, 1000);
    self.originalFrame =CGRectMake(0, scrollingView.frame.size.height- self.tabBarController.tabBar.frame.size.height, self.tabBarController.tabBar.frame.size.width, self.tabBarController.tabBar.frame.size.height);
    self.topOriginalFrame = CGRectMake(scrollingView.frame.origin.x, scrollingView.frame.origin.y, scrollingView.frame.size.width, scrollingView.frame.size.height);

    [self performSelector:@selector(getServices)];
    // Do any additional setup after loading the view.
}



-(void) getServices
{
    
    HUD=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://seekly.azurewebsites.net/api/Group/%@",_slctdGrpId]] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:120.0];
    
    [NSURLConnection sendAsynchronousRequest:urlRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *responce,NSData *data, NSError *connectionError){
        NSError *error = nil;
        if (![data isKindOfClass:[NSNull class]] && data!= nil)
        {
            dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
            if (error)
            {
                NSLog(@"fail  ==%@",error);
            }
            else
            {
                
                
                mainArr=[dict valueForKey:@"GroupInfo"];
                //                NSLog(@"success  ==%@",dict);
                //                NSArray  *usersArr=[dict valueForKey:@"lstUsers"];
                //
                //                for (int i=0; i<usersArr.count; i++) {
                //                    NSMutableDictionary *tempDict=[[NSMutableDictionary alloc]init];
                //                    [tempDict setValue:@"0" forKey:@"selectnState"];
                //                    [tempDict setValue:[[usersArr valueForKey:@"first_name"] objectAtIndex:i]forKey:@"first_name"];
                //                    [tempDict setValue:[[usersArr valueForKey:@"last_name"] objectAtIndex:i]forKey:@"last_name"];
                //                    [tempDict setValue:[[usersArr valueForKey:@"id"] objectAtIndex:i]forKey:@"id"];
                //                    [tempDict setValue:[[usersArr valueForKey:@"gender"] objectAtIndex:i]forKey:@"gender"];
                //                    [tempDict setValue:[[usersArr valueForKey:@"profile_pic"] objectAtIndex:i]forKey:@"profile_pic"];
                //                    [mainArr addObject:tempDict];
                //                    tempDict=nil;
                //                }
                NSLog(@"mainArr  ==%@",mainArr);
                
                [grpProfileImgV sd_setImageWithURL:[NSURL URLWithString:[mainArr valueForKey:@"group_image"]]
                                         placeholderImage:[UIImage imageNamed:@"grpPlaceholderImg"]];
                [grpCoverImg sd_setImageWithURL:[NSURL URLWithString:[mainArr valueForKey:@"cover_image"]]
                                  placeholderImage:[UIImage imageNamed:@""]];
                grpNamelbl.text=[mainArr valueForKey:@"event_name"];
                
//                [groupsTblV reloadData];
                [HUD hide:YES];
            }
        }
    }];

    
}

- (IBAction)backBtnAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)shareGrpAction:(id)sender
{
    
    
//    appDelegate.activeSocialNetwork = @"facebook";
    
    [FBSession openActiveSessionWithReadPermissions:@[@"basic_info",@"email"]
                                       allowLoginUI:YES
                                  completionHandler:
     ^(FBSession *session, FBSessionState state, NSError *error) {
         
         // Retrieve the app delegate
         // Call the app delegate's sessionStateChanged:state:error method to handle session state changes
         [self sessionStateChanged:session state:state error:error];
         
         
     }];

}
- (void)sessionStateChanged:(FBSession *)session state:(FBSessionState ) state error:(NSError *)error
{
    // If the session was opened successfully
    if (!error && state == FBSessionStateOpen){
        NSLog(@"Session opened");
        // Show the user the logged-in UI
        
        [FBRequestConnection
         startForMeWithCompletionHandler:^(FBRequestConnection *connection,
                                           id<FBGraphUser> user,
                                           NSError *error)
         {
             if (!error) {
                 
                 //                 NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                 //                                         [user objectForKey:@"first_name"],@"firstName",
                 //                                         [user objectForKey:@"last_name"],@"lastName",
                 //                                         [user objectForKey:@"email"],@"email",
                 //                                         [user objectForKey:@"id"],@"facebook",nil];
//                 NSURL* url = [NSURL URLWithString:strUrlShare];

            [FBDialogs presentShareDialogWithLink:nil
             name:nil
             caption:nil
             description:grpNamelbl.text
             picture:nil
             clientState:nil
                                               handler:^(FBAppCall *call, NSDictionary *results, NSError *error) {
                                                   if(error) {
                                                       NSLog(@"Error: %@", error.description);
                                                   } else {
                                                       NSLog(@"Success!");
                                
                                                   }
                                               }];
                 
             }
             
         }];
        
        return;
    }
    if (state == FBSessionStateClosed || state == FBSessionStateClosedLoginFailed){
        // If the session is closed
        NSLog(@"Session closed");
        // Show the user the logged-out UI
        // [self userLoggedOut];
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
//            [self showMessage:alertText withTitle:alertTitle];
        } else {
            
            // If the user cancelled login, do nothing
            if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryUserCancelled) {
                NSLog(@"User cancelled login");
                
                // Handle session closures that happen outside of the app
            } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryAuthenticationReopenSession){
                alertTitle = @"Session Error";
                alertText = @"Your current session is no longer valid. Please log in again.";
//                [self showMessage:alertText withTitle:alertTitle];
                
                // For simplicity, here we just show a generic message for all other errors
                // You can learn how to handle other errors using our guide: https://developers.facebook.com/docs/ios/errors
            } else {
                //Get more error information from the error
                NSDictionary *errorInformation = [[[error.userInfo objectForKey:@"com.facebook.sdk:ParsedJSONResponseKey"] objectForKey:@"body"] objectForKey:@"error"];
                
                // Show the user an error message
                alertTitle = @"Something went wrong";
                alertText = [NSString stringWithFormat:@"Please retry. \n\n If the problem persists contact us and mention this error code: %@", [errorInformation objectForKey:@"message"]];
//                [self showMessage:alertText withTitle:alertTitle];
            }
        }
        // Clear this token
        // Show the user the logged-out UI
        //[self userLoggedOut];
    }
}

- (IBAction)calenderAction:(id)sender
{
    CalenderViewController *objCal = [self.storyboard instantiateViewControllerWithIdentifier:@"CalenderViewControllerID"];
    [self.navigationController pushViewController:objCal animated:YES];
}



#pragma mark Table View Delegates

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    cell.backgroundColor = [UIColor whiteColor];
    
    UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(8, 50, screenSize.size.width - 16, 188)];
    UIImageView *profileImg = [[UIImageView alloc]initWithFrame:CGRectMake(8 , 8, 40 , 40)];
    UIImageView *rateImg = [[UIImageView alloc]initWithFrame:CGRectMake(screenSize.size.width - 33 , 8, 25 , 25)];
    
    UILabel *titleLbl = [[UILabel alloc]initWithFrame:CGRectMake(60 , 8, 140, 20)];
    
    //    UIView *titldetailBackView = [[UIView alloc]initWithFrame:CGRectMake(0 , 250 -100  , screenSize.size.width, 100)];
    //    titldetailBackView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    
    
    UILabel *titleHeaderLbl = [[UILabel alloc]initWithFrame:CGRectMake(5 , 0, 100, 20)];
    titleHeaderLbl.textAlignment = NSTextAlignmentCenter;
    
    imgView.image = [UIImage imageNamed:@"pic_01"];
    profileImg.image = [UIImage imageNamed:@"profile_pic_01"];
    rateImg.image = [UIImage imageNamed:@"rate"];
    
    titleLbl.text = [NSString stringWithFormat:@"Oscar Meivert"];
    UIFont * myFont = [UIFont fontWithName:@"LATO-LIGHT" size:16];
    [titleLbl setFont:myFont];
    titleLbl.textColor = [UIColor blackColor];
    
    [cell addSubview:imgView];
    [cell addSubview:profileImg];
    [cell addSubview:rateImg];
    //    [cell addSubview:titldetailBackView];
    [cell addSubview:titleLbl];
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 250;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}


- (IBAction)editGrpAction:(id)sender
{
    GroupEditViewController *obj=[self.storyboard instantiateViewControllerWithIdentifier:@"GroupEditViewControllerID"];
    obj.grpId=_slctdGrpId;
    obj.subCategId=[mainArr valueForKey:@"sub_category_id"];
    obj.grpStatus = [[mainArr valueForKey:@"status"] intValue];
    obj.grpName=grpNamelbl.text;
    obj.grpProfImg=grpProfileImgV.image;
    obj.grp_Lat=_grpLat;
    obj.grp_Long=_grpLong;
    obj.grp_Locn=_grpLocn;
    obj.grpCover_Img = grpCoverImg.image;
    obj.grp_Descr = [mainArr valueForKey:@"group_description"];
    [self.navigationController pushViewController:obj animated:YES];

}
- (IBAction)membersButton:(id)sender
{
    [self.navigationController pushViewController:objInvite animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)chatButton:(id)sender
{
    objchat.isFromGroup = YES;
    objchat.groupName = grpNamelbl.text;
    objchat.groupID = _slctdGrpId;
    
    [self.navigationController pushViewController:objchat animated:YES];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    
    
    UITabBar *tabBar = self.tabBarController.tabBar;
    
    NSInteger yOffset = scrollView.contentOffset.y;
    CGFloat yPanGesture = [scrollView.panGestureRecognizer translationInView:self.view].y;
    CGFloat heightTabBar = tabBar.frame.size.height;
    
    CGFloat tabBarOriginY = tabBar.frame.origin.y;
    CGFloat frameHeight = self.view.frame.size.height;
    
    if(yOffset>=heightTabBar)
        yOffset = heightTabBar;
    
    // GOING UP ------------------
    if(yPanGesture >= 0 && yPanGesture < heightTabBar && tabBarOriginY > frameHeight-heightTabBar){
        yOffset = heightTabBar - fabsf(yPanGesture);
    }
    else if(yPanGesture >= 0 && yPanGesture < heightTabBar && tabBarOriginY <= frameHeight-heightTabBar){
        yOffset = 0;
    }
    // GOING DOWN ------------------
    else if(yPanGesture < 0 && tabBarOriginY < frameHeight){
        yOffset = fabsf(yPanGesture);
    }else if(yPanGesture < 0 && tabBarOriginY >= frameHeight){
        yOffset = heightTabBar;
    }
    else{
        yOffset = 0;
    }
    
    if (yOffset > 0) {
        //        tabBar.frame = CGRectMake(tabBar.frame.origin.x, self.originalFrame.origin.y + yOffset, tabBar.frame.size.width, tabBar.frame.size.height);
        //
        //        NSLog(@"%f",tabBar.frame.origin.y);
        
        [UIView animateWithDuration:1.0 animations:^(void)
         {
             if (scrollingView.frame.origin.y == self.topOriginalFrame.origin.y )
             {
                 scrollingView.frame = CGRectMake(scrollingView.frame.origin.x, scrollingView.frame.origin.y - 197, scrollingView.frame.size.width, scrollingView.frame.size.height+197);
                 
             }}];
        
    }
    else if (yOffset <= 0){
        // tabBar.frame = self.originalFrame;
        [UIView animateWithDuration:1.0 animations:^(void)
         {
             scrollingView.frame = self.topOriginalFrame;
             
         }];
    }
}

- (void)scrollViewWillEndDragging:(UIScrollView*)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    
    // Handle unfinished animations
    UITabBar *tabBar = self.tabBarController.tabBar;
    CGFloat yPanGesture = [scrollView.panGestureRecognizer translationInView:self.view].y;
    CGFloat heightTabBar = tabBar.frame.size.height;
    CGFloat tabBarOriginY = tabBar.frame.origin.y;
    CGFloat frameHeight = self.view.frame.size.height;
    
    
    if(yPanGesture > 0){
        
        //[tabBar setHidden:NO];
        if(tabBarOriginY != frameHeight - heightTabBar) {
            
            
            [UIView animateWithDuration:1.0 animations:^(void){
                scrollingView.frame = self.topOriginalFrame;
                //  tabBar.frame = self.originalFrame;
                [self setNeedsStatusBarAppearanceUpdate];
            }];
            
        }
        
    }else if(yPanGesture < 0){
        
        if (tabBarOriginY != frameHeight) {
            [UIView animateWithDuration:1.0 animations:^(void){
                //  tabBar.frame = CGRectMake(tabBar.frame.origin.x, frameHeight, tabBar.frame.size.width, tabBar.frame.size.height);
                
                if (scrollingView.frame.origin.y == self.topOriginalFrame.origin.y )
                {
                    scrollingView.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y -197, scrollingView.frame.size.width, scrollingView.frame.size.height+197);
                    [self setNeedsStatusBarAppearanceUpdate];
                }
                
            }];
            // [tabBar setHidden:YES];
            
            
        }
        
    }
    
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
