//
//  SettingViewController.m
//  Seekly
//
//  Created by Deepinder singh on 21/05/15.
//  Copyright (c) 2015 Deepinder singh. All rights reserved.
//

#import "SettingViewController.h"
#import "FAQViewController.h"
#import "TermsViewController.h"
#import "SignInViewController.h"

@interface SettingViewController ()
{
    NSMutableArray *names;
    MBProgressHUD*HUD;
    NSDictionary *dict;
}
@property (nonatomic, assign) NSInteger selectedRow;
@property (nonatomic, weak) IBOutlet UITabBar *tabBar;


@end

@implementation SettingViewController
@synthesize selectedRow;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    self.navigationItem.title = @"TODAY";
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
    
    screenSize=[[UIScreen mainScreen] bounds];
    
    names=[[NSMutableArray alloc]initWithObjects:@"MANAGE NOTIFICATION",@"SET RADIUS",@"INVITE FRIENDS",@"FAQ",@"RATE US",@"FOLLOW US ON SOCIAL NETWORK",@"GIVE US FEEDBACK",@"CHANGE PASSWORD",@"TERMS OF USE",@"LOG OUT" ,nil];
    selectedRow = names.count + 1;

    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    UIImage* tabBarBackground = [UIImage imageNamed:@"tabBack005"];
    [self.tabBarController.tabBar setBackgroundImage:tabBarBackground];
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

#pragma mark Table View Delegates

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return names.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELL"];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    
    cell.backgroundColor = [UIColor blackColor];
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 1, self.view.frame.size.width, 58)];
    backView.backgroundColor = [UIColor colorWithRed:35/255.0 green:35/255.0 blue:35/255.0 alpha:1];
    [cell addSubview:backView];
    
    if(indexPath.row == 1)
    {
        if(showDropDown == YES) {
            dropDownView = [[UIView alloc]initWithFrame:CGRectMake (0, 60, 320, 60)];
//            dropDownView.backgroundColor = [UIColor colorWithRed:28/255.0 green:28/255.0 blue:28/255.0 alpha:1];
            dropDownView.backgroundColor = [UIColor blackColor];
            
            UIFont * myFont = [UIFont fontWithName:@"LATO-BOLD" size:18];

            CGRect labelFrame = CGRectMake (screenSize.size.width/2 - 25, 65, 50, 40);
            sliderValLbl = [[UILabel alloc] initWithFrame:labelFrame];
            [sliderValLbl setFont:[UIFont fontWithName:@"LATO-BOLD" size:25]];
            sliderValLbl.textAlignment = NSTextAlignmentCenter;
            sliderValLbl.backgroundColor=[UIColor clearColor];
            sliderValLbl.textColor=[UIColor whiteColor];
            
//            labelFrame = CGRectMake (0, 61, 320, 59);
            labelFrame = CGRectMake (20, 30, 40, 20);
            UILabel* subLbl2 = [[UILabel alloc] initWithFrame:labelFrame];
            [subLbl2 setFont:myFont];
            subLbl2.backgroundColor=[UIColor blackColor];
            subLbl2.textColor=[UIColor whiteColor];
            subLbl2.text = @" 0 ";

            
//            labelFrame = CGRectMake (0, 121, 320, 59);
            labelFrame = CGRectMake (screenSize.size.width - 40, 30, 40, 20);
            UILabel * subLbl3 = [[UILabel alloc] initWithFrame:labelFrame];
            [subLbl3 setFont:myFont];
            subLbl3.backgroundColor=[UIColor blackColor];
            subLbl3.textColor=[UIColor whiteColor];
            subLbl3.text = @"100";
            
//            UISwitch *checkSwitch1 = [[UISwitch alloc]initWithFrame:CGRectMake(screenSize.size.width - 70, 15, 49, 31)];
//            UISwitch *checkSwitch2 = [[UISwitch alloc]initWithFrame:CGRectMake(screenSize.size.width - 70, 75, 49, 31)];
//            UISwitch *checkSwitch3 = [[UISwitch alloc]initWithFrame:CGRectMake(screenSize.size.width - 70, 135, 49, 31)];
            
            if (!radiusStr)
            {
                radiusStr = @"50";
            }
            
            UISlider *slider = [[UISlider alloc]initWithFrame:CGRectMake(50, 25, screenSize.size.width - 100, 31)];
            [slider addTarget:self action:@selector(slider:) forControlEvents:UIControlEventValueChanged];
            slider.minimumValue = 0;
            slider.maximumValue = 100;
            slider.minimumTrackTintColor = [UIColor greenColor];
            slider.value = [radiusStr floatValue];
            NSLog(@"%i",[radiusStr intValue]);
            int val = [[radiusStr stringByTrimmingCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]] intValue];
            [slider setValue:val animated:YES];
            sliderValLbl.text = [NSString stringWithFormat:@"%d",val];


            [dropDownView addSubview:sliderValLbl];
            [dropDownView addSubview:subLbl2];
            [dropDownView addSubview:subLbl3];
            [dropDownView addSubview:slider];
            
//            [dropDownView addSubview:checkSwitch1];
//            [dropDownView addSubview:checkSwitch2];
//            [dropDownView addSubview:checkSwitch3];

            [cell.contentView addSubview:dropDownView];
            [dropDownView setHidden:NO];
            
        } else {
            [dropDownView removeFromSuperview];
        }
    }

    
    UIButton *iconButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 20, 20, 20)];
    NSInteger IndexValue = indexPath.row + 1;
    [iconButton setImage:[UIImage imageNamed:[NSString stringWithFormat:@"setting_%li",(long)IndexValue]] forState:UIControlStateNormal];
    [backView addSubview:iconButton];
    
    UIFont * myFont = [UIFont fontWithName:@"LATO-LIGHT" size:15];
    CGRect labelFrame = CGRectMake (60, 0, 250, 60);
    UILabel *label = [[UILabel alloc] initWithFrame:labelFrame];
    [label setFont:myFont];
    label.lineBreakMode=NSLineBreakByWordWrapping;
    label.textColor=[UIColor whiteColor];
    [label setText:names[indexPath.row]];
    [backView addSubview:label];

    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.backgroundColor=[UIColor clearColor];
    return cell;
}

- (IBAction)slider:(UISlider *)sender {
    float value = [sender value];
    radiusStr = [NSString stringWithFormat:@"%f",value];
    int val = [[radiusStr stringByTrimmingCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]] intValue];
    sliderValLbl.text = [NSString stringWithFormat:@"%d",val];
    [[NSUserDefaults standardUserDefaults]setObject:radiusStr forKey:@"radiusStr"];
}

- (CGFloat)tableView:(UITableView *)_tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(selectedRow == indexPath.row)
    {
        return 180;
    }
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row==1)
    {
        if (showDropDown == NO) {
            selectedRow = 1;
            [dropDownView setHidden:NO];
            showDropDown = YES;
            [tableView reloadData];
        } else {
            selectedRow = names.count + 1;
            [dropDownView setHidden:YES];
            showDropDown = NO;
            [tableView reloadData];
        }
    }
    if(indexPath.row==3)
    {
        FAQViewController *objFAQ = [self.storyboard instantiateViewControllerWithIdentifier:@"FAQViewControllerID"];
        [self.navigationController pushViewController:objFAQ animated:YES];
    }
    if(indexPath.row==8)
    {
        TermsViewController *objTerms = [self.storyboard instantiateViewControllerWithIdentifier:@"TermsViewControllerID"];
        [self.navigationController pushViewController:objTerms animated:YES];
    }
    if(indexPath.row==9)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"Are you sure?" delegate:self cancelButtonTitle:@"Stick around" otherButtonTitles:@"Log out",   nil];
        [alert show];
    }

}


#pragma Alert View Delegate

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    // the user clicked OK
    if (buttonIndex == 1) {
        [self performSelector:@selector(logOut)];
    }
}


-(void) logOut
{
    HUD=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://seekly.azurewebsites.net/api/Category/GetCategories"] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:120.0];
    
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
                NSLog(@"success  == %@",dict);
                [[NSUserDefaults standardUserDefaults]setValue:nil forKey:@"UID"];
                SignInViewController *obj=[self.storyboard instantiateViewControllerWithIdentifier:@"SignInViewControllerID"];
                [self.navigationController pushViewController:obj animated:YES];

                [HUD hide:YES];
            }
        }
    }];
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
