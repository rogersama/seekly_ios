//
//  InterestSubCategoryViewController.m
//  Seekly
//
//  Created by Deepinder singh on 05/06/15.
//  Copyright (c) 2015 Deepinder singh. All rights reserved.
//

#import "InterestSubCategoryViewController.h"
#import "SeeklyAPI.h"
#import "CreateEventViewController.h"
@interface InterestSubCategoryViewController ()
{
    IBOutlet UITableView *TableView;
    MBProgressHUD *HUD;

    NSArray *categoryArray;
    NSMutableArray *SelectedCategoryArray,*mainArr,*rquestdUsrsIDArr;
    CGRect screenSize;
    NSUInteger SelectedIndex;
    BOOL Selected;
    NSString *previousIndex;
    IBOutlet UIView *searchBack;
    NSDictionary *dict;
    IBOutlet UIButton *searchBtn;
    //    UIImageView *imgView;
}
@end

@implementation InterestSubCategoryViewController

@synthesize categoryId;

- (void)viewDidLoad {
    [super viewDidLoad];
    
     NSLog(@"%@",categoryId);
    
    if (createEventSelected == YES)
    {
        [_backBtn setTitle:@"Done" forState:UIControlStateNormal];
        [_backBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [_backBtn addTarget:self action:@selector(doneBtnActn:) forControlEvents:UIControlEventTouchUpInside];
    }
    mainArr=[[NSMutableArray alloc]init];
    rquestdUsrsIDArr=[[NSMutableArray alloc]init];
    previousIndex = @"0";
    screenSize=[[UIScreen mainScreen] bounds];
    SelectedCategoryArray = [[NSMutableArray alloc]init];
    
//    categoryArray  = [[NSArray alloc]initWithObjects:@"AMERICAN FOOTBALL",@"BEACH VOLLEYBOLL",@"FOOTBALL", nil];
//    
//    SelectedCategoryArray  = [[NSMutableArray alloc]initWithObjects:@"0",@"0",@"0", nil];
    //
    SelectedCategoryArray = [[NSMutableArray alloc]init];
    [self performSelector:@selector(getServices)];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
//    if (createEventSelected == YES)
//    {
        [_backBtn setTitle:@"Done" forState:UIControlStateNormal];
        [_backBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [_backBtn addTarget:self action:@selector(doneBtnActn:) forControlEvents:UIControlEventTouchUpInside];
   // }
    categoryLbl.text = _categoryName;

}

-(void)doneBtnActn:(id)sender
{
        if (mainArr.count != 0)
        {
        
            [SelectedCategoryArray removeAllObjects];
            for (int i=0; i<mainArr.count; i++)
            {
                NSString *statusStr=[[mainArr objectAtIndex:i] valueForKey:@"selctnState"];
                if([statusStr intValue]==1)
                {
                    [SelectedCategoryArray addObject:[mainArr objectAtIndex:i]];
                }
            }
            if (SelectedCategoryArray.count != 0)
            {
                for (int i=0; i<SelectedCategoryArray.count; i++)
                {
                    [rquestdUsrsIDArr addObject:[[SelectedCategoryArray objectAtIndex:i]valueForKey:@"sub_category_id"]];
                }
                NSString *categName=[[SelectedCategoryArray objectAtIndex:0]valueForKey:@"sub_category_name"];
                NSLog(@"%@",rquestdUsrsIDArr);
                
                NSString *joinedComponents = [rquestdUsrsIDArr componentsJoinedByString:@","];
                if ([_isComingFromScreen isEqualToString:@"event"]) {
                    [self.delegate enteredCatIDs:self didFinishEnteringItem:categoryId :joinedComponents];
                }
                else if([_isComingFromScreen isEqualToString:@"group"])
                {
                    [self.delegate enteredCatIDsToGrp:self didFinishEnteringItem:categoryId :joinedComponents :categName];
                }else if([_isComingFromScreen isEqualToString:@"signup"])
                {
//                    [self.delegate enteredCatIDsToGrp:self didFinishEnteringItem:categoryId :joinedComponents :categName];
                    
                    [self.delegate enteredCatIDsAtSignup:self didFinishEnteringItem:joinedComponents];
//                    [self.navigationController popViewControllerAnimated:YES];

                }
            }
            else {
                [self.navigationController popViewControllerAnimated:YES];
            }
       
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void) getServices
{
    HUD=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *urlStr = [NSString stringWithFormat:@"http://seekly.azurewebsites.net/api/SubCategory/%@",categoryId];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlStr] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:120.0];
    
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
                if (dict.count>0)
                {
                    for (NSUInteger i=0 ; i <= [dict count] - 1; i++) {
                        NSMutableDictionary *temp=[[NSMutableDictionary alloc]init];
                        [temp setValue:[[dict valueForKey:@"sub_category_name"] objectAtIndex:i] forKey:@"sub_category_name"];
                        [temp setValue:[[dict valueForKey:@"id"] objectAtIndex:i] forKey:@"sub_category_id"];
                        [temp setValue:@"0" forKey:@"selctnState"];
                        [mainArr addObject:temp];
                        temp=nil;
                        
//                        [SelectedCategoryArray insertObject:@"0" atIndex:i];
                    }
                    SelectedIndex = [dict count] + 1;
                    Selected = NO;

                }
                prevIndex = [mainArr count];
                [TableView reloadData];
                [HUD hide:YES];
            }
        }
    }];
}

-(void)API_Response:(NSDictionary*)responseDict
{
    NSLog(@"%@",responseDict);
    if ([responseDict count]>0)
    {
        if ([[responseDict  objectForKey:@"status"]   isEqual: @"Ok"])
        {
            
            UIAlertView * registerSuccessAlert=[[UIAlertView alloc]initWithTitle:@"Sign Up" message:@"User details saved successfully." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            [registerSuccessAlert show];
            
        }
        else
        {
            UIAlertView * registerSuccessAlert=[[UIAlertView alloc]initWithTitle:@"Sign Up" message:@"An error occured. Please try again later." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            [registerSuccessAlert show];
            
        }
    }
    [HUD hide:YES];
}


-(IBAction)ShowSearchBar:(id)sender
{
    CGRect frame = searchBack.frame;
    
    UIImage *selected = [UIImage imageNamed:@"search_icon2"] ;
    UIImage *unselected = [UIImage imageNamed:@"search_icon"] ;
    
    if (frame.origin.y <= 20) {
        [searchBtn setImage:unselected forState:UIControlStateNormal];
        [UIView animateWithDuration:0.2 animations:^{
            CGRect frame = searchBack.frame;
            frame.origin.y = 64;
            searchBack.frame = frame;
            TableView.contentOffset = CGPointMake(0.0f, -44.0f);
        }];
    } else {
        [UIView animateWithDuration:0.2 animations:^{
            [searchBtn setImage:selected forState:UIControlStateNormal];
            CGRect frame = searchBack.frame;
            frame.origin.y = 0;
            searchBack.frame = frame;
            TableView.contentOffset = CGPointMake(0.0f, -20.0f);
            
        }];
    }
}


-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}


#pragma TableView Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [mainArr count];    //count number of row from counting array hear cataGorry is An Array
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
    
    UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(screenSize.size.width  - 50, 10, 30, 30)];
    UIImageView *sepratorImg = [[UIImageView alloc]initWithFrame:CGRectMake( 0, 49, screenSize.size.width, 1)];
    
    sepratorImg.image = [UIImage imageNamed:@"email_line.png"];
    
    UILabel *titleLbl = [[UILabel alloc]initWithFrame:CGRectMake(18, 10, 200, 30)];
    NSString *str = [NSString stringWithFormat:@"%@",[[mainArr objectAtIndex:indexPath.row] valueForKey:@"selctnState"]];
    
    
    if ([str isEqualToString:@"1"])
    {
        imgView.image = [UIImage imageNamed:@"icon"];
    }
    else
    {
        imgView.image = [UIImage imageNamed:@"check_circle"];
    }
    
    titleLbl.text = [NSString stringWithFormat:@"%@",[[mainArr valueForKey:@"sub_category_name"] objectAtIndex:indexPath.row]];
    titleLbl.font = [UIFont fontWithName:@"Lato" size:15.0];
    titleLbl.textColor = [UIColor whiteColor];
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
    
    NSMutableDictionary *tempDict1;
    if ([_isComingFromScreen isEqualToString:@"signup"])
    {
        NSMutableDictionary *tempDict=[[NSMutableDictionary alloc]initWithDictionary:[mainArr objectAtIndex:indexPath.row]];
        
        if ([[tempDict valueForKey:@"selctnState"] isEqualToString:@"0"]) {
            [tempDict setValue:@"1" forKey:@"selctnState"];
        }
        else
        {
            [tempDict setValue:@"0" forKey:@"selctnState"];
        }
        [mainArr replaceObjectAtIndex:indexPath.row  withObject:tempDict];
        [tableView reloadData];
        tempDict=nil;

    }
    else
    {
        NSMutableDictionary *tempDict=[[NSMutableDictionary alloc]initWithDictionary:[mainArr objectAtIndex:indexPath.row]];
        for (int i=0; i<mainArr.count; i++)
        {
            tempDict1=[[NSMutableDictionary alloc]initWithDictionary:[mainArr objectAtIndex:i]];
            NSString *statusStr=[tempDict1 valueForKey:@"selctnState"];
            if([statusStr intValue]==1)
            {
                [tempDict1 setValue:@"0" forKey:@"selctnState"];
                [mainArr replaceObjectAtIndex:i  withObject:tempDict1];
            }
        }
        
        if ([[tempDict valueForKey:@"selctnState"] isEqualToString:@"0"]) {
            [tempDict setValue:@"1" forKey:@"selctnState"];
            prevIndex = indexPath.row;
        }
        else
        {
            [tempDict setValue:@"0" forKey:@"selctnState"];
        }
        
        
        [mainArr replaceObjectAtIndex:indexPath.row  withObject:tempDict];
        [tableView reloadData];
        tempDict=nil;
    }
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
