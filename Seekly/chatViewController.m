//
//  chatViewController.m
//  Seekly
//
//  Created by Deepinder singh on 29/05/15.
//  Copyright (c) 2015 Deepinder singh. All rights reserved.
//

#import "chatViewController.h"

@interface chatViewController ()

@end

@implementation chatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    msgArray = [[NSMutableArray alloc]init];
    screenSize=[[UIScreen mainScreen] bounds];

    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(keyboardOnScreen:) name:UIKeyboardDidShowNotification object:nil];
    
    //    self.view.backgroundColor = [UIColor colorWithRed:28/255.0 green:28/255.0 blue:28/255.0 alpha:1];
    // Do any additional setup after loading the view.
}

-(void) viewWillAppear:(BOOL)animated
{
    if (_isFromGroup)
    {
        chatLbl.text = _groupName;
    }
    else
    {
        
    }
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (IBAction)backAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)keyboardOnScreen:(NSNotification *)notification
{
    NSDictionary *info  = notification.userInfo;
    NSValue      *value = info[UIKeyboardFrameEndUserInfoKey];
    
    CGRect rawFrame      = [value CGRectValue];
    CGRect keyboardFrame = [self.view convertRect:rawFrame fromView:nil];
    
    NSLog(@"keyboardFrame: %@", NSStringFromCGRect(keyboardFrame));
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField;
{
    if (textField == msgTxtFld) {
        [UIView animateWithDuration:0.2 animations:^{
            CGRect frame = messageBackView.frame;
            frame.origin.y = 308;
            messageBackView.frame = frame;
        }];
    }
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    [UIView animateWithDuration:0.2 animations:^{
        CGRect frame = messageBackView.frame;
        frame.origin.y = 524;
        messageBackView.frame = frame;
    }];
    return YES;
}

-(IBAction)sendAction:(id)sender
{
    
    [msgArray addObject:msgTxtFld.text];
    [msgTxtFld resignFirstResponder];
    msgTxtFld.text = @"";
    [TableView reloadData];
    [UIView animateWithDuration:0.2 animations:^{
        CGRect frame = messageBackView.frame;
        frame.origin.y = 524;
        messageBackView.frame = frame;
    }];
}

#pragma mark Table View Delegates

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return msgArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELL"];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    
    UIImageView *msgBubble = [[UIImageView alloc] initWithFrame:CGRectMake(screenSize.size.width - 300, 10, 300 ,60)];
//    NSInteger IndexValue = indexPath.row + 1;
    msgBubble.contentMode = UIViewContentModeScaleAspectFit;
    msgBubble.image = [UIImage imageNamed:@"comment_02"];
    [cell addSubview:msgBubble];
    
    UIFont * myFont = [UIFont fontWithName:@"LATO-LIGHT" size:15];
    CGRect labelFrame = msgBubble.frame;
    UILabel *label = [[UILabel alloc] initWithFrame:labelFrame];
    label.numberOfLines = 2;
    
    [label setFont:myFont];
    label.lineBreakMode=NSLineBreakByWordWrapping;
    label.textColor=[UIColor whiteColor];
    [label setText:[NSString stringWithFormat:@"   %@",[msgArray objectAtIndex:indexPath.row]]];
    [cell addSubview:label];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.backgroundColor=[UIColor clearColor];
    
    //make cell
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    [view setBackgroundColor:[UIColor greenColor]];
    //add Buttons to view
    
    cell.editingAccessoryView = view;
    
    return cell;
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
