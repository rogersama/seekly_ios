//
//  EditProfileViewController.m
//  Seekly
//
//  Created by Deepinder singh on 01/06/15.
//  Copyright (c) 2015 Deepinder singh. All rights reserved.
//

#import "EditProfileViewController.h"
#import "FriendsViewController.h"

@interface EditProfileViewController ()

{
    NSDictionary * dict;

}

@end

@implementation EditProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *uName=[[NSUserDefaults standardUserDefaults]valueForKey:@"UName"];
    
    profileImage.layer.cornerRadius = 35.0;
    profileImage.layer.masksToBounds = YES;
    profileImage.layer.borderWidth = 2.0;
    profileImage.layer.borderColor = [[UIColor whiteColor] CGColor];

    
    NSArray *subStrArray = [uName componentsSeparatedByString:@" "];
    fname.text = subStrArray[0];
    fname.text = subStrArray[1];
    
    [self performSelector:@selector(getProfileInfo)];
    
    // Do any additional setup after loading the view.
}

-(void) getProfileInfo
{
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://seekly.azurewebsites.net/api/UpdateUser/%@",[[NSUserDefaults standardUserDefaults]valueForKey:@"UID"]]] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:120.0];
    
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
                NSString *uImageUrl = [dict objectForKey:@"profile_pic"];
                if (![uImageUrl isEqualToString:@"null"])
                {
                    uImageUrl = [uImageUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                    
                    NSURL *url = [NSURL URLWithString:uImageUrl];
                    
                    __block UIActivityIndicatorView *activityIndicator;
                    __weak UIImageView *weakImageView = profileImage;
                    [profileImage sd_setImageWithURL:url
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
                                                   profileImage.image = [UIImage imageNamed:@"eventPlaceholderImg"];
                                               }
                                           }];
                }
                
            }
        }
    }];
}



-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
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

- (IBAction)DoneEditingAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)backButton:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
