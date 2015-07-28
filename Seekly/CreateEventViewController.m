//
//  MyEventViewController.m
//  Seekly
//
//  Created by Deepinder singh on 28/05/15.
//  Copyright (c) 2015 Deepinder singh. All rights reserved.
//

#import "CreateEventViewController.h"
#import "InterestCategoryViewController.h"
#import "IQUIView+Hierarchy.h"
#import "IQKeyboardManager.h"
#import "IQKeyboardReturnKeyHandler.h"

BOOL CreateEventPressed;

@interface CreateEventViewController ()
{
    MBProgressHUD *HUD;
     IQKeyboardReturnKeyHandler *returnKeyHandler;
    NSMutableArray *ageCountArr;
    UIPickerView *slotSelect,*languageSelect;
    
}

@end

@implementation CreateEventViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    ageCountArr=[[NSMutableArray alloc]init];
    for (int i=13; i<=115; i++) {
        [ageCountArr addObject:[NSString stringWithFormat:@"%d",i]];
    }
    gender = 3;

    self.view.backgroundColor = [UIColor colorWithRed:35/255.0 green:35/255.0 blue:35/255.0 alpha:1];
    
    returnKeyHandler = [[IQKeyboardReturnKeyHandler alloc] initWithViewController:self];
    UIColor *color = [UIColor whiteColor];
    txtFld1.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"ADD TITLE*" attributes:@{NSForegroundColorAttributeName: color}];
    txtFld2.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"LOCATION*" attributes:@{NSForegroundColorAttributeName: color}];
    txtFld3.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"DATE AND TIME*" attributes:@{NSForegroundColorAttributeName: color}];
    txtFld4.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"OPEN SLOTS" attributes:@{NSForegroundColorAttributeName: color}];
    txtFld5.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"DESCRIPTION*" attributes:@{NSForegroundColorAttributeName: color}];
    txtFld6.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"STATUS*" attributes:@{NSForegroundColorAttributeName: color}];
    txtFld7.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"GENDER" attributes:@{NSForegroundColorAttributeName: color}];
    txtFld8.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"AGE" attributes:@{NSForegroundColorAttributeName: color}];
    
    datePicker = [[UIDatePicker alloc]init];
    [datePicker setDate:[NSDate date]];
    datePicker.minimumDate=[NSDate date];
    datePicker.datePickerMode = UIDatePickerModeDateAndTime;
    [datePicker addTarget:self action:@selector(LabelTitle:) forControlEvents:UIControlEventValueChanged];

    [txtFld3 setInputView:datePicker];
    
    languageSelect = [[UIPickerView alloc] initWithFrame:CGRectMake(10, 200, 300, 200)];
    languageSelect.showsSelectionIndicator = YES;
    languageSelect.hidden = NO;
    languageSelect.delegate = self;
//    [txtFld4 setInputView:languageSelect];
    [txtFld8 setInputView:languageSelect];
    
    
    slotSelect = [[UIPickerView alloc] initWithFrame:CGRectMake(10, 200, 300, 200)];
    slotSelect.showsSelectionIndicator = YES;
    slotSelect.hidden = NO;
    slotSelect.delegate = self;
    [txtFld4 setInputView:slotSelect];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    if (CreateEventPressed == YES) {
        [self.navigationController popViewControllerAnimated:YES];
        CreateEventPressed = NO;
    }
}

-(void)LabelTitle:(id)sender
{
    NSDateFormatter *dateFormat=[[NSDateFormatter alloc]init];
    //    dateFormat.dateStyle=NSDateFormatterLongStyle;
    [dateFormat setDateFormat:@"YYYY/MM/dd hh:mm"];
    strDate=nil;
    strDate=[NSString stringWithFormat:@"%@",[dateFormat  stringFromDate:datePicker.date]];
    txtFld3.text=strDate;
    NSLog(@"Time to print  %@",strDate);
}

//UIPickerViewDataSource

//Columns in picker views

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView; {
    
    if (pickerView==slotSelect) {
        return 1;
    }
//    else
//    {
//        return 2;
//    }
    return 2;
}
//Rows in each Column

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component;
{
    
    if (pickerView==slotSelect) {
        return 1000;
    }
    else
    {
        return ageCountArr.count;
    }
}

//UIPickerViewDelegate
// these methods return either a plain NSString, a NSAttributedString, or a view (e.g UILabel) to display the row for the component.
-(NSString*) pickerView:(UIPickerView*)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    
    if (pickerView==slotSelect) {
        return [NSString stringWithFormat:@"%ld",(long)row];
    }
    else
    {
        if (component==0) {
//            if (row==0)
//            {
//                return @"Minimum Age";
//            }
//            else
//            {
                return [ageCountArr objectAtIndex:row];
//            }
            
        }
        else
        {
                return [ageCountArr objectAtIndex:row];
        }

    
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component;
{
    //Write the required logic here that should happen after you select a row in Picker View.
    if (pickerView==slotSelect) {
        [txtFld4 setText:[NSString stringWithFormat:@"%ld",(long)row]];
    }
    else
    {
        if (component==0) {
            if (row==0) {
                min=@"Enter min age";
            }
            else
            {
                min=[ageCountArr objectAtIndex:row];
            }
        }
        if (component==1) {
            if (row==0) {
                max=@"Enter max age";
            }
            else
            {
                max=[ageCountArr objectAtIndex:row];
            }
        }
        
        if ([min isEqual:[NSNull null]] || min.length==0 ) {
            min=@"Enter min age";
        }
        if ([max isEqual:[NSNull null]] || max.length==0 ) {
            max=@"Enter max age";
        }
        
        if ([min intValue]>=[max intValue]) {
            
            if ([max isEqualToString:@"Enter max age"])
            {
                
            }
            else
            {
                min=[NSString stringWithFormat:@"%d",[max intValue]-1];
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Age" message:@"Minimum age should be less than maximum age" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                [alert show];
            }
        }
        [txtFld8 setText:[NSString stringWithFormat:@"%@-%@",min,max]];
    }
}

- (IBAction)switchToNextField:(id)sender
{
    [txtFld3 resignFirstResponder];
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}


#pragma Search Location Delegate

- (void)enteredAddress:(searchLocationViewController *)controller didFinishEnteringItem:(NSString *)address :(NSString *)lati :(NSString *)longi
{
    addrName=address;
    txtFld2.text=addrName;
    latit=lati;
    longit=longi;
}

#pragma Get SubCatagory ID Delegate

-(void)enteredCatIDSubCatIds:(InterestCategoryViewController *)controller didFinishEnteringItem:(NSString *)categID :(NSString *)subCatIDArr
{
    cat_Id = categID;
    sub_cat_Id = subCatIDArr;
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma TextField Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    
    if (textField==txtFld3) {
        NSDateFormatter *dateFormat=[[NSDateFormatter alloc]init];
        [dateFormat setDateFormat:@"YYYY-MM-dd  hh:mm aa"];
        strDate=nil;
        strDate=[NSString stringWithFormat:@"%@",[dateFormat  stringFromDate:[NSDate date]]];
        NSLog(@"Time to print  %@",strDate);
    }
    
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField;
{
    if (textField == txtFld1) {
    }
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSUInteger max = 50;
    NSUInteger len = [txtFld1.text length];
    if( len + string.length > max){ return NO;}
    else
    {
        NSLog(@"%@",[NSString stringWithFormat:@"%lu", (unsigned long)len]);
    }
    
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    return YES;
}


- (IBAction)backAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)moveToInterest:(id)sender
{
    InterestCategoryViewController *objintrst = [self.storyboard instantiateViewControllerWithIdentifier:@"InterestCategoryViewControllerID"];
    objintrst.delegate=self;
    objintrst.isComingFrom = @"event";
    [self.navigationController pushViewController:objintrst animated:YES];
    
}

- (IBAction)addEventBtnAction:(id)sender
{
//    InviteOthersViewController *objInvite = [self.storyboard instantiateViewControllerWithIdentifier:@"InviteOthersViewControllerID"];
//    CreateEventPressed =  YES;
//    [self.navigationController pushViewController:objInvite animated:YES];
    
    if (txtFld1.text.length>0 && txtFld3.text.length>0 && txtFld5.text.length>0 && txtFld8.text.length>0 )
    {
        HUD=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [self performSelector:@selector(callApi)];
    }
    else
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Create Event" message:@"Please enter all the fields." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        
        [alert show];
    }
}

-(void) callApi
{
    NSURL *url = [NSURL URLWithString:@"http://seekly.azurewebsites.net/api/Event/AddEvent"];
    
    if (sub_cat_Id) {
        
        
        if (txtFld1.text.length>0 && txtFld5.text.length>0 && txtFld8.text.length>0 && txtFld3.text.length>0)
        {
            NSArray *Temp = [txtFld3.text componentsSeparatedByString:@" "];
            
            ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
            [request setRequestMethod:@"POST"];
            [request setPostValue:txtFld1.text forKey:@"event_name"];
            [request setPostValue:addrName forKey:@"event_location"];
            [request setPostValue:[Temp objectAtIndex:0] forKey:@"event_date"];
            [request setPostValue:[Temp objectAtIndex:1] forKey:@"event_time"];
            [request setPostValue:txtFld5.text forKey:@"event_description"];
            [request setPostValue:txtFld1.text forKey:@"status"];
            [request setPostValue:[NSString stringWithFormat:@"%i",gender] forKey:@"gender"];
            [request setPostValue:txtFld8.text forKey:@"age"];
            [request setPostValue:latit forKey:@"latitude"];
            [request setPostValue:longit forKey:@"longitude"];
            [request setPostValue:cat_Id  forKey:@"category_id"];
            [request setPostValue:sub_cat_Id forKey:@"sub_category_id"];
            [request setPostValue:[[NSUserDefaults standardUserDefaults]valueForKey:@"UID"]  forKey:@"user_id"];
            [request setPostValue:@"0" forKey:@"event_create_type"];
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
                    InviteOthersViewController *objInvite = [self.storyboard instantiateViewControllerWithIdentifier:@"InviteOthersViewControllerID"];
                    objInvite.eventId = [[responseDict valueForKey:@""]objectForKey:0];
                    CreateEventPressed =  YES;
                    [self.navigationController pushViewController:objInvite animated:YES];
                } else {
                    [HUD hide:YES];
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Exception" message:[NSString stringWithFormat:@"%@",[responseDict  objectForKey:@"Exception"]] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                    [alert show];
                }
            }
        } else
        {
            [HUD hide:YES];
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Please make sure all fields are filled" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];

        }

    } else
    {
        [HUD hide:YES];
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Please add choose subcategory first" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    returnKeyHandler = nil;
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

- (IBAction)locationPickBtn:(id)sender
{
    searchLocationViewController *objSignup = [self.storyboard instantiateViewControllerWithIdentifier:@"searchLocationViewControllerID"];
    objSignup.delegate=self;
    objSignup.isComingFrmScreen=@"1";
    [self presentViewController:objSignup animated:YES completion:nil];
}

- (IBAction)AgeBtnAction:(id)sender;
{
    
}

- (IBAction)GenderBtnAction:(id)sender;
{
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Select gender"
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* option1Action = [UIAlertAction actionWithTitle:@"Male & Female" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action)
    {
        [self dismissViewControllerAnimated:YES completion:nil];
        [GenderBtn setTitle:@"Male & Female" forState:UIControlStateNormal];
        gender = 1;
    }];
    [alert addAction:option1Action];
    
    UIAlertAction* option2Action = [UIAlertAction actionWithTitle:@"Male" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action)
    {
        [self dismissViewControllerAnimated:YES completion:nil];
        [GenderBtn setTitle:@"Male" forState:UIControlStateNormal];
        gender = 2;
    }];
    [alert addAction:option2Action];
    
    UIAlertAction* option3Action = [UIAlertAction actionWithTitle:@"Female" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action)
                                    
    {
        [self dismissViewControllerAnimated:YES completion:nil];
        [GenderBtn setTitle:@"Female" forState:UIControlStateNormal];
        gender = 3;
    }];
    [alert addAction:option3Action];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel
                                                          handler:^(UIAlertAction * action)
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    [alert addAction:defaultAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}
- (IBAction)StatusBtnAction:(id)sender;
{
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Select event type"
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* option1Action = [UIAlertAction actionWithTitle:@"Open event" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action)
                                    {
                                        [statuBtn setTitle:@"Open event" forState:UIControlStateNormal];
                                        [self dismissViewControllerAnimated:YES completion:nil];
                                    }];
    [alert addAction:option1Action];
    
    UIAlertAction* option2Action = [UIAlertAction actionWithTitle:@"Invited only" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action)
                                    {
                                        [statuBtn setTitle:@"Invited only" forState:UIControlStateNormal];
                                        [self dismissViewControllerAnimated:YES completion:nil];
                                    }];
    [alert addAction:option2Action];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel
                                                          handler:^(UIAlertAction * action)
                                    {
                                        [self dismissViewControllerAnimated:YES completion:nil];
                                    }];
    [alert addAction:defaultAction];
    
    [self presentViewController:alert animated:YES completion:nil];

}


@end
