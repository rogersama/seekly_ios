//
//  FriendsProfileViewController.m
//  Seekly
//
//  Created by Gursimran on 23/07/15.
//  Copyright (c) 2015 Deepinder singh. All rights reserved.
//

#import "FriendsProfileViewController.h"

#import "FriendsViewController.h"

@interface FriendsProfileViewController ()
{
    NSMutableArray *names;
    MBProgressHUD *HUD;
    NSDictionary * dict;
}
@property (nonatomic, weak) IBOutlet UITabBar *tabBar;



@end

@implementation FriendsProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    names=[[NSMutableArray alloc]init];
    
    profileImage.layer.cornerRadius = 35.0;
    profileImage.layer.masksToBounds = YES;
    profileImage.layer.borderWidth = 2.0;
    profileImage.layer.borderColor = [[UIColor whiteColor] CGColor];
    
    screenSize=[[UIScreen mainScreen] bounds];
    
    self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, 1000);
    self.originalFrame =CGRectMake(0, scrollingView.frame.size.height- self.tabBarController.tabBar.frame.size.height, self.tabBarController.tabBar.frame.size.width, self.tabBarController.tabBar.frame.size.height);
    self.topOriginalFrame = CGRectMake(scrollingView.frame.origin.x, scrollingView.frame.origin.y, scrollingView.frame.size.width, scrollingView.frame.size.height);
    
    
    NSString *uName=[[NSUserDefaults standardUserDefaults]valueForKey:@"UName"];
    userName.text = uName;
    [self performSelector:@selector(getProfileInfo)];
    
    // Do any additional setup after loading the view.
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void) getProfileInfo
{
    NSMutableURLRequest *urlRequest;
    
        NSLog(@"%@",_profileID);
        urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://seekly.azurewebsites.net/api/UpdateUser/%@",_profileID]] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:120.0];
   
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
                NSString *uImageUrl = [dict objectForKey:@"profile_pic"];
                if (![uImageUrl isEqual:[NSNull null]])
                {
                    uImageUrl = [uImageUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                    
                    NSURL *url = [NSURL URLWithString:uImageUrl];
                    
                    __block UIActivityIndicatorView *activityIndicator;
                    __weak UIImageView *weakImageView = profileImage;
                    [profileImage sd_setImageWithURL:url
                                    placeholderImage:nil
                                             options:SDWebImageProgressiveDownload
                                            progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                                                if (!activityIndicator) {
                                                    [weakImageView addSubview:activityIndicator = [UIActivityIndicatorView.alloc initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray]];
                                                    activityIndicator.center = weakImageView.center;
                                                    [activityIndicator startAnimating];
                                                }
                                            }
                                           completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                               [activityIndicator removeFromSuperview];
                                               activityIndicator = nil;
                                               if (!image)
                                               {
                                                   profileImage.image = [UIImage imageNamed:@"eventPlaceholderImg"];
                                               }
                                           }];
                }
            }
        }
    }];
}


- (void)viewWillAppear:(BOOL)animated
{
    UIImage* tabBarBackground = [UIImage imageNamed:@"tabBack004"];
    [self.tabBarController.tabBar setBackgroundImage:tabBarBackground];
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
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


#pragma Action Methods


- (IBAction)goTofriendProfile:(id)sender {
    FriendsViewController *objFriend = [self.storyboard instantiateViewControllerWithIdentifier:@"FriendsViewControllerID"];
    [self.navigationController pushViewController:objFriend animated:YES];
}

- (IBAction)backButton:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
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
