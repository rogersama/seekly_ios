//
//  InterestCategoryViewController.m
//  Seekly
//
//  Created by Deepinder singh on 14/05/15.
//  Copyright (c) 2015 Deepinder singh. All rights reserved.
//

#import "InterestCategoryViewController.h"
#import "TabBarExampleViewController.h"
#import "slideViewController.h"
#import "NVSlideMenuController.h"
#import "SeeklyAPI.h"


@interface InterestCategoryViewController ()
{
    IBOutlet UITableView *TblView;
    NSArray *categoryArray;
    NSArray *imgArray;
    MBProgressHUD *HUD;
    CGRect screenSize;
    IBOutlet UIView *searchBack;
    IBOutlet UIButton *searchBtn;
    UIImage *img;
    NSCache *cache;
    NSDictionary *cacheDir;

}


@end

@implementation InterestCategoryViewController

//[24/07/15 12:08:26 am] Manjit Singh:
//[24/07/15 12:08:48 am] Manjit Singh: parameters:user_id
//sub_intersts

-(void) AddEvents
{
    HUD=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSURL *url = [NSURL URLWithString:@"http://seekly.azurewebsites.net/api/UserInterests/AddUserInterests"];
    NSString *uid=[[NSUserDefaults standardUserDefaults]valueForKey:@"UID"];
    
    // Create the request
    NSString *AllsubCatIds = [subCatArr componentsJoinedByString:@","];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setRequestMethod:@"POST"];
    [request setPostValue:uid forKey:@"userid"];
    [request setPostValue:AllsubCatIds forKey:@"sub_intersts"];
    
    [request setDelegate:self];
    [request startSynchronous];
    NSDictionary * responseDict;
    NSError *error = [request error];
    if (!error)
    {
        //        BlankEventTitle.text = @"Swipe to the right and see if there is something going on later,or create an event yourself today";
        NSLog(@"dict is :%@",responseDict);
        self.viewController = [[JASidePanelController alloc] init];
        self.viewController.shouldDelegateAutorotateToVisiblePanel = NO;
        
        self.viewController.leftPanel = [self.storyboard instantiateViewControllerWithIdentifier:@"slideMenuVC"];
        
        self.viewController.centerPanel = [[UINavigationController alloc] initWithRootViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"TabVCID"]];
        
        self.view.window.rootViewController = self.viewController;
        [self.view.window makeKeyAndVisible];
        homeSelected = YES;

    }
    
 else {
            [HUD hide:YES];
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Exception" message:[NSString stringWithFormat:@"%@",[responseDict  objectForKey:@"Exception"]] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
        }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.tintColor = [UIColor whiteColor];
    
    screenSize=[[UIScreen mainScreen] bounds];
    
    [TblView setContentOffset:CGPointMake(0, -1) animated:NO];
     [TblView setContentOffset:CGPointMake(0, 0) animated:NO];
    categoryArray  = [[NSArray alloc]init];
    
    imgArray = [[NSArray alloc]init];
    subCatArr = [[NSMutableArray alloc]init];
    
    imgArray = [[NSArray alloc]init];
    Arr = [[NSMutableArray alloc]init];
    filteredArray = [[NSMutableArray alloc]init];
    globalArray = [[NSMutableArray alloc]init];

    
    array = [[NSArray alloc]initWithObjects:@"pic-01",@"pic-02",@"pic-03",@"pic-04",@"pic-05",@"pic-06",@"pic-07",@"pic-08",@"pic-09", nil];
    cache = [[NSCache alloc]init];
    [self performSelector:@selector(getServices)];
}

//-(void)hitWS
//{
//    HUD=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    
//    NSURL *url = [NSURL URLWithString:@"http://seekly.azurewebsites.net/api/Category/GetCategories"];
//    
//    // Create the request
//    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
////    [request setRequestMethod:@"GET"];
//    
////    [request setPostValue:@"e80184d9-28c4-4662-81a9-bf9a3cd5c4ce" forKey:@"category_id"];
//
//    [request setDelegate:self];
//    [request startSynchronous];
//    
//    
//    NSError *error = [request error];
//    if (!error)
//    {
//        NSString *response = [request responseString];
//        response=  [response stringByReplacingOccurrencesOfString:@"\\" withString:@""];
//        NSLog(@"Responce is%@",response);
//        
//        NSDictionary *responseDict = [response JSONValue];
//        NSLog(@"dict is :%@",responseDict);
//        if ([[NSString stringWithFormat:@"%@",[responseDict  objectForKey:@"Status"]] isEqual: @"1"])
//        {
//            [HUD hide:YES];
//            [TblView reloadData];
//        } else {
//            [HUD hide:YES];
//            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Exception" message:[NSString stringWithFormat:@"%@",[responseDict  objectForKey:@"Exception"]] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
//            [alert show];
//
//        }
//    }
//}

-(void) getServices
{
    HUD=[MBProgressHUD showHUDAddedTo:self.view animated:YES];

    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://seekly.azurewebsites.net/api/Category/GetCategories"] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:120.0];
    
    [NSURLConnection sendAsynchronousRequest:urlRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *responce,NSData *data, NSError *connectionError){
        NSError *error = nil;
        if (![data isKindOfClass:[NSNull class]] && data!= nil)
        {
            NSDictionary* dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
            
            if (error)
            {
                NSLog(@"fail  ==%@",error);
            }
            else
            {
                NSLog(@"success  ==%@",dict);
                Arr = [[dict valueForKey:@"lstCategories"]mutableCopy];
                
                NSSortDescriptor* brandDescriptor = [[NSSortDescriptor alloc] initWithKey:@"cat_name" ascending:YES];
                NSArray* sortDescriptors = [NSArray arrayWithObject:brandDescriptor];
                NSArray* sortedArray = [Arr sortedArrayUsingDescriptors:sortDescriptors];
                
                Arr = nil;
                Arr = [sortedArray mutableCopy];
                globalArray = Arr;

                [TblView reloadData];
                [HUD hide:YES];
            }
        }
    }];
}

//-(void)newMethodCallApi
//{
//    HUD=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
//
//    NSMutableDictionary * combinedAttributes = [[NSMutableDictionary alloc]init];
//
//    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://seekly.azurewebsites.net/api/Category/GetCategories"] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:120.0];
//    
//    NSURLResponse * response = nil;
//    
//     NSData * dataValue = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:&error];
//
//    NSError *error;
//    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:combinedAttributes options:NSJSONWritingPrettyPrinted error:&error];
//    if (!error) {
//        [request setHTTPMethod:@"GET"];
//        //        [request setValue:@"appication/json" forKey:@"Content-Type"];
//        [request setHTTPBody:jsonData];
//        [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *responce,NSData *data, NSError *connectionError){
//            NSError *error = nil;
//            if (![data isKindOfClass:[NSNull class]] && data!= nil)
//            {
//                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
//                if (error)
//                {
//                    NSLog(@"fail  ==%@",error);
//                }
//                else
//                {
//                    NSLog(@"success  ==%@",dict);
//                }
//            }
//        }];
//    }
//
//}

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

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
            TblView.contentOffset = CGPointMake(0.0f, -44.0f);
        }];
    } else {
        [UIView animateWithDuration:0.2 animations:^{
            [searchBtn setImage:selected forState:UIControlStateNormal];
            CGRect frame = searchBack.frame;
            frame.origin.y = 0;
            searchBack.frame = frame;
            TblView.contentOffset = CGPointMake(0.0f, -20.0f);
        }];
    }
}

#pragma Sub Category Selectn Delegate

-(void)enteredCatIDs:(InterestSubCategoryViewController *)controller didFinishEnteringItem:(NSString *)categID :(NSString *)subCatIDArr
{
    [self.delegate enteredCatIDSubCatIds:self didFinishEnteringItem:categID :subCatIDArr];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)enteredCatIDsToGrp:(InterestSubCategoryViewController *)controller didFinishEnteringItem:(NSString *)categID :(NSString *)subCatIDArr :(NSString *)subCatName
{
    if ([_isComingFrom isEqualToString:@"event"])//create group view controller
    {
        [self.delegate enteredSubCatIDToGrp:self didFinishEnteringItem:categID :subCatIDArr :subCatName];
        [self.navigationController popViewControllerAnimated:YES];
    }
    else if ([_isComingFrom isEqualToString:@"EditGroup"])
    {
        [self.delegate enteredSubCatIDToEditGrp:self didFinishEnteringItem:categID :subCatIDArr :subCatName];
        [self.navigationController popViewControllerAnimated:YES];
        
    } else if ([_isComingFrom isEqualToString:@"signup"])
    {
//        [self.delegate enteredSubCatIDToEditGrp:self didFinishEnteringItem:categID :subCatIDArr :subCatName];
//        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        [self.delegate enteredSubCatIDToGrp:self didFinishEnteringItem:categID :subCatIDArr :subCatName];
        [self.navigationController popViewControllerAnimated:YES];
        
    }
}

-(void)enteredCatIDsAtSignup:(InterestSubCategoryViewController *)controller didFinishEnteringItem:(NSString *)subCatIDArr
{
    NSArray *catIds = [subCatIDArr componentsSeparatedByString:@","];
    [subCatArr addObjectsFromArray:catIds];
    NSLog(@"CatIds-->%@",subCatArr);
    [self.navigationController popViewControllerAnimated:YES];
}




#pragma TableView Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [Arr count];    //count number of row from counting array hear cataGorry is An Array
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
    
    //    // Here we use the provided setImageWithURL: method to load the web image
    //    // Ensure you use a placeholder image otherwise cells will be initialized with no image
    
    
    UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, screenSize.size.width, screenSize.size.height*.2641 - 1)];
    UILabel *titleLbl = [[UILabel alloc]initWithFrame:CGRectMake(20 , screenSize.size.height*.2641/2-10, 200, 20)];
    
    UIActivityIndicatorView *activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    activity.frame = CGRectMake(50, 50, 200, 250);
    [imgView addSubview:activity];
    
    
    UIButton *ArrowBtn = [[UIButton alloc]initWithFrame:CGRectMake(screenSize.size.width - 40, screenSize.size.height*.2641/2-15, 30, 30)];
    [ArrowBtn setImage:[UIImage imageNamed:@"arrow1"]forState:UIControlStateNormal];
    
    NSString   *urlString = [NSString stringWithFormat:@"%@",[[Arr valueForKey:@"cat_image"]objectAtIndex:indexPath.row]];
    
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *url = [NSURL URLWithString:urlString];
    
//    __block UIActivityIndicatorView *activityIndicator;
//    __weak UIImageView *weakImageView = imgView;
//    [imgView sd_setImageWithURL:url
//               placeholderImage:nil
//                        options:SDWebImageProgressiveDownload
//                       progress:^(NSInteger receivedSize, NSInteger expectedSize) {
//                           if (!activityIndicator) {
//                               [weakImageView addSubview:activityIndicator = [UIActivityIndicatorView.alloc initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray]];
//                               activityIndicator.center = weakImageView.center;
//                               [activityIndicator startAnimating];
//                           }
//                       }
//                      completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//                          [activityIndicator removeFromSuperview];
//                          activityIndicator = nil;
//                          if (!image)
//                          {
//                              imgView.image = [UIImage imageNamed:@"pic-01"];
//                          }
//                      }];
    
    
    
//    int rnd = arc4random()%[array count];
    
    NSString *path = [NSString stringWithFormat:@"%@",[array objectAtIndex:indexPath.row]];

//    imgView.image = [UIImage imageNamed:@"pic-09"];
    imgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",path]];
    
    NSString *categoryName = [NSString stringWithFormat:@"%@",[[Arr valueForKey:@"cat_name"]objectAtIndex:indexPath.row]];
    categoryName = [categoryName uppercaseString];

    titleLbl.text = categoryName;
    titleLbl.font = [UIFont fontWithName:@"Lato-Bold" size:18.0];
    titleLbl.textColor = [UIColor whiteColor];
    imgView.layer.cornerRadius = 15 ;
    [cell.contentView addSubview:imgView];
    [cell.contentView addSubview:titleLbl];
    [cell.contentView addSubview:ArrowBtn];
    cell.contentView.backgroundColor = [UIColor lightGrayColor];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return screenSize.size.height*.2641;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    InterestSubCategoryViewController *objintrst = [self.storyboard instantiateViewControllerWithIdentifier:@"CategoryDetailID"];
    objintrst.delegate=self;
    objintrst.categoryId = [NSString stringWithFormat:@"%@",[[Arr valueForKey:@"id"]
                                                             objectAtIndex:indexPath.row]];
    objintrst.categoryName = [NSString stringWithFormat:@"%@",[[Arr valueForKey:@"cat_name"]
                                                              objectAtIndex:indexPath.row]];
//    if ([_isComingFrom isEqualToString:@"event"]) {
//        objintrst.isComingFromScreen=@"event";
//    }
//    else
//    {
//        objintrst.isComingFromScreen=@"group";
//    }
    
    objintrst.isComingFromScreen = _isComingFrom;
    [self.navigationController pushViewController:objintrst animated:YES];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.backgroundColor = [UIColor clearColor];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender 
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)doneAction:(id)sender
{
    if (createEventSelected == YES)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        [self performSelector:@selector(AddEvents)];

    }
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
        Arr = globalArray;
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

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
        if ([string isEqualToString:@""]) {
            searchTextString = searchTF.text;
            searchTextString = [searchTextString substringToIndex:[searchTextString length] - 1];
            Arr = globalArray;
        } else
        {
            searchTextString = searchTF.text;
            searchTextString = [searchTextString stringByAppendingString:string];
        }

//    searchTextString = string;
    if (searchTextString.length == 0)
    {
        Arr = globalArray;
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
    if (searchTextString.length != 0) {
        filteredArray = [NSMutableArray array];
        for ( NSDictionary* item in Arr ) {
            if ([[[item objectForKey:@"cat_name"] lowercaseString] rangeOfString:[searchTextString lowercaseString]].location != NSNotFound) {
                [filteredArray addObject:item];
                Arr = nil;
                Arr =  [filteredArray mutableCopy];
            }
        }
    }
    else
    {
        Arr = globalArray;
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


@end
