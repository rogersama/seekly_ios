//
//  inviteFriendsViewController.m
//  Seekly
//
//  Created by Deepinder singh on 11/06/15.
//  Copyright (c) 2015 Deepinder singh. All rights reserved.
//

#import "inviteFriendsViewController.h"
#import "MBProgressHUD.h"
@interface inviteFriendsViewController ()
{
    MBProgressHUD *HUD;
    NSDictionary *dict;
}
@end

@implementation inviteFriendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    mainArr=[[NSMutableArray alloc]init];
    rquestdUsrsIDArr=[[NSMutableArray alloc]init];
    [self performSelector:@selector(getServices)];
    screenSize=[[UIScreen mainScreen] bounds];
    SelectedCategoryArray=[[NSMutableArray alloc]init];
    screenSize=[[UIScreen mainScreen] bounds];

    // Do any additional setup after loading the view.
}

//-(void) getServices
//{
//    HUD=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    
//    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://seekly.azurewebsites.net/api/SignUp"] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:120.0];
//    
//    [NSURLConnection sendAsynchronousRequest:urlRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *responce,NSData *data, NSError *connectionError){
//        NSError *error = nil;
//        if (![data isKindOfClass:[NSNull class]] && data!= nil)
//        {
//            dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
//            if (error)
//            {
//                NSLog(@"fail  ==%@",error);
//            }
//            else
//            {
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
//                 NSLog(@"mainArr  ==%@",mainArr);
//                [frndsListtblV reloadData];
//                [HUD hide:YES];
//            }
//        }
//    }];
//}

-(void) getServices
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
                mainArr = [[dict valueForKey:@"lstfriends"] mutableCopy];
//                friendselected = YES;
                SelectedCategoryArray = [[NSMutableArray alloc]init];
                if (dict.count>0)
                {
                    for (NSUInteger i = 0 ; i <= [dict count] - 1; i++) {
                        [SelectedCategoryArray insertObject:@"0" atIndex:i];
                    }
                }
                [frndsListtblV reloadData];
                [HUD hide:YES];
            }
        }
    }];
}

#pragma TableView Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (mainArr.count == 0) {
        [frndsListtblV setHidden:YES];
    } else
    {
        [frndsListtblV setHidden:NO];
    }
    return mainArr.count;    //count number of row from counting array here cateGory is An Array
}



- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *MyIdentifier = nil;
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:MyIdentifier];
    }
    
    cell.backgroundColor = [UIColor colorWithRed:17.0 green:17.0 blue:17.0 alpha:0];
    //    cell.backgroundColor = [UIColor blackColor];
    
    //    // Here we use the provided setImageWithURL: method to load the web image
    //    // Ensure you use a placeholder image otherwise cells will be initialized with no image
    
    UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(screenSize.size.width  - 50, 10, 30, 30)];
    UIImageView *sepratorImg = [[UIImageView alloc]initWithFrame:CGRectMake( 0, 49, screenSize.size.width, 1)];
    
    sepratorImg.image = [UIImage imageNamed:@"email_line.png"];
    
    UILabel *titleLbl = [[UILabel alloc]initWithFrame:CGRectMake(18, 10, 200, 30)];
    NSString *str = [NSString stringWithFormat:@"%@",[[mainArr objectAtIndex:indexPath.row] valueForKey:@"selectnState"]];
    
    
    if ([str isEqualToString:@"1"])
    {
        imgView.image = [UIImage imageNamed:@"icon.png"];
    }
    else
    {
        imgView.image = [UIImage imageNamed:@"check_circle.png"];
    }
    
    
    NSString *fName = [NSString stringWithFormat:@"%@",[[mainArr  valueForKey:@"first_name"]objectAtIndex:indexPath.row]];
    NSString *lName = [NSString stringWithFormat:@"%@",[[mainArr  valueForKey:@"last_name"]objectAtIndex:indexPath.row]];
    titleLbl.text = [NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"%@ %@",fName,lName]];

//    titleLbl.text = [[mainArr valueForKey:@"first_name"] objectAtIndex:indexPath.row];
    titleLbl.font = [UIFont fontWithName:@"Lato" size:15.0];
    titleLbl.textColor = [UIColor blackColor];
    [cell addSubview:titleLbl];
    [cell addSubview:imgView];
    [cell addSubview:sepratorImg];
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    return cell;
}
-(IBAction)sendInviteBtnActn:(id)sender
{
    HUD=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
   [SelectedCategoryArray removeAllObjects];
    
    for (int i=0; i<mainArr.count; i++)
    {
        NSString *statusStr=[[mainArr objectAtIndex:i] valueForKey:@"selectnState"];
        if([statusStr intValue]==1)
        {
            [SelectedCategoryArray addObject:[mainArr objectAtIndex:i]];
        }
    }
    [rquestdUsrsIDArr removeAllObjects];
    
    for (int i=0; i<SelectedCategoryArray.count; i++) {
        [rquestdUsrsIDArr addObject:[[SelectedCategoryArray objectAtIndex:i]valueForKey:@"id"]];
        
    }
    NSLog(@"%@",rquestdUsrsIDArr);
    
    NSString *joinedComponents = [rquestdUsrsIDArr componentsJoinedByString:@","];
    if (rquestdUsrsIDArr.count>0)
    {
        NSURL *url = [NSURL URLWithString:@"http://seekly.azurewebsites.net/api/GroupInvitation/GroupInvitation"];
        
        NSLog(@"%@",[[NSUserDefaults standardUserDefaults]valueForKey:@"UID"]);
        
        // Create the request
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
        [request setRequestMethod:@"POST"];
        [request setPostValue:[[NSUserDefaults standardUserDefaults]valueForKey:@"UID"]  forKey:@"user_id"];
        [request setPostValue:_group_Id  forKey:@"group_id"];
        [request setPostValue:joinedComponents  forKey:@"reciever_user_id"];
        
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
                [HUD hide:YES];
                [self.navigationController popViewControllerAnimated:YES];
            } else {
                [HUD hide:YES];
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Exception" message:[NSString stringWithFormat:@"%@",[responseDict  objectForKey:@"Exception"]] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [alert show];
            }
        }
        else
        {
            NSLog(@"Error------->>");
        }
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Please select any friend to send invitation" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableDictionary *tempDict=[[NSMutableDictionary alloc]initWithDictionary:[mainArr objectAtIndex:indexPath.row]];
    
    if ([[tempDict valueForKey:@"selectnState"] isEqualToString:@"0"]) {
        [tempDict setValue:@"1" forKey:@"selectnState"];
//        [SelectedCategoryArray addObject:tempDict];
    }
    else
    {
        [tempDict setValue:@"0" forKey:@"selectnState"];
//        [SelectedCategoryArray removeObjectIdenticalTo:tempDict];
    }
    [mainArr replaceObjectAtIndex:indexPath.row  withObject:tempDict];
    
    
    
    [tableView reloadData];
    tempDict=nil;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = [UIColor clearColor];
}

- (IBAction)backAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
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
