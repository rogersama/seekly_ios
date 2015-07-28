//
//  SettingViewController.h
//  Seekly
//
//  Created by Deepinder singh on 21/05/15.
//  Copyright (c) 2015 Deepinder singh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SeeklyAPI.h"
NSString *radiusStr;

@interface SettingViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    UIView *dropDownView;
    UIView *dropDownView1;
    UILabel* sliderValLbl;
    BOOL showDropDown;
    CGRect screenSize;
}

@end
