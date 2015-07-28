//
//  MyInterestViewController.h
//  Seekly
//
//  Created by Deepinder singh on 24/07/15.
//  Copyright (c) 2015 Deepinder singh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SeeklyAPI.h"
#import "SDWebImageManager.h"
#import "UIImageView+WebCache.h"


@interface MyInterestViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    CGRect screenSize;
    NSDictionary *dict;
    IBOutlet UITableView *TblView;
}

@end
