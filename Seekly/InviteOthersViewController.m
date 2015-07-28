//
//  InviteOthersViewController.m
//  Seekly
//
//  Created by Deepinder singh on 06/07/15.
//  Copyright (c) 2015 Deepinder singh. All rights reserved.
//

#import "InviteOthersViewController.h"

@interface InviteOthersViewController ()
{
    IBOutlet UITableView *TableView;
    MBProgressHUD *HUD;
    
    NSArray *categoryArray;
    NSMutableArray *SelectedCategoryArray;
    CGRect screenSize;
    NSUInteger SelectedIndex;
    BOOL Selected;
    NSString *previousIndex;
    IBOutlet UIView *searchBack;
    NSDictionary *dict,*friendsDic,*groupsDic;
    IBOutlet UIButton *searchBtn;

}

@end

@implementation InviteOthersViewController
@synthesize eventId;

- (void)viewDidLoad {
    [super viewDidLoad];
    screenSize=[[UIScreen mainScreen] bounds];
    // Do any additional setup after loading the view.
    friendselected = NO;
    groupselected = NO;
    
    [self performSelector:@selector(getServices)];
}
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
                friendsDic = [[dict valueForKey:@"lstfriends"] mutableCopy];
                groupsDic = [[dict valueForKey:@"lstGroups"] mutableCopy];
                dict = [friendsDic mutableCopy];
                NSLog(@"friends  ==%@",friendsDic);
                NSLog(@"groups  ==%@",groupsDic);
                friendselected = YES;
                SelectedCategoryArray = [[NSMutableArray alloc]init];
                if (dict.count>0)
                {
                    for (NSUInteger i = 0 ; i <= [dict count] - 1; i++) {
                        [SelectedCategoryArray insertObject:@"0" atIndex:i];
                    }
                }

                [TableView reloadData];
                [HUD hide:YES];
            }
        }
    }];
}


#pragma TableView Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [dict count];    //count number of row from counting array hear cataGorry is An Array
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
    NSString *str = [NSString stringWithFormat:@"%@",[SelectedCategoryArray objectAtIndex:indexPath.row]];
    
    
    if ([str isEqualToString:@"1"])
    {
        imgView.image = [UIImage imageNamed:@"icon.png"];
    }
    else
    {
        imgView.image = [UIImage imageNamed:@"check_circle.png"];
    }
    
    if (friendselected ==YES)
    {
        NSString *fName = [NSString stringWithFormat:@"%@",[[dict  valueForKey:@"first_name"]objectAtIndex:indexPath.row]];
        NSString *lName = [NSString stringWithFormat:@"%@",[[dict  valueForKey:@"last_name"]objectAtIndex:indexPath.row]];
        titleLbl.text = [NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"%@ %@",fName,lName]];
    } else
    {
        NSString *fName = [NSString stringWithFormat:@"%@",[[dict  valueForKey:@"event_name"]objectAtIndex:indexPath.row]];
        titleLbl.text = fName;
    }
   
    titleLbl.font = [UIFont fontWithName:@"Lato" size:15.0];
    titleLbl.textColor = [UIColor blackColor];
    
    [cell addSubview:titleLbl];
    [cell addSubview:imgView];
    [cell addSubview:sepratorImg];
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *StatusStr = [SelectedCategoryArray objectAtIndex:indexPath.row];
    
    if ([StatusStr isEqualToString:@"1"])
    {
        Selected = NO;
        [SelectedCategoryArray replaceObjectAtIndex:indexPath.row withObject:@"0"];
        previousIndex = [NSString stringWithFormat:@"%ld",(long)[indexPath row]];
    }else {
        Selected = YES;
        [SelectedCategoryArray replaceObjectAtIndex:indexPath.row withObject:@"1"];
        previousIndex = [NSString stringWithFormat:@"%ld",(long)[indexPath row]];
    }
    [tableView reloadData];
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

- (IBAction)inviteFriendAction:(id)sender
{
    NSMutableArray *temp = [[NSMutableArray alloc]init];
    for (int i = 0; i<= [SelectedCategoryArray count] - 1; i++)
    {
        if ([[SelectedCategoryArray objectAtIndex:i] isEqualToString:@"1"])
        {
            [temp addObject:[[dict valueForKey:@"id"]objectAtIndex:i]];
        }
    }
    
    NSString *joinedComponents = [temp componentsJoinedByString:@","];
    if ([temp count] > 0)
    {
        NSURL *url = [NSURL URLWithString:@"http://seekly.azurewebsites.net/api/EventInvitation/EventInvitation"];
        
        NSLog(@"%@",[[NSUserDefaults standardUserDefaults]valueForKey:@"UID"]);
        
        // Create the request
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
        [request setRequestMethod:@"POST"];
        [request setPostValue:[[NSUserDefaults standardUserDefaults]valueForKey:@"UID"]  forKey:@"user_id_whos_event"];
        [request setPostValue:self.eventId  forKey:@"event_id"];
        [request setPostValue:joinedComponents  forKey:@"user_id_whos_invited"];
        
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

    } else
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Please select any friend or group to send invitation" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    }
}

- (IBAction)friendAction:(id)sender
{
    dict = [friendsDic mutableCopy];
    SelectedCategoryArray = [[NSMutableArray alloc]init];
    if (dict.count>0)
    {
        for (NSUInteger i = 0 ; i <= [dict count] - 1; i++) {
            [SelectedCategoryArray insertObject:@"0" atIndex:i];
        }
    }

    [friendBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [friendBtn setBackgroundColor:[UIColor whiteColor]];
    
    [groupBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [groupBtn setBackgroundColor:[UIColor blackColor]];
    
    friendselected = YES;
    groupselected = NO;
    
    [TableView reloadData];
    
    
}

- (IBAction)groupAction:(id)sender
{
    dict = [groupsDic mutableCopy];
    SelectedCategoryArray = [[NSMutableArray alloc]init];
    if (dict.count>0)
    {
        for (NSUInteger i = 0 ; i <= [dict count] - 1; i++) {
            [SelectedCategoryArray insertObject:@"0" atIndex:i];
        }
    }

    
    [groupBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [groupBtn setBackgroundColor:[UIColor whiteColor]];
    
    [friendBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [friendBtn setBackgroundColor:[UIColor blackColor]];
    
    friendselected = NO;
    groupselected = YES;

    
    [TableView reloadData];
    
}
@end
