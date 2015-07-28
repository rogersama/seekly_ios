

#import "slideViewController.h"
//#import "NVSlideMenuController.h"
#import "CreateEventViewController.h"
#import "SearchViewController.h"


#define kTagSideMenuTblView 10
#define kTagNotificationsTblView 11
@interface slideViewController ()
{
    NSMutableArray *names,*images;
//    MBProgressHUD *HUD;
    int requestno;
    NSMutableArray *notificationsArr;
}

@property (nonatomic, assign) NSInteger selectedRow;

@end

@implementation slideViewController


@synthesize selectedRow;
- (void)viewDidLoad
{
    [super viewDidLoad];
    screenSize=[[UIScreen mainScreen] bounds];

    self.navigationController.navigationBarHidden=YES;
    self.view.backgroundColor = [UIColor colorWithRed:28/255.0 green:28/255.0 blue:28/255.0 alpha:1];
    sideMenuTbl.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    names=[[NSMutableArray alloc]initWithObjects:@"LIVE FEED",@"CREATE EVENT",@"SEARCH",@"SORT",@"GROUP EVENTS",@"MY EVENTS" ,nil];
    notificationsArr=[[NSMutableArray alloc]initWithObjects:@"Ben",@"CJ",nil];
    
    images=[[NSMutableArray alloc]initWithObjects:@"example user photo",@"example user medium profile", nil];
    
    profielPic.layer.cornerRadius = 35;
    profielPic.clipsToBounds = YES;
    profielPic.backgroundColor = [UIColor whiteColor];
    
    selectedRow = names.count + 1;

}

- (void)viewWillAppear:(BOOL)animated
{
    NSString *uName=[[NSUserDefaults standardUserDefaults]valueForKey:@"UName"];
    [UserName setTitle:uName forState:UIControlStateNormal];
    NSString *uImageUrl = [[NSUserDefaults standardUserDefaults]objectForKey:@"UImageUrl"];
    if (![uImageUrl isKindOfClass:[NSNull class]] || uImageUrl!= nil)
    {
        uImageUrl = [uImageUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        NSURL *url = [NSURL URLWithString:uImageUrl];
        
        __block UIActivityIndicatorView *activityIndicator;
        __weak UIImageView *weakImageView = profielPic;
        [profielPic sd_setImageWithURL:url
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
                                       profielPic.image = [UIImage imageNamed:@"eventPlaceholderImg"];
                                   }
                               }];
    }

}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Table View Delegates

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return names.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    
    cell.backgroundColor = [UIColor colorWithRed:28/255.0 green:28/255.0 blue:28/255.0 alpha:1];
    
    UIFont * myFont = [UIFont fontWithName:@"LATO-LIGHT" size:15];
    
    CGRect labelFrame = CGRectMake (30, 0, 200, 50);
    UILabel *label = [[UILabel alloc] initWithFrame:labelFrame];
    [label setFont:myFont];
    label.lineBreakMode=NSLineBreakByWordWrapping;
    label.textColor=[UIColor whiteColor];
    label.backgroundColor=[UIColor clearColor];
    [label setText:names[indexPath.row]];

    if(indexPath.row == 5)
    {
        UIImageView *arrowImg = [[UIImageView alloc]initWithFrame:CGRectMake (screenSize.size.width - 100, 17.5 , 15 , 15)];
        [cell.contentView addSubview:arrowImg];
        
        if(showDropDown == YES) {
            dropDownView = [[UIView alloc]initWithFrame:CGRectMake (0, 50, 320, 150)];
            dropDownView.backgroundColor = [UIColor colorWithRed:28/255.0 green:28/255.0 blue:28/255.0 alpha:1];
            arrowImg.image = [UIImage imageNamed:@"upArrow"];
            labelFrame = CGRectMake (0, 0, 320, 50);
            UIButton* subLbl1 = [[UIButton alloc] initWithFrame:labelFrame];
            [subLbl1.titleLabel setFont:myFont];

            subLbl1.titleLabel.textColor = [UIColor whiteColor];
            subLbl1.backgroundColor=[UIColor blackColor];
            [subLbl1 setTitle:@"UPCOMING                                 "forState:UIControlStateNormal];
            subLbl1.titleLabel.textAlignment = NSTextAlignmentLeft;
            [subLbl1 addTarget:self action:@selector(toggleSlideAnimated:) forControlEvents:UIControlEventTouchUpInside];
            subLbl1.tag = 100;
            
            labelFrame = CGRectMake (0, 51, 320, 49);
            UIButton* subLbl2 = [[UIButton alloc] initWithFrame:labelFrame];
            [subLbl2.titleLabel setFont:myFont];

            subLbl2.titleLabel.textAlignment = NSTextAlignmentLeft ;
            subLbl2.titleLabel.textColor = [UIColor whiteColor];
            [subLbl2 setTitle:@"AWAITING                                    "forState:UIControlStateNormal];
            subLbl2.backgroundColor=[UIColor blackColor];
            [subLbl2 addTarget:self action:@selector(toggleSlideAnimated:) forControlEvents:UIControlEventTouchUpInside];
            subLbl2.tag = 200;
            
            labelFrame = CGRectMake (0, 101, 320, 49);
            UIButton* subLbl3 = [[UIButton alloc] initWithFrame:labelFrame];
            [subLbl3.titleLabel setFont:myFont];

            subLbl3.titleLabel.textColor = [UIColor whiteColor];
            subLbl3.backgroundColor=[UIColor blackColor];
            [subLbl3 setTitle:@"PAST                                            "forState:UIControlStateNormal];
            //         subLbl3.titleLabel.textAlignment = NSTextAlignmentRight ;
            [subLbl3.titleLabel setTextAlignment:NSTextAlignmentLeft];
            [subLbl3 addTarget:self action:@selector(toggleSlideAnimated:) forControlEvents:UIControlEventTouchUpInside];
            subLbl3.tag = 300;
            
            [dropDownView addSubview:subLbl1];
            [dropDownView addSubview:subLbl2];
            [dropDownView addSubview:subLbl3];
            [cell.contentView addSubview:dropDownView];
            [dropDownView setHidden:NO];

        } else {
            arrowImg.image = [UIImage imageNamed:@"dropArrow"];
            [dropDownView removeFromSuperview];
        }
        
    }
    [cell.contentView addSubview:label];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.backgroundColor=[UIColor clearColor];
     [tableView setSeparatorInset:UIEdgeInsetsZero];
    return cell;
}

-(IBAction)toggleSlideAnimated:(id)sender
{
    indexVal = 5;
    if ([sender tag] == 100) {
        homeSelected = NO;
        UpcomingSelected = YES;
        AwaitingSelected = NO;
        pastSelected = NO;
        groupSelected = NO;
    } else if ([sender tag] == 200) {
        homeSelected = NO;
        UpcomingSelected = NO;
        AwaitingSelected = YES;
        pastSelected = NO;
        groupSelected = NO;
    } else if ([sender tag] == 300) {
        homeSelected = NO;
        UpcomingSelected = NO;
        AwaitingSelected = NO;
        pastSelected = YES;
        groupSelected = NO;
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"toggleLeftPan" object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"navigateToNextClasses" object:nil];
}

- (CGFloat)tableView:(UITableView *)_tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(selectedRow == indexPath.row)
    {
       return 200;
    }
    return 50;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0 || indexPath.row==1 || indexPath.row==2 || indexPath.row==3)
    {
        indexVal = indexPath.row;
        
        if (indexPath.row==0) {
            homeSelected = YES;
            UpcomingSelected = NO;
            AwaitingSelected = NO;
            pastSelected = NO;
        }
        else if (indexPath.row==4) {
            homeSelected = NO;
            UpcomingSelected = NO;
            AwaitingSelected = NO;
            pastSelected = NO;
            groupSelected = YES;
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"toggleLeftPan" object:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"navigateToNextClasses" object:nil];
    }
    
    if(indexPath.row==5)
    {
        if (showDropDown == NO) {
            selectedRow = 5;
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
    else if (indexPath.row==4)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"toggleLeftPan" object:nil];
    }
}

//- (IBAction)homeBtnAction:(id)sender {
//    [self performSelector:@selector(toggleSlideAnimated:) withObject:nil];
//    homeSelected = YES;
//    UpcomingSelected = NO;
//    AwaitingSelected = NO;
//    pastSelected = NO;
//}

@end
