
#import <WindowsAzureMobileServices/WindowsAzureMobileServices.h>


@interface MSClient (CustomId) <MSFilter>

- (void) registerUsername:(NSString *) username withPassword: (NSString *) password withCompletion: (MSItemBlock) completion;
- (void) loginUsername:(NSString *) username withPassword: (NSString *) password completion: (MSClientLoginBlock) completion;

@end