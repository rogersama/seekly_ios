// ----------------------------------------------------------------------------
// Copyright (c) Microsoft Corporation. All rights reserved.
// ----------------------------------------------------------------------------
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

#import <WindowsAzureMobileServices/WindowsAzureMobileServices.h>
#import "QSTodoService.h"
#import "AppDelegate.h"

#pragma mark * Private interace


@interface QSTodoService()

@property (nonatomic, strong)   MSTable *table;

@property (nonatomic, strong)   MSSyncTable *syncTable;
@property (nonatomic)  NSInteger busyCount;


@end


#pragma mark * Implementation


@implementation QSTodoService

@synthesize items;


+ (QSTodoService *)defaultService
{
    // Create a singleton instance of QSTodoService
    static QSTodoService* service;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        service = [[QSTodoService alloc] init];
    });
    
    return service;
}

-(QSTodoService *)init
{
    self = [super init];
    
    if (self)
    {
        // Initialize the Mobile Service client with your URL and key   
        self.client = [MSClient clientWithApplicationURLString:@"https://firstproject.azure-mobile.net/"
                                                applicationKey:@"cKaJKTeoWfopzhuWyJhiDugpksgbJI69"];
    
        AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        NSManagedObjectContext *context = delegate.managedObjectContext;
        MSCoreDataStore *store = [[MSCoreDataStore alloc] initWithManagedObjectContext:context];
        
        self.client.syncContext = [[MSSyncContext alloc] initWithDelegate:nil dataSource:store callback:nil];
        
        // Create an MSSyncTable instance to allow us to work with the TodoItem table
        self.syncTable = [_client syncTableWithName:@"user_tbl"];
    }
    
    return self;
}

-(void)addItem:(NSDictionary *)item completion:(QSCompletionBlock)completion
{
//    // Insert the item into the TodoItem table and add to the items array on completion
//    [self.syncTable insert:item completion:^(NSDictionary *result, NSError *error)
//    {
//        [self logErrorIfNotNil:error];
//    
//        [self syncData: ^{
//            // Let the caller know that we finished
//            if (completion != nil) {
//                dispatch_async(dispatch_get_main_queue(), completion);
//            }
//        }];
//    }];
    
    MSTable *apnsTable = [self.client tableWithName:@"user_tbl"];
    
   
    [apnsTable insert:item completion:^(NSDictionary *item, NSError *error) {
        [self logErrorIfNotNil:error];
        if (completion) {
            completion();
        }
    }];
}

-(void)addAPNSToken:(NSString *)token completion:(QSCompletionBlock)completion
{
    MSTable *apnsTable = [self.client tableWithName:@"ApnsToken"];

    NSDictionary *item = @{@"token": token};
    [apnsTable insert:item completion:^(NSDictionary *item, NSError *error) {
        [self logErrorIfNotNil:error];
        if (completion) {
            completion();
        }
    }];
}


-(void)addNewUser:(NSString *)firstname :(NSString *)lastname :(NSString *)address :(NSString *)date_of_birth :(NSString *)gender :(NSString *)emailid  :(NSString *)password completion:(QSCompletionBlock)completion
{
    MSTable *apnsTable = [self.client tableWithName:@"user_tbl"];
    
    NSDictionary *item = @{@"firstname": firstname , @"lastname": lastname , @"address": address , @"date_of_birth": date_of_birth , @"gender": gender , @"emailid": emailid , @"password": password };
    
    [apnsTable insert:item completion:^(NSDictionary *item, NSError *error) {
        [self logErrorIfNotNil:error];
        if (completion) {
            completion();
        }
    }];
}


-(void)completeItem:(NSDictionary *)item completion:(QSCompletionBlock)completion
{
    // Set the item to be complete (we need a mutable copy)
    NSMutableDictionary *mutable = [item mutableCopy];
    [mutable setObject:@YES forKey:@"complete"];
    
    // Update the item in the TodoItem table and remove from the items array on completion
    [self.syncTable update:mutable completion:^(NSError *error)
    {
        [self logErrorIfNotNil:error];
        
        [self syncData: ^{
            // Let the caller know that we finished
            if (completion != nil) {
                dispatch_async(dispatch_get_main_queue(), completion);
            }
        }];
    }];
}

-(void)syncData:(QSCompletionBlock)completion
{
    // push all changes in the sync context, then pull new data
    [self.client.syncContext pushWithCompletion:^(NSError *error) {
        [self logErrorIfNotNil:error];
        [self pullData:completion];
    }];
}

//- (void) refreshDataOnSuccess:(QSCompletionBlock)completion
//{
//    // Create a predicate that finds items where complete is false
//    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"complete == NO"];
//    
//    // Query the TodoItem table and update the items property with the results from the service
////    [self.table readWithPredicate:pre completion:<#^(MSQueryResult *result, NSError *error)completion#>
//    [self.table readWhere:predicate completion:^(NSArray *results, NSInteger totalCount, NSError *error)
//    {
//        
//        [self logErrorIfNotNil:error];
//        
//        items = [results mutableCopy];
//        
//        // Let the caller know that we finished
//        completion();
//    }];
//    
//}


-(void)pullData:(QSCompletionBlock)completion
{
    MSQuery *query = [self.syncTable query];
    
    // Pulls data from the remote server into the local table.
    // We're pulling all items and filtering in the view
    // query ID is used for incremental sync
    [self.syncTable pullWithQuery:query queryId:@"allTodoItems" completion:^(NSError *error) {
        [self logErrorIfNotNil:error];
        
        // Let the caller know that we have finished
        if (completion != nil) {
            dispatch_async(dispatch_get_main_queue(), completion);
        }
    }];
}

- (void)busy:(BOOL) busy
{
    // assumes always executes on UI thread
    if (busy) {
        if (self.busyCount == 0 && self.busyUpdate != nil) {
            self.busyUpdate(YES);
        }
        self.busyCount ++;
    }
    else
    {
        if (self.busyCount == 1 && self.busyUpdate != nil) {
            self.busyUpdate(FALSE);
        }
        self.busyCount--;
    }
}

- (void) logErrorIfNotNil:(NSError *) error
{
    if (error) {
        NSLog(@"ERROR %@", error);
    }
}


#pragma mark * MSFilter methods


- (void) handleRequest:(NSURLRequest *)request
                onNext:(MSFilterNextBlock)onNext
            onResponse:(MSFilterResponseBlock)onResponse
{
    // A wrapped response block that decrements the busy counter
    MSFilterResponseBlock wrappedResponse = ^(NSHTTPURLResponse *response, NSData *data, NSError *error) {
        [self busy:NO];
        if (response.statusCode == 401) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"UnauthorizedResponse" object:nil];
        }
        onResponse(response, data, error);
    };
    
    // Increment the busy counter before sending the request
    [self busy:YES];
    onNext(request, wrappedResponse);
}

@end
