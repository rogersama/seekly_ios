//
//  SearchViewController.m
//  Seekly
//
//  Created by Deepinder singh on 28/05/15.
//  Copyright (c) 2015 Deepinder singh. All rights reserved.
//

#import "SearchViewController.h"
#import "MBProgressHUD.h"

@interface SearchViewController ()
{
    MBProgressHUD *HUD;
    NSCache *cache;
}
@end

@implementation SearchViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:35/255.0 green:35/255.0 blue:35/255.0 alpha:1];
    searchTblV.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    screenSize=[[UIScreen mainScreen] bounds];
    // Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated
{
    displayMsgTxt.text=_msgText;
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (IBAction)backAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(IBAction)searchBtnAct:(id)sender
{
    [searchTxtFld resignFirstResponder];
    if (searchTxtFld.text.length>0) {
        if (searchTxtFld.text.length>1) {
            
            HUD=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
            HUD.labelFont=[UIFont systemFontOfSize:13];
            HUD.labelText=[NSString stringWithFormat:@"Fetching results..."];
            
            NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://seekly.azurewebsites.net/api/SearchEventByKeyword/%@",searchTxtFld.text]] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:120.0];
            
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
                        dict = [[dict valueForKey:@"lstEvents"] mutableCopy];
                        NSLog(@"success  ==%@",dict);
                        [searchTblV reloadData];
                        [HUD hide:YES];
                    }
                }
            }];
        }
        else
        {
            
            UIAlertView *alrt=[[UIAlertView alloc]initWithTitle:@"Search" message:@"Please enter more characters to search." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alrt show];
        }

    }
    else
    {
        UIAlertView *alrt=[[UIAlertView alloc]initWithTitle:@"Search" message:@"Please enter some characters to search." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alrt show];
    
    }
}

#pragma mark - textfield delegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
}


#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([dict count]>0)
    {
        searchTblV.hidden=NO;
        displayMsgTxt.hidden=YES;
    }
    else
    {
        searchTblV.hidden=YES;
        displayMsgTxt.hidden=NO;
    }
    
    return [dict count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *MyIdentifier = nil;
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:MyIdentifier];
        cell.backgroundColor = [UIColor blackColor];
    }
    
    UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, screenSize.size.width, 250)];
    UIImageView *locationView = [[UIImageView alloc]initWithFrame:CGRectMake(7, 30, 15 , 15)];
    UIImageView *timeView = [[UIImageView alloc]initWithFrame:CGRectMake(7, 55, 15, 15)];
    UIImageView *viewerView = [[UIImageView alloc]initWithFrame:CGRectMake(7, 80, 15, 15)];
    UIImageView *logoImgView = [[UIImageView alloc]initWithFrame:CGRectMake(screenSize.size.width - 140 , 10, 120 ,80)];
    
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(25 , 5, 150, 16)];
    UILabel *LocationLbl = [[UILabel alloc]initWithFrame:CGRectMake(25 , 30, 150, 15)];
    UILabel *dateTimeLbl = [[UILabel alloc]initWithFrame:CGRectMake(25 , 55, 150, 15)];
    UILabel *viewerLbl = [[UILabel alloc]initWithFrame:CGRectMake(25 , 80, 150, 15)];
    
    UIView *titldetailBackView = [[UIView alloc]initWithFrame:CGRectMake(0 , 250 -100   , screenSize.size.width, 100)];
    titldetailBackView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    UIView *titleBackView = [[UIView alloc]initWithFrame:CGRectMake(0 , 20  , 150, 20)];
    titleBackView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    
    UILabel *titleHeaderLbl = [[UILabel alloc]initWithFrame:CGRectMake(5 , 0, 140, 20)];
    titleHeaderLbl.textAlignment = NSTextAlignmentCenter;
    
    NSString *categoryStr;
    NSString *titleStr;
    NSString *LocStr;
    NSString *dateStr;
    NSString *memberCountStr;
    NSString* img1 = [NSString stringWithFormat:@"%@",[[dict valueForKey:@"sub_category_image1"]objectAtIndex:indexPath.row]];
    NSString* img2 = [NSString stringWithFormat:@"%@",[[dict valueForKey:@"sub_category_image2"]objectAtIndex:indexPath.row]];
    NSString* img3 = [NSString stringWithFormat:@"%@",[[dict valueForKey:@"sub_category_image3"]objectAtIndex:indexPath.row]];
    NSArray * array = [[NSArray alloc]initWithObjects:img1,img2,img3, nil];
    
    int rnd = arc4random()%[array count];
    
    NSString *path = [NSString stringWithFormat:@"%@",[array objectAtIndex:rnd]];
    
    path = [path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *url = [NSURL URLWithString:path];
    
    __block UIActivityIndicatorView *activityIndicator;
    __weak UIImageView *weakImageView = imgView;
    [imgView sd_setImageWithURL:url
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
                              imgView.image = [UIImage imageNamed:@"eventBack"];
                          }
                      }];
    
    logoImg = [UIImage imageNamed:@"logo_01"];
    
    categoryStr = [NSString stringWithFormat:@"%@",[[dict valueForKey:@"sub_category_name"]objectAtIndex:indexPath.row]];
    NSString *DateStr = [NSString stringWithFormat:@"%@",[[dict valueForKey:@"event_date"] objectAtIndex:indexPath.row]];
    NSArray *dateArray = [DateStr componentsSeparatedByString:@"T"];
    
    titleStr = [NSString stringWithFormat:@"%@",[[dict valueForKey:@"event_name"]objectAtIndex:indexPath.row]];
    LocStr = [NSString stringWithFormat:@"%@",[[dict valueForKey:@"event_location"]objectAtIndex:indexPath.row]];
    dateStr = dateArray [0];
    
    memberCountStr = [NSString stringWithFormat:@"%@ out of %@",[[dict valueForKey:@"total_user_Joined"] objectAtIndex:indexPath.row],[[dict valueForKey:@"total_user_Invited"] objectAtIndex:indexPath.row]];
    
    locationView.image = [UIImage imageNamed:@"location"];
    timeView.image = [UIImage imageNamed:@"time"];
    viewerView.image = [UIImage imageNamed:@"player"];
    
    logoImgView.contentMode = UIViewContentModeScaleAspectFit;
    logoImgView.image = logoImg;
    
    titleHeaderLbl.text = categoryStr;
    titleHeaderLbl.font = [UIFont fontWithName:@"Lato-Bold" size:14.0];
    titleHeaderLbl.textColor = [UIColor whiteColor];
    
    titleLabel.text = titleStr;
    titleLabel.font = [UIFont fontWithName:@"Lato-Regular" size:14.0];
    titleLabel.textColor = [UIColor whiteColor];
    
    LocationLbl.text = LocStr;
    LocationLbl.font = [UIFont fontWithName:@"Lato-Light" size:12.0];
    LocationLbl.textColor = [UIColor whiteColor];
    
    dateTimeLbl.text = dateStr;
    dateTimeLbl.font = [UIFont fontWithName:@"Lato-Light" size:12.0];
    dateTimeLbl.textColor = [UIColor whiteColor];
    
    viewerLbl.text = memberCountStr;
    viewerLbl.font = [UIFont fontWithName:@"Lato-Light" size:12.0];
    viewerLbl.textColor = [UIColor whiteColor];
    
    [cell.contentView addSubview:imgView];
    [cell.contentView addSubview:titleBackView];
    [cell.contentView addSubview:titldetailBackView];
    
    [titleBackView addSubview:titleHeaderLbl];
    [titldetailBackView addSubview:titleLabel];
    [titldetailBackView addSubview:LocationLbl];
    [titldetailBackView addSubview:dateTimeLbl];
    [titldetailBackView addSubview:viewerLbl];
    [titldetailBackView addSubview:logoImgView];
    [titldetailBackView addSubview:locationView];
    [titldetailBackView addSubview:timeView];
    [titldetailBackView addSubview:viewerView];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 250;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.backgroundColor = [UIColor clearColor];
}

- (void)didReceiveMemoryWarning
{
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
