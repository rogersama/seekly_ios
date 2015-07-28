//
//  FriendsViewController.m
//  Seekly
//
//  Created by Deepinder singh on 01/06/15.
//  Copyright (c) 2015 Deepinder singh. All rights reserved.
//

#import "FriendsViewController.h"
#import "EditProfileViewController.h"

@interface FriendsViewController ()
{
    MBProgressHUD *HUD;

}
@end

@implementation FriendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    searchResults = [[NSMutableArray alloc]initWithObjects:
   @{@"name":@"user1",@"isFriend":@"1",@"isRequested":@"0",@"notFriend":@"0" },
   @{@"name":@"user2",@"isFriend":@"0",@"isRequested":@"1",@"notFriend":@"0" },
   @{@"name":@"user3",@"isFriend":@"0",@"isRequested":@"1",@"notFriend":@"0" },
   @{@"name":@"user4",@"isFriend":@"0",@"isRequested":@"0",@"notFriend":@"1" },
   @{@"name":@"user5",@"isFriend":@"1",@"isRequested":@"0",@"notFriend":@"0" },
   @{@"name":@"user6",@"isFriend":@"0",@"isRequested":@"0",@"notFriend":@"1" },
   @{@"name":@"user7",@"isFriend":@"1",@"isRequested":@"0",@"notFriend":@"0" },
   @{@"name":@"user8",@"isFriend":@"0",@"isRequested":@"1",@"notFriend":@"0" },
   @{@"name":@"user9",@"isFriend":@"0",@"isRequested":@"0",@"notFriend":@"1" },  nil];
  
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated
{
    [friends setBackgroundColor:[UIColor whiteColor]];
    [friends setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [friendsTable reloadData];
    [inviteView setHidden:YES];
}
-(void)viewDidAppear:(BOOL)animated
{
    [self getFriends];
}
-(void)getFriends
{
    HUD=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://seekly.azurewebsites.net/api/GetFriendsGroups/c6a18487-5ad3-4644-86b2-19b9a99a7a58"] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:120.0];
    
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
                friendsArr = [[NSMutableArray alloc]init];
                friendsArr = [[dict valueForKey:@"lstfriends"] mutableCopy];
                NSLog(@"friends  ==%@",friendsArr);

                [friends setTitle:[NSString stringWithFormat:@"%lu FRIENDS",(unsigned long)[friendsArr count]] forState:UIControlStateNormal];
                [friendsTable reloadData];
                [HUD hide:YES];
            }
        }
    }];

}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
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
#pragma mark Table View Delegates

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == friendsTable)
    {
        return [friendsArr count];
    }
    else
    {
        return  [searchResults count];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 75;
}
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    if (tableView == friendsTable)
    {
        return[NSArray arrayWithObjects:@"A",@"B",@"C",@"D", @"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z",@"Ā",@"Ä",@"Ö",@"Ô",@"Ż", nil];
    }
    else
    {
        return  nil;
    }
}
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString
                                                                             *)title atIndex:(NSInteger)index {
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AddFriendsCell *cell = (AddFriendsCell *)[tableView dequeueReusableCellWithIdentifier:@"SearchResults" forIndexPath:indexPath];

    //friends table view
    if (tableView == friendsTable)
    {
        cell.userImage.layer.cornerRadius = 25.0;
        cell.userImage.layer.masksToBounds = YES;
        cell.onlineStatus.layer.cornerRadius = 5.0;
        cell.onlineStatus.layer.borderWidth = 2.0;
        cell.onlineStatus.layer.borderColor = [UIColor whiteColor].CGColor;
        cell.onlineStatus.layer.masksToBounds = YES;
        
        //online offline status
        [cell.onlineStatus setBackgroundColor:[UIColor greenColor]];
        
        cell.userName.text = [[friendsArr objectAtIndex:indexPath.row]valueForKey:@"first_name"];
        cell.mutualFriends.text = [NSString stringWithFormat:@"%d mutual friends",indexPath.row+1];
        
        NSString *uImageUrl = [[friendsArr objectAtIndex:indexPath.row] valueForKey:@"profile_pic"];
        
        if (![uImageUrl isEqual:[NSNull null]])
        {
            uImageUrl = [uImageUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            
            NSURL *url = [NSURL URLWithString:uImageUrl];
            
            __block UIActivityIndicatorView *activityIndicator;
            __weak UIImageView *weakImageView = cell.userImage;
            [cell.userImage sd_setImageWithURL:url
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
                                           cell.userImage.layer.borderWidth = 1.0;
                                           cell.userImage.layer.borderColor = [UIColor grayColor].CGColor;
                                           cell.userImage.image = [UIImage imageNamed:@"eventPlaceholderImg"];
                                       }
                                   }];

        
            }
        else
        {
            cell.userImage.layer.borderWidth = 1.0;
            cell.userImage.layer.borderColor = [UIColor grayColor].CGColor;
            [cell.userImage setBackgroundColor:[UIColor grayColor]];
        }
    }
    
    //add table view
    else
    {
        cell.addButton.layer.cornerRadius = 12.0;
        cell.addButton.layer.masksToBounds =YES;
        cell.userImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"profile_pic_0%ld",(long)indexPath.row+1]];
        cell.userName.text = [[searchResults objectAtIndex:indexPath.row]valueForKey:@"name"];
        if ([[[searchResults objectAtIndex:indexPath.row]valueForKey:@"isFriend"] isEqualToString:@"1" ])
        {
            [cell.addButton setHidden: YES];
        }
        else if ([[[searchResults objectAtIndex:indexPath.row]valueForKey:@"isRequested"] isEqualToString:@"1" ])
        {
            cell.addButton.backgroundColor = [UIColor colorWithRed:44.0/255.0 green:199.0/255.0 blue:99.0/255.0 alpha:1.0];
            [cell.addButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            cell.addButton.layer.borderWidth = 0.0;
            cell.addButton.layer.masksToBounds =YES;
            
        }
        else
        {
            cell.addButton.backgroundColor = [UIColor whiteColor];
            [cell.addButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            cell.addButton.layer.borderColor = [UIColor grayColor].CGColor;
            cell.addButton.layer.borderWidth = 1.0;
            cell.addButton.layer.masksToBounds =YES;
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}


#pragma Action Methods


-(IBAction)friendsButton:(id)sender
{
    [inviteView setHidden:YES];
    [friends setBackgroundColor:[UIColor whiteColor]];
    [friends setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [add setBackgroundColor:[UIColor colorWithRed:30.0/255.0 green:30.0/255.0 blue:30.0/255.0 alpha:1.0]];
    [add setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [invite setBackgroundColor:[UIColor colorWithRed:30.0/255.0 green:30.0/255.0 blue:30.0/255.0 alpha:1.0]];
    [invite setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [friendsTable setHidden:NO];
    [addTable setHidden:YES];
    [friendsTable reloadData];
}
-(IBAction)addButton:(id)sender
{
    [inviteView setHidden:YES];
    [add setBackgroundColor:[UIColor whiteColor]];
    [add setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [friends setBackgroundColor:[UIColor colorWithRed:30.0/255.0 green:30.0/255.0 blue:30.0/255.0 alpha:1.0]];
    [friends setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [invite setBackgroundColor:[UIColor colorWithRed:30.0/255.0 green:30.0/255.0 blue:30.0/255.0 alpha:1.0]];
    [invite setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [friendsTable setHidden:YES];
    [addTable setHidden:NO];
    [addTable reloadData];

}
-(IBAction)inviteButton:(id)sender
{
    [inviteView setHidden:NO];
    [invite setBackgroundColor:[UIColor whiteColor]];
    [invite setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [add setBackgroundColor:[UIColor colorWithRed:30.0/255.0 green:30.0/255.0 blue:30.0/255.0 alpha:1.0]];
    [add setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [friends setBackgroundColor:[UIColor colorWithRed:30.0/255.0 green:30.0/255.0 blue:30.0/255.0 alpha:1.0]];
    [friends setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];


}


- (IBAction)backAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}



@end
