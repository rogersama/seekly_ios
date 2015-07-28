//
//  MyInterestViewController.m
//  Seekly
//
//  Created by Deepinder singh on 24/07/15.
//  Copyright (c) 2015 Deepinder singh. All rights reserved.
//

#import "MyInterestViewController.h"

@interface MyInterestViewController ()
{
    MBProgressHUD *HUD;
}

@end

@implementation MyInterestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    screenSize=[[UIScreen mainScreen] bounds];
    [self performSelector:@selector(getMyInterest)];
    // Do any additional setup after loading the view.
}

-(void) getMyInterest
{
    HUD=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSString *urlsTr = [NSString stringWithFormat:@"http://seekly.azurewebsites.net/api/UserInterests/%@",[[NSUserDefaults standardUserDefaults]valueForKey:@"UID"]];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlsTr] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:120.0];
    
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
                NSLog(@"success  ==%@",dict);
                dict = [[dict valueForKey:@"lstEvents"]mutableCopy];
                [TblView reloadData];
                [HUD hide:YES];
            }
        }
    }];
}


#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([dict count]>0) {
        [TblView setHidden:NO];
    } else
    {
        [TblView setHidden:YES];
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
        cell.backgroundColor = [UIColor whiteColor];
    }
    
    UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, screenSize.size.width, 250)];
    UIImageView *CheckImgView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 40 , 40)];
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(60 , 0, 150, 60)];
    UIView *titldetailBackView = [[UIView alloc]initWithFrame:CGRectMake(0 , 250 - 60   , screenSize.size.width, 60)];
    titldetailBackView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    NSString* img1 = [NSString stringWithFormat:@"%@",[[dict valueForKey:@"sub_category_image1"]objectAtIndex:indexPath.row]];
    NSString* img2 = [NSString stringWithFormat:@"%@",[[dict valueForKey:@"sub_category_image2"]objectAtIndex:indexPath.row]];
    NSString* img3 = [NSString stringWithFormat:@"%@",[[dict valueForKey:@"sub_category_image3"]objectAtIndex:indexPath.row]];
    NSArray * array = [[NSArray alloc]initWithObjects:img1,img2,img3, nil];
    
    int rnd = arc4random()%[array count];
    
    NSString *path = [NSString stringWithFormat:@"%@",[array objectAtIndex:rnd]];
    
    path = [path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *url = [NSURL URLWithString:path];
    
    NSString *titleStr;
    
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
    
    CheckImgView.image = [UIImage imageNamed:@"icon"];
    
    titleStr = [NSString stringWithFormat:@"%@",[[dict valueForKey:@"sub_category_name"]objectAtIndex:indexPath.row]];
    
    titleLabel.text = titleStr;
    titleLabel.font = [UIFont fontWithName:@"Lato-Regular" size:20.0];
    titleLabel.textColor = [UIColor whiteColor];
    
    [cell.contentView addSubview:imgView];
    [cell.contentView addSubview:titldetailBackView];
    [titldetailBackView addSubview:CheckImgView];
    [titldetailBackView addSubview:titleLabel];

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return  UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSLog(@"delete");
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 250;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.backgroundColor = [UIColor clearColor];
}

- (IBAction)backButton:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
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
