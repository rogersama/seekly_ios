//
//  MessageViewController.m
//  Seekly
//
//  Created by Deepinder singh on 21/05/15.
//  Copyright (c) 2015 Deepinder singh. All rights reserved.
//

#import "MessageViewController.h"
#import "NewMsgViewController.h"
#import "chatViewController.h"

@interface MessageViewController ()
{
    NSMutableArray *names;
}
@property (nonatomic, weak) IBOutlet UITabBar *tabBar;

@end

@implementation MessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;

    names = [[NSMutableArray alloc]init];
    filteredArray = [[NSMutableArray alloc]init];
    globalArray = [[NSMutableArray alloc ]init];
    
    obj = [self.storyboard instantiateViewControllerWithIdentifier:@"FriendsProfileView"];
    
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [searchView setHidden:YES];
    UIImage* tabBarBackground = [UIImage imageNamed:@"tabBack003"];
    [self.tabBarController.tabBar setBackgroundImage:tabBarBackground];
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

#pragma mark Table View Delegates

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 9;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MessagesTableViewCell *cell;
    if(cell == nil)
    {
        cell = (MessagesTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"MessagesCell" forIndexPath:indexPath];
    }
    
    cell.userImage.layer.cornerRadius = 25.0;
    cell.userImage.layer.masksToBounds = YES;
    cell.userProfileButton.layer.cornerRadius = 25.0;
    cell.userProfileButton.layer.masksToBounds = YES;
    
    //navigate to user profile
    cell.userProfileButton.tag =indexPath.row;
    [cell.userProfileButton addTarget:self action:@selector(navigateToUserProfile:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.userName.text = [NSString stringWithFormat:@"User %li",(long)indexPath.row+1];
    cell.msgText.text = [NSString stringWithFormat:@"Message %li",(long)indexPath.row+1];

    //user image
    cell.userImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"profile_pic_0%li",(long)indexPath.row+1]] ;
    
    // Add utility buttons
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:246.0/255.0 green:66.0/255.0 blue:40.0/255.0 alpha:1.0]
                                                icon:[UIImage imageNamed:@"delete_icon"]];
    [cell setRightUtilityButtons:rightUtilityButtons WithButtonWidth:150.0f];

    
    cell.rightUtilityButtons = rightUtilityButtons;
    cell.delegate = self;

    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.backgroundColor=[UIColor clearColor];


    return cell;
}

//- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
//    return YES;
//}

//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (editingStyle == UITableViewCellEditingStyleDelete) {
//        NSLog(@"delete");
//    }
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    chatViewController *objchat = [self.storyboard instantiateViewControllerWithIdentifier:@"chatViewControllerID"];
    [self.navigationController pushViewController:objchat animated:YES];

}

- (BOOL)swipeableTableViewCellShouldHideUtilityButtonsOnSwipe:(SWTableViewCell *)cell
{
    // allow just one cell's utility button to be open at once
    return YES;
}
- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index
{
    switch (index) {
        case 0:
        {
            // Delete button was pressed
            NSIndexPath *cellIndexPath = [Table indexPathForCell:cell];
            
         //   [_testArray[cellIndexPath.section] removeObjectAtIndex:cellIndexPath.row];
            [Table deleteRowsAtIndexPaths:@[cellIndexPath] withRowAnimation:UITableViewRowAnimationLeft];
            break;
        }
        default:
            break;
    }
}


-(void)navigateToUserProfile:(UIButton*)sender
{
    int index = sender.tag;
    NSLog(@"%i",index);
    
    
    obj.profileID = @"12bddc82-bcac-4cd2-b519-621b43430620";
    
    [self.navigationController pushViewController:obj animated:YES];
    
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

- (IBAction)writeNewMsg:(id)sender
{
    [searchView setHidden:YES];
    CGRect frame = Table.frame;
    frame.origin.y = 64;
    frame.size.height = frame.size.height+56;
    Table.frame = frame;
    isVisible = NO;

    NewMsgViewController *objMsg = [self.storyboard instantiateViewControllerWithIdentifier:@"NewMsgViewControllerID"];
    [self.navigationController pushViewController:objMsg animated:YES];
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


@end
