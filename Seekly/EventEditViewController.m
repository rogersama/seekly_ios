//
//  EventEditViewController.m
//  Seekly
//
//  Created by Deepinder singh on 22/07/15.
//  Copyright (c) 2015 Deepinder singh. All rights reserved.
//

#import "EventEditViewController.h"

@interface EventEditViewController ()
{
    MBProgressHUD *HUD;
    NSDictionary *responseDict;
    NSDictionary *dict;
    __weak IBOutlet UIButton *ActionBtn;
    __weak IBOutlet UILabel *eventTitleLbl;
    __weak IBOutlet UILabel *locLbl;
    __weak IBOutlet UILabel *timeLbl;
    __weak IBOutlet UILabel *slotLbl;
    __weak IBOutlet UIImageView *eventImgView;
    __weak IBOutlet UIImageView *logoImgView;
}

@end

@implementation EventEditViewController

@synthesize EventID,SelectedEvent;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    locTxtFld.layer.cornerRadius = 3;
    dateTxtFld.layer.cornerRadius = 3;
    slotLbl.layer.cornerRadius = 3;
    
    locTxtFld.text = [NSString stringWithFormat:@"%@",[SelectedEvent valueForKey:@"event_location"]];
    dateTxtFld.text = [NSString stringWithFormat:@"%@",[SelectedEvent valueForKey:@"event_time"]];
    _discriptionTxtView.text = [NSString stringWithFormat:@"%@",[SelectedEvent valueForKey:@"event_description"]];
    
    NSURL *url = [NSURL URLWithString:_imgPath];
    
    __block UIActivityIndicatorView *activityIndicator;
    __weak UIImageView *weakImageView = eventImgView;
    [eventImgView sd_setImageWithURL:url
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
                                   eventImgView.image = [UIImage imageNamed:@"pic_01"];
                               }
                           }];
    

    // Do any additional setup after loading the view.
}

-(IBAction) getDetail
{
    //    HUD=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://seekly.azurewebsites.net/api/Event/%@",EventID]] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:120.0];
    
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
                [HUD hide:YES];
            }
        }
    }];
}


-(IBAction) cancelEvent
{
    HUD=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://seekly.azurewebsites.net/api/EventDecline/%@",EventID]] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:120.0];
    
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
                [HUD hide:YES];
            }
        }
    }];
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

- (IBAction)BackAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)SaveAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
