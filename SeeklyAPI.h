




#import <Foundation/Foundation.h>
#import "Reachability.h"
#import "AppDelegate.h"
#import "JSON.h"
#define baseUrl @"http://seekly.azurewebsites.net/api"
#import "MBProgressHUD.h"
#import "ASIFormDataRequest.h"
NSInteger internetWorking;


@interface SeeklyAPI : NSObject<NSXMLParserDelegate>

{
    NSURLConnection     *theConnection;
    NSMutableData       *mutResponseData;
    int                 intResponseCode;
    
    // Reachability data members
    Reachability *reachability;
    
    NSString *str_currentElement;
    
    
    SEL callBackSelector;
    id __weak callBackTarget;
}

@property (nonatomic, strong) Reachability *reachability;
@property (nonatomic, readwrite) NSInteger internetWorking;
@property (nonatomic) SEL callBackSelector;
@property (nonatomic, weak) id callBackTarget;

// Reachability Methods
- (void)checkInternetConnection;
- (void)updateInterfaceWithReachability:(Reachability *)curReach;
- (void)putmethod:(NSString *)URL Parameters:(NSDictionary *)parameters;


// Custom Method(s)

//Created By deep

- (void)callAPI_forSignIn:(NSMutableDictionary *)dataDict withTarget:(id)tempTarget withSelector:(SEL)tempSelector :(NSString *)strURL;

- (void)callAPI_forSignUp:(NSMutableDictionary *)dataDict withTarget:(id)tempTarget withSelector:(SEL)tempSelector :(NSString *)strURL;












- (void)callAPI_withWithoutBaseLink:(NSMutableDictionary *)dataDict withTarget:(id)tempTarget withSelector:(SEL)tempSelector :(NSString *)strURL;

- (void)callAPI_withURLstring:(NSMutableDictionary *)dataDict withTarget:(id)tempTarget withSelector:(SEL)tempSelector :(NSString *)strURL;

- (void)submitTwitterFriendsInfo:(NSMutableDictionary *)dataDict withTarget:(id)tempTarget withSelector:(SEL)tempSelector;

- (void)submitInvitedFriendsInfo:(NSMutableDictionary *)dataDict withTarget:(id)tempTarget withSelector:(SEL)tempSelector;

- (void)callAPI_getAdressFromPostalCode:(NSString *)string_pin withTarget:(id)tempTarget withSelector:(SEL)tempSelector;

- (void)callAPI_cashFlowVerification:(NSString *)string_pin withTarget:(id)tempTarget withSelector:(SEL)tempSelector;


@end


