//
//  CategoryDetailViewController.m
//  Seekly
//
//  Created by Deepinder singh on 15/05/15.
//  Copyright (c) 2015 Deepinder singh. All rights reserved.
//

#import "CategoryDetailViewController.h"

@interface CategoryDetailViewController ()
{
    IBOutlet UITableView *TableView;
    NSArray *categoryArray;
    NSMutableArray *SelectedCategoryArray;
    CGRect screenSize;
    NSUInteger SelectedIndex;
    BOOL Selected;
    NSString *previousIndex;
    //    UIImageView *imgView;
}


@end

@implementation CategoryDetailViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillApper
{
    previousIndex = @"0";
    screenSize=[[UIScreen mainScreen] bounds];
    SelectedCategoryArray = [[NSMutableArray alloc]init];
    
    categoryArray  = [[NSArray alloc]initWithObjects:@"AMERICAN FOOTBALL",@"BEACH VOLLEYBOLL",@"FOOTBALL",@"GOLF",@"RUNNING",@"SLACKLINE",@"TENNIS",@"WAKEBOARD",@"CRICKET", nil];
    
    SelectedCategoryArray = [[NSMutableArray alloc]initWithObjects:@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",nil];
    SelectedIndex = [categoryArray count] + 1;
    Selected = NO;

}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}


#pragma TableView Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [categoryArray count];    //count number of row from counting array hear cataGorry is An Array
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
    
    titleLbl.text = [NSString stringWithFormat:@"%@",[categoryArray objectAtIndex:indexPath.row]];
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

@end
