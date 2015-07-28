//
//  MyEventViewController.h
//  Seekly
//
//  Created by Deepinder singh on 28/05/15.
//  Copyright (c) 2015 Deepinder singh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SeeklyAPI.h"
#import "searchLocationViewController.h"
#import "InviteOthersViewController.h"
#import "InterestCategoryViewController.h"

@interface CreateEventViewController : UIViewController<UITextFieldDelegate,UINavigationBarDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIPickerViewDataSource,UIPickerViewDelegate,searchLocationViewControllerDelegate,InterestCategoryViewControllerDelegate>

{
IBOutlet UITextField *txtFld1;
IBOutlet UITextField *txtFld2;
IBOutlet UITextField *txtFld3;
IBOutlet UITextField *txtFld4;
IBOutlet UITextField *txtFld5;
IBOutlet UITextField *txtFld6;
IBOutlet UITextField *txtFld7;
IBOutlet UITextField *txtFld8;
IBOutlet UIButton *statuBtn;
IBOutlet UIToolbar *toolBar;
IBOutlet UIButton *GenderBtn;
IBOutlet UIButton *AgeBtn;
int gender;
NSMutableArray* pickerData;
NSString *addrName, *latit ,*longit;
NSString *strDate;
UIDatePicker *datePicker;
NSString *min,*max,*cat_Id,*sub_cat_Id;
}


- (IBAction)AgeBtnAction:(id)sender;
- (IBAction)GenderBtnAction:(id)sender;
- (IBAction)StatusBtnAction:(id)sender;
@end
