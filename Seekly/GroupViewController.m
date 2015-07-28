//
//  GroupViewController.m
//  Seekly
//
//  Created by Deepinder singh on 21/05/15.
//  Copyright (c) 2015 Deepinder singh. All rights reserved.
//

#import "GroupViewController.h"
#import "chatViewController.h"
#import "createGroupViewController.h"
#import "GroupViewCell.h"
#import "MBProgressHUD.h"
#import "GroupProfileViewController.h"
#import "SDWebImageManager.h"
#import "UIImageView+WebCache.h"


@interface GroupViewController ()
{
    NSMutableArray *names,*mainArr,*invitedUsrsNotArr;
    MBProgressHUD *HUD;
    NSDictionary *dict;
}
@property (nonatomic, weak) IBOutlet UITabBar *tabBar;


@end

@implementation GroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    mainArr=[[NSMutableArray alloc]init];
    invitedUsrsNotArr=[[NSMutableArray alloc]init];
    filteredArray = [[NSMutableArray alloc]init];
    globalArray = [[NSMutableArray alloc]init];
    
    self.navigationController.navigationBarHidden = YES;
    self.navigationItem.title = @"TODAY";
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};

    names=[[NSMutableArray alloc]initWithObjects:@"MANAGE NOTIFICATION",@"INVITE FRIENDS",@"FAQ",@"RATE US",@"FOLLOW US ON SOCIAL NETWORK",@"GIVE US FEEDBACK",@"CHANGE PASSWORD",@"TERMS OS USE",@"LOGOUT" ,nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [searchView setHidden:YES];
    UIImage* tabBarBackground = [UIImage imageNamed:@"tabBack002"];
    [self.tabBarController.tabBar setBackgroundImage:tabBarBackground];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    [self performSelector:@selector(getServices)];
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}
-(void) getServices
{
    HUD=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://seekly.azurewebsites.net/api/GroupFetch/%@",[[NSUserDefaults standardUserDefaults]valueForKey:@"UID"]]] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:120.0];
    
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
                mainArr=[dict valueForKey:@"lstGroups"];
                NSLog(@"mainArr  ==%@",mainArr);
                globalArray = mainArr;
                [groupsTblV reloadData];
                [HUD hide:YES];
            }
        }
    }];
}

#pragma mark Table View Delegates

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (mainArr.count <= 0)
    {
        [groupsTblV setHidden:YES];
        
        return 0;
    }else {
        [groupsTblV setHidden:NO];
    }
    return [mainArr count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    
    GroupViewCell *cell = (GroupViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.patternLabel.text =  [[mainArr valueForKey:@"event_name"]objectAtIndex:indexPath.row];
    
    
    cell.patternImageView.layer.cornerRadius=30;
    cell.patternImageView.layer.borderColor=[UIColor whiteColor].CGColor;
    cell.patternImageView.layer.borderWidth=2.2;
    cell.patternImageView.layer.masksToBounds = YES;
    cell.dotImage.layer.cornerRadius = 2.5;
    cell.dotImage.layer.masksToBounds = YES;
    
    
    [cell.patternImageView sd_setImageWithURL:[NSURL URLWithString:[[mainArr objectAtIndex:indexPath.row] valueForKey:@"group_image"]]
                      placeholderImage:[UIImage imageNamed:@"grpPlaceholderImg"]];
    
 
    cell.grpTypeLabel.text = [[mainArr objectAtIndex:indexPath.row]valueForKey:@"sub_category_name"];
    cell.noOfMembrsLabel.text = [NSString stringWithFormat:@"%@ members",[[mainArr objectAtIndex:indexPath.row] valueForKey:@"total_user_Joined"]];
    
    
    //label positioning
    CGSize textSize = { 320.0, 10000.0 };
    CGRect textRect = [[NSString stringWithFormat:@"%@",[[mainArr objectAtIndex:indexPath.row] valueForKey:@"sub_category_name"]] boundingRectWithSize:textSize  options:NSStringDrawingUsesLineFragmentOrigin
                                                                                                                                   attributes:@{NSFontAttributeName:[UIFont  fontWithName:@"Helvetica Neue" size:13.0f]}
                                                                                                                                      context:nil];
   
    
    float nameSize = textRect.size.width;
    
    [cell.grpTypeLabel setFrame:CGRectMake(76, 36, nameSize, 21)];
    [cell.dotImage setFrame:CGRectMake(76+nameSize+10, 44, 5, 5)];
    [cell.noOfMembrsLabel setFrame:CGRectMake(76+nameSize+25, 36, 100, 21)];
    
    //group status
    if ([[[mainArr objectAtIndex:indexPath.row ] valueForKey:@"status"] intValue]== 0)
    {
         cell.grpStatus.text = @"OPEN";
    }
    else if ([[[mainArr objectAtIndex:indexPath.row ] valueForKey:@"status"] intValue]== 1)
    {
        cell.grpStatus.text = @"CLOSED";
    }
    else
    {
        cell.grpStatus.text = @"SECRET";
    }

   
    

    
    
    
   
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [searchView setHidden:YES];
    CGRect frame = Table.frame;
    frame.origin.y = 64;
    frame.size.height = frame.size.height+56;
    Table.frame = frame;
    isVisible = NO;

    GroupProfileViewController *objProfile = [self.storyboard instantiateViewControllerWithIdentifier:@"GroupProfileViewControllerID"];
    
    objProfile.slctdGrpId=[[mainArr objectAtIndex:indexPath.row] valueForKey:@"id"];
    objProfile.grpLat=[[mainArr objectAtIndex:indexPath.row] valueForKey:@"group_latitude"];
    objProfile.grpLong=[[mainArr objectAtIndex:indexPath.row] valueForKey:@"group_latitude"];
    objProfile.grpLocn=[[mainArr objectAtIndex:indexPath.row] valueForKey:@"location"];
    objProfile.status = [[mainArr objectAtIndex:indexPath.row ] valueForKey:@"status"];
    [self.navigationController pushViewController:objProfile animated:YES];
    
}

//- (void) navigateToGrpProfile:(UIButton*)sender
//{
//    int index = sender.tag;
//    
//    GroupProfileViewController *objchat = [self.storyboard instantiateViewControllerWithIdentifier:@"GroupProfileViewControllerID"];
//    
//    objchat.slctdGrpId=[[mainArr objectAtIndex:index] valueForKey:@"id"];
//    objchat.grpLat=[[mainArr objectAtIndex:index] valueForKey:@"group_latitude"];
//    objchat.grpLong=[[mainArr objectAtIndex:index] valueForKey:@"group_latitude"];
//    objchat.grpLocn=[[mainArr objectAtIndex:index] valueForKey:@"location"];
//    [self.navigationController pushViewController:objchat animated:YES];
//
//}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // you need to implement this method too or nothing will work:
    
        //http://seekly.azurewebsites.net/api/GroupLeave/GroupLeave
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}




-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"Leave Group";
}

-(void)configureCell
{
    // create the button
}

- (void)seekDuplicateButtonWasPressed
{
//    do something...
//       
 }




- (IBAction)inviteFriends:(id)sender
{
    createGroupViewController *objCreateGrup = [self.storyboard instantiateViewControllerWithIdentifier:@"createGroupViewControllerID"];
    [self.navigationController pushViewController:objCreateGrup animated:YES];
}


-(IBAction)searchButton:(id)sender
{
    if (!isVisible)
    {
        [searchButton setImage:[UIImage imageNamed:@"search_icon"] forState:UIControlStateNormal];
        [searchView setHidden:NO];
        CGRect frame = Table.frame;
        frame.origin.y = 120;
        frame.size.height = frame.size.height-56;
        Table.frame = frame;
        isVisible = YES;
    }
    else
    {
        mainArr = globalArray;
        [Table reloadData];
        [searchButton setImage:[UIImage imageNamed:@"search_icon2"] forState:UIControlStateNormal];
        [searchView setHidden:YES];
        CGRect frame = Table.frame;
        frame.origin.y = 64;
        frame.size.height = frame.size.height+56;
        Table.frame = frame;
        isVisible = NO;
    }
}


#pragma mark Textfield delegates

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    mainArr = globalArray;
    searchTextString = string;
    if (searchTextString.length == 0)
    {
        mainArr = globalArray;
        [Table reloadData];

    }
    else
    {
        [self updateSearchArray];
    }
    return YES;
    
}

-(void)updateSearchArray
{
    if (searchTF.text.length != 0) {
        filteredArray = [NSMutableArray array];
        for ( NSDictionary* item in mainArr ) {
            if ([[[item objectForKey:@"event_name"] lowercaseString] rangeOfString:[searchTextString lowercaseString]].location != NSNotFound) {
                [filteredArray addObject:item];
                mainArr = nil;
                mainArr =  [filteredArray mutableCopy];
            }
        }
    }
    else
    {
        mainArr = globalArray;
    }
    
    [Table reloadData];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    NSLog(@"textFieldDidBeginEditing");
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    searchTF.text = @"";
    [searchTF resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSLog(@"textFieldShouldReturn:");
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    NSLog(@"touchesBegan:withEvent:");
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
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
