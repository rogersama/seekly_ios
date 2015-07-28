#import "MSClient+CustomId.h"

@implementation MSClient (CustomId)

- (void)registerUsername:(NSString *)username withPassword:(NSString *)password withCompletion:(MSItemBlock)completion
{
    MSTable *accounts = [self tableWithName:@"accounts"];
    NSDictionary *account = @{
    @"username" : username,
    @"password" : password
    // you should include and collect any additional data here
    };
    [accounts insert:account completion:completion];
}

- (void)loginUsername:(NSString *)username withPassword:(NSString *)password completion:(MSClientLoginBlock)completion
{
    MSClient *loginClient = [self clientWithFilter:self];
    MSTable *accounts = [loginClient tableWithName:@"user_tbl"];
    NSDictionary *credentials = @{
    @"username" : username,
    @"password" : password,
//    @"userId" : @"55555",
//    @"token" : @"azcsxsdf",
    // you should include and collect any additional data here
    };
    [accounts insert:credentials completion:^(NSDictionary *item, NSError *error) {
        if (error) {
            completion(nil, error);
        }
        else {
            MSUser *user = [[MSUser alloc] initWithUserId:[item valueForKey:@"userId"]];
            user.mobileServiceAuthenticationToken = [item valueForKey:@"token"];
            self.currentUser = user;
            completion(user, error);
        }
    }];
}


// This filter simply augments the outgoing URL to add a parameter login=true
// This will be much easier in the next release of the iOS SDK which support
// specifying parameters on insert

//- (void) handleRequest:(NSURLRequest *)request
//                onNext:(MSFilterNextBlock)onNext
//            onResponse:(MSFilterResponseBlock)onResponse
-(void)handleRequest:(NSURLRequest *)request
                next:(MSFilterNextBlock)next
            response:(MSFilterResponseBlock)response;

{
    // just add a parameter on the outbound request
    NSMutableURLRequest *req = [request mutableCopy];
    NSURL *newUrl;
    if ([req.URL.absoluteString rangeOfString:@"?"].location != NSNotFound) {
        newUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", req.URL.absoluteString, @"&login=true"]];
    }
    else {
        newUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", req.URL.absoluteString, @"?login=true"]];
    }
    req.URL = newUrl;
    next(req, response);
}


@end