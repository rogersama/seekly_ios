//
//  ScavengerHuntAPI.m
//  ScavengerHunt
//
//  Created by OSX on 10/03/15.
//  Copyright (c) 2015 Rohit. All rights reserved.
//

#import "SeeklyAPI.h"
#import "SBJSON.h"
#import "ASIFormDataRequest.h"

@implementation SeeklyAPI
@synthesize reachability;
@synthesize internetWorking;
@synthesize callBackSelector;
@synthesize callBackTarget;

//for Client



+(NSString *)getCombineURL:(NSString*)serviceName :(NSString*)methodName
{
    return [serviceName stringByAppendingString:methodName];
}
#pragma mark
#pragma mark  Common API
#pragma mark



- (void)callAPI_forSignIn:(NSMutableDictionary *)dataDict withTarget:(id)tempTarget withSelector:(SEL)tempSelector :(NSString *)strURL
{
    // NSData *postData = [self encodeDictionary:dataDict];
    
    // Create the request
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/SignIn/SignIn",baseUrl]];

    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setRequestMethod:@"POST"];
    
    [request setPostValue:[dataDict valueForKey:@"email"] forKey:@"email"];
    [request setPostValue:[dataDict valueForKey:@"password"] forKey:@"password"];
    
    [request setDelegate:self];
    [request startSynchronous];
    
    
    NSError *error = [request error];
    
}

- (void)callAPI_forSignUp:(NSMutableDictionary *)dataDict withTarget:(id)tempTarget withSelector:(SEL)tempSelector :(NSString *)strURL
{
    callBackSelector = tempSelector;
    callBackTarget = tempTarget;
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/SignUp/SignUp",baseUrl]];
    
    // Create the request
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setRequestMethod:@"POST"];
    
    
    [request setPostValue:[dataDict valueForKey:@"firstname"] forKey:@"first_name"];
    [request setPostValue:[dataDict valueForKey:@"lastname"] forKey:@"last_name"];
    [request setPostValue:[dataDict valueForKey:@"city"] forKey:@"city"];
    [request setPostValue:[dataDict valueForKey:@"date_of_birth"] forKey:@"date_of_birth"];
    [request setPostValue:[dataDict valueForKey:@"emailid"] forKey:@"email"];
    [request setPostValue:[dataDict valueForKey:@"password"] forKey:@"password"];
    [request setPostValue:[dataDict valueForKey:@"gender"] forKey:@"gender"];
    [request setPostValue:[dataDict valueForKey:@"device_token"] forKey:@"device_token"];
    [request setPostValue:[dataDict valueForKey:@"latitude"] forKey:@"latitude"];
    [request setPostValue:[dataDict valueForKey:@"longitude"] forKey:@"longitude"];
    [request setPostValue:[dataDict valueForKey:@"profile_pic"]  forKey:@"profile_pic"];
    [request setPostValue:[dataDict valueForKey:@"register_type"] forKey:@"register_type"];
    [request setPostValue:[dataDict valueForKey:@"fb_id"] forKey:@"fb_id"];
    
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
    }
}
-(void)requestSuccess:(ASIHTTPRequest *)request
{
    NSString *responseString = [request responseString];
    NSLog(@"responseString is%@",responseString);
    NSDictionary *responseDict = [responseString JSONValue];
    NSLog(@"dict is :%@",responseDict);
}

-(void)requestFail:(ASIHTTPRequest *)request
{
    NSLog(@"process failed");
}
//
//-(void)uploadTheSelectedLoadOnServer
//{
//    @try {
//        if (![self.mArrayJumpersDetails count])
//        {
//            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"No jumper(s) selected" message:@"First select jumper(s) from jumpers list." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//            [alert show];
//            return;
//        }
//        else
//        {
//            if ([CommonMethod checkInternetConnection])
//            {
//                NSInteger tagValue = l;
//                NSString *load_id = [[self.mArrayLoadContent objectAtIndex:tagValue]valueForKey:@"id"];
//                if (self.jumpers)
//                {
//                    [self.jumpers removeAllObjects];
//                }
//                else
//                {
//                    self.jumpers = [[NSMutableArray alloc]init];
//                }
//                for (int i = 0; i< [self.mArrayJumpersDetails count];i++)
//                {
//                    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
//                    NSDictionary *content = [self.mArrayJumpersDetails objectAtIndex:i];
//                    
//                    if([[content valueForKey:@"team_member"]length] && [[content valueForKey:@"team_member"]isEqualToString:@"YES"])
//                    {
//                        [dic setValue:[content valueForKey:@"jumper_id"] forKey:@"jumper_id"];
//                    }
//                    else{
//                        [dic setValue:[content valueForKey:@"id"] forKey:@"jumper_id"];
//                    }
//                    
//                    if ([[content valueForKey:@"selected_Jump"]length]){
//                        [dic setValue:[content valueForKey:@"selected_Jump"] forKey:@"jumper_jump_type"];
//                    }
//                    else if([[content valueForKey:@"default_jump"]length]){
//                        [dic setValue:[content valueForKey:@"default_jump"] forKey:@"jumper_jump_type"];
//                    }
//                    else{
//                        [dic setValue:@"1" forKey:@"jumper_jump_type"];
//                    }
//                    
//                    if ([[content valueForKey:@"selected_Pay"]length]){
//                        [dic setValue:[content valueForKey:@"selected_Pay"] forKey:@"jumper_pay_type"];
//                    }
//                    else{
//                        
//                        [dic setValue:@"0" forKey:@"jumper_pay_type"];
//                    }
//                    [self.jumpers addObject:dic];
//                    
//                    dic = nil;
//                }
//                
//                
//                NSString * str = [[NSString stringWithFormat:@"%@/cfe_loads/add_jumpers", BaseURL]
//                                  stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//                
//                
//                NSLog(@"Main url = %@",str);
//                NSLog(@"access key = %@",PREF(ACCESS_KEY));
//                NSLog(@"leader_id = %@",PREF(JUMPER_ID));
//                NSLog(@"load id = %@",load_id);
//                NSLog(@"jumpers = %@",[NSString stringWithFormat:@"%@",[self.jumpers JSONRepresentation]]);
//                
//                
//                NSURL *url = [NSURL URLWithString:str];
//                
//                ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
//                [request setRequestMethod:@"POST"];
//                [request setPostValue:PREF(ACCESS_KEY) forKey:@"access_key"];
//                [request setPostValue:PREF(JUMPER_ID) forKey:@"leader_id"];
//                [request setPostValue:load_id forKey:@"load_id"];
//                [[NSUserDefaults standardUserDefaults ]setObject:load_id forKey:@"load_id_1"];
//                [request setPostValue:[NSString stringWithFormat:@"%@",[jumpers JSONRepresentation]] forKey:@"jumpers"];
//                
//                [request startSynchronous];
//                NSError *error = [request error];
//                if (!error)
//                {
//                    NSString *response = [request responseString];
//                    NSData * data = [response dataUsingEncoding:NSUTF8StringEncoding];
//                    NSArray *response_arr = PerformXMLXPathQuery(data, @"//status");
//                    
//                    if ([[[[[response_arr objectAtIndex:0]valueForKey:@"nodeChildArray"]objectAtIndex:0]valueForKey:@"nodeContent"]isEqualToString:@"1"])
//                    {
//                        ConfirmLoadVC *obj = [[ConfirmLoadVC alloc]initWithNibName:@"ConfirmLoadVC" bundle:[NSBundle mainBundle]];
//                        obj.mDictionaryLoadDetail = [mArrayLoadContent objectAtIndex:tagValue];
//                        obj.mArrayJumpersDetail = mArrayJumpersDetails;
//                        [self.navigationController pushViewController:obj animated:YES];
//                    }
//                    else
//                    {
//                        NSArray *msg_arr = PerformXMLXPathQuery(data, @"//msg");
//                        // NSLog(@"%@",msg_arr);
//                        NSString *str = [[[[msg_arr objectAtIndex:0]valueForKey:@"nodeChildArray"]objectAtIndex:0]valueForKey:@"nodeContent"];
//                        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:str delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//                        [alert show];
//                        return;
//                    }
//                }
//                else
//                {
//                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:[error description] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//                    [alert show];
//                }
//            }
//            else{
//                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"No Internet!" message:@"Please check your internet connection." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//                [alert show];
//            }
//            
//        }
//    }
//    @catch (NSException *e)
//    {
//        NSLog(@"%@",[e description]);
//        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:[e description] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//        [alert show];
//    }
//    @finally {
//    }
//}


- (void)callAPI_withURLstring:(NSMutableDictionary *)dataDict withTarget:(id)tempTarget withSelector:(SEL)tempSelector :(NSString *)strURL
{
    callBackSelector = tempSelector;
    callBackTarget = tempTarget;
    
    
        SBJSON *objJson = [SBJSON new];
        NSString *str = [objJson stringWithObject:dataDict];
        NSLog(@"JSON REQUEST STRING\n%@\n\n", str);
        objJson = nil;
        
        
        NSString *mainStr=[@"http://seekly.azurewebsites.net/api/Category/GetCategories" stringByAppendingString:str];
        NSString* encodedUrl = [mainStr stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
        
        NSURL *url=[NSURL URLWithString:encodedUrl];

        NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:30.0];
        NSLog(@"--- API BEING HIT ---\n%@\n\n", theRequest);
        [theRequest setHTTPBody:[str dataUsingEncoding:NSUTF8StringEncoding]];
        [theRequest setHTTPMethod:@"GET"];
        
        if (theConnection)
            theConnection = nil;
        
        theConnection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
//    }
//    else
//    {
//        NSDictionary *dictReturnCode = [[NSDictionary alloc]initWithObjectsAndKeys:[NSNumber numberWithInt:4],@"error", @"Unable to connect to network.",@"message",nil];
//        ////		NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:dictReturnCode,@"responseDict",nil];
//        //dictReturnCode = nil;
//        
//        
//        
//        [callBackTarget performSelector:callBackSelector withObject:dictReturnCode];
//    }
}

- (void)putmethod:(NSString *)URL Parameters:(NSDictionary *)parameters
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:URL] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:120.0];
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:parameters options:NSJSONWritingPrettyPrinted error:&error];
    if (!error) {
        [request setHTTPMethod:@"GET"];
//        [request setValue:@"appication/json" forKey:@"Content-Type"];
        [request setHTTPBody:jsonData];
        [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *responce,NSData *data, NSError *connectionError){
            NSError *error = nil;
            if (![data isKindOfClass:[NSNull class]] && data!= nil)
            {
                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
                if (error)
                {
                    NSLog(@"fail  ==%@",error);
                }
                else
                {
                    NSLog(@"success  ==%@",dict);
                }
            }
        }];
    }
}

- (void)callAPI_withWithoutBaseLink:(NSMutableDictionary *)dataDict withTarget:(id)tempTarget withSelector:(SEL)tempSelector :(NSString *)strURL
{
    callBackSelector = tempSelector;
    callBackTarget = tempTarget;
    
    [self checkInternetConnection];
    
    if (internetWorking == 0)       // 0: internet working
    {
//        NSString *strConnection = [[NSString alloc]initWithString:strURL];
//        
//        
//        NSURL *apiURL = [NSURL URLWithString:strConnection];
        
        
        SBJSON *objJson = [SBJSON new];
        NSString *str = [objJson stringWithObject:dataDict];
        NSLog(@"JSON REQUEST STRING\n%@\n\n", str);
        objJson = nil;
        
        
        NSString *mainStr=[@"http://www.appsmaventech.com/godsend/index.php?jsonData=" stringByAppendingString:str];
        NSString* encodedUrl = [mainStr stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
        
        NSURL *url=[NSURL URLWithString:encodedUrl];
        
        NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:100.0];
        NSLog(@"--- API BEING HIT ---\n%@\n\n", theRequest);
        [theRequest setHTTPBody:[str dataUsingEncoding:NSUTF8StringEncoding]];
        [theRequest setHTTPMethod:@"GET"];
        
        if (theConnection)
            theConnection = nil;
        
        theConnection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    }
    else
    {
        NSDictionary *dictReturnCode = [[NSDictionary alloc]initWithObjectsAndKeys:[NSNumber numberWithInt:4],@"error", @"Unable to connect to network.",@"message",nil];
        ////		NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:dictReturnCode,@"responseDict",nil];
        //dictReturnCode = nil;
        
        
        
        [callBackTarget performSelector:callBackSelector withObject:dictReturnCode];
    }
}


#pragma mark
#pragma mark API For POSTAL CODE
#pragma mark



#pragma mark
#pragma mark - Reachability Methods
#pragma mark
- (void)checkInternetConnection
{
    reachability = [Reachability reachabilityForInternetConnection];
    [reachability startNotifer];
    
    [self performSelector:@selector(updateInterfaceWithReachability:)withObject:reachability];
}

- (void)updateInterfaceWithReachability:(Reachability *)curReach
{
    if(curReach == reachability)
    {
        //NSLog(@"Internet");
        NetworkStatus netStatus = [curReach currentReachabilityStatus];
        switch (netStatus)
        {
            case NotReachable:
            {
                internetWorking = -1;
                NSLog(@"Internet NOT WORKING");
                break;
            }
            case ReachableViaWiFi:
            {
                internetWorking = 0;
                break;
            }
            case ReachableViaWWAN:
            {
                internetWorking = 0;
                break;
            }
        }
    }
}

#pragma mark - Connection Response Method(s)

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    mutResponseData = [[NSMutableData alloc] init];
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    intResponseCode = [httpResponse statusCode];
    NSLog(@"HTTP STATUS CODE: %d\n\n", intResponseCode);
    [mutResponseData setLength:0];
    
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [mutResponseData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    NSString *str = [[NSString alloc] initWithData:mutResponseData encoding:NSUTF8StringEncoding];
    NSLog(@"JSON RESPONSE STRING\n%@\n\n", str);
    
    
    if ([str rangeOfString:@"ACCEPTED"].location == NSNotFound) {
        NSLog(@"pin not sent");
        [[NSUserDefaults standardUserDefaults]setBool:0 forKey:@"PinSent"];
    } else {
        [[NSUserDefaults standardUserDefaults]setBool:1 forKey:@"PinSent"];
        
        NSLog(@"PIN Sent Successfully");
    }
    
    
    //********
    NSString *dataString = [[NSString alloc] initWithData:mutResponseData encoding:NSUTF8StringEncoding];
    
    // if ([[NSUserDefaults standardUserDefaults]boolForKey: @"isGetPostalAdress"]) {
    
    
    
    NSData *xmlData = [dataString dataUsingEncoding:NSASCIIStringEncoding];
    NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithData:xmlData];
    [xmlParser setDelegate:self];
    [xmlParser parse];
    
    
    //********
    
    //}
    
    if (mutResponseData)
        mutResponseData=nil;
    
    if (theConnection)
        theConnection = nil;
    
    if (reachability)
        reachability = nil;
    
    SBJSON *objJson = [SBJSON new];
    NSDictionary *dictResponse = [objJson objectWithString:str];
    objJson = nil;
    
    str = nil;
    if (callBackTarget && callBackSelector)
        [callBackTarget performSelector:callBackSelector withObject:dictResponse];
    else
        NSLog(@"fail");
    
    callBackTarget = nil;
    callBackSelector = nil;
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"CONNECTION DID FAIL WITH ERROR");
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    NSLog(@"%@ %ld %@\n\n", [error domain], (long)[error code], [error localizedDescription]);
    
    //    NSDictionary *dictReturnCode = [[NSDictionary alloc]initWithObjectsAndKeys:[NSNumber numberWithInt:3],@"result", @"Error connection to Server",@"resultText",nil];
    //	NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:dictReturnCode,@"returnCode",nil];
    
    NSNumber *num=[NSNumber numberWithInt:3];
    
    NSDictionary *dictReturnCode = [[NSDictionary alloc]initWithObjectsAndKeys:[NSNumber numberWithInt:3],@"error", @"Error connection to Server",@"resultText",nil];
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:num,@"error",dictReturnCode,@"responseDict",nil];
    
    
    dictReturnCode = nil;
    
    [callBackTarget performSelector:callBackSelector withObject:dict];
    
    if (mutResponseData)
        mutResponseData=nil;
    
    if(theConnection)
        theConnection = nil;
    
    callBackTarget = nil;
    callBackSelector = nil;
}


#pragma mark
#pragma mark NSURLConnection Delegate Methods
#pragma mark

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection
                  willCacheResponse:(NSCachedURLResponse*)cachedResponse {
    // Return nil to indicate not necessary to store a cached response for this connection
    return nil;
}

//**********


#pragma mark
#pragma mark - XML Parser Methods
#pragma mark

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{
    
    if ([[NSUserDefaults standardUserDefaults]boolForKey: @"isGetPostalAdress"]) {
        
        
        NSLog(@"Element started =%@",elementName);
        str_currentElement=elementName;
        
        
    }
    
}

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
    
    if ([[NSUserDefaults standardUserDefaults]boolForKey: @"isGetPostalAdress"]) {
        
        NSLog(@"Element ended %@",elementName);
        
    }
    
}

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    
    
    if ([[NSUserDefaults standardUserDefaults]boolForKey: @"isGetPostalAdress"]) {
        
        AppDelegate *ojb_appdelegate =(AppDelegate*)[[UIApplication sharedApplication] delegate];
        
        NSLog(@"%hhd",[str_currentElement isEqualToString:@"ErrorNumber"]);
        
        if([str_currentElement isEqualToString:@"ErrorNumber"]==0)
        {
            
            if([str_currentElement isEqualToString:@"Address1"]  )   //Street
            {
                [[NSUserDefaults standardUserDefaults]setInteger:2 forKey:@"ErrorNumber"];
                
                
                NSLog(@"%@",[[NSUserDefaults standardUserDefaults]objectForKey :@"Address1"]);
                
                if ([[[NSUserDefaults standardUserDefaults]objectForKey :@"Address1"] length]==0)
                {
                    
                    NSLog(@" %@",string);
//                    [ojb_appdelegate.dict_PostalCode   setObject:string forKey:@"Address1"];
                    
                    [[NSUserDefaults standardUserDefaults]setObject:string forKey:@"Address1"];
                }
                
            }
            else if([str_currentElement isEqualToString:@"Town"])
            {
                [[NSUserDefaults standardUserDefaults]setInteger:2 forKey:@"ErrorNumber"];
                
                
                
                NSLog(@"%@",[[NSUserDefaults standardUserDefaults]objectForKey :@"Town"]);
                
                if ([[[NSUserDefaults standardUserDefaults]objectForKey :@"Town"] length]==0)
                {
                    
//                    NSLog(@" %@",string);
//                    [ojb_appdelegate.dict_PostalCode setObject:string forKey:@"Town"];
                    
                    
                    [[NSUserDefaults standardUserDefaults]setObject:string forKey:@"Town"];
                }
                
                
                
            }
            
            else if([str_currentElement isEqualToString:@"County"])
            {
                [[NSUserDefaults standardUserDefaults]setInteger:2 forKey:@"ErrorNumber"];
                
                
                NSLog(@"%@",[[NSUserDefaults standardUserDefaults]objectForKey :@"County"]);
                
                if ([[[NSUserDefaults standardUserDefaults]objectForKey :@"County"] length]==0)
                {
                    NSLog(@" %@",string);
//                    [ojb_appdelegate.dict_PostalCode setObject:string forKey:@"County"];
                    
                    [[NSUserDefaults standardUserDefaults]setObject:string forKey:@"County"];
                    
                    
                }
                
                
            }
            
            else if([str_currentElement isEqualToString:@"Postcode"])
            {
                [[NSUserDefaults standardUserDefaults]setInteger:2 forKey:@"ErrorNumber"];
                
                NSLog(@"%@",[[NSUserDefaults standardUserDefaults]objectForKey :@"Postcode"]);
                
                if ([[[NSUserDefaults standardUserDefaults]objectForKey :@"Postcode"] length]==0)
                {
                    
                    NSLog(@" %@",string);
//                    [ojb_appdelegate.dict_PostalCode setObject:string forKey:@"Postcode"];
                    
                    [[NSUserDefaults standardUserDefaults]setObject:string forKey:@"Postcode"];
                    
                }
                
                
            }
            else if([str_currentElement isEqualToString:@"PremiseData"])
            {
                
                
                NSLog(@"%@",[[NSUserDefaults standardUserDefaults]objectForKey :@"PremiseData"]);
                
                if ([[[NSUserDefaults standardUserDefaults]objectForKey :@"PremiseData"] count]==0)
                {
                    
                    NSLog(@" %@",string);
//                    [ojb_appdelegate.dict_PostalCode setObject:string forKey:@"PremiseData"];
                    
                    
                    
                    NSMutableArray *arr_=[[NSMutableArray alloc]init];
                    
                    int int_strlength=[string length];
                    
                    for (int i=0; i<int_strlength; i++)
                    {
                        if ([string length ]>0)
                        {
                            NSString *originalString = string;
                            
                            NSString *result;
                            NSScanner *scanner = [NSScanner scannerWithString:originalString];
                            NSCharacterSet *cs1 = [NSCharacterSet characterSetWithCharactersInString:@";"];
                            
                            
                            [scanner scanUpToCharactersFromSet:cs1 intoString:&result];
                            
                            
                            
                            //                            NSLog(@"Original String = %@",originalString);
                            //                            NSLog(@"Result = %@",result);
                            
                            
                            
                            string = [string stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@;",result] withString:@""];
                            
                            
                            if ([result length]>0)
                            {
                                result = [result stringByReplacingOccurrencesOfString:@"|" withString:@""];
                                
                                [arr_ addObject:result];
                                
                            }
                            
                            
                            scanner=nil;
                            cs1=nil;
                            
                        }
                        else
                            break;
                        
                    }
                    NSLog(@"Finally ==%@",arr_);
                    
                    
                    [[NSUserDefaults standardUserDefaults]setObject:arr_ forKey:@"PremiseData"];
                }
                
            }
            //        else if([str_currentElement isEqualToString:@"ErrorNumber"])
            //        {
            //            NSLog(@"%@",[[NSUserDefaults standardUserDefaults]objectForKey :@"ErrorNumber"]);
            //
            //            if ([[[NSUserDefaults standardUserDefaults]objectForKey :@"ErrorNumber"] length]==0)
            //            {
            //
            //                NSLog(@" %@",string);
            //                [ojb_appdelegate.dict_PostalCode setObject:string forKey:@"ErrorNumber"];
            //                [[NSUserDefaults standardUserDefaults]setObject:string forKey:@"ErrorNumber"];
            //            }
            //
            //        }
            
            else if([str_currentElement isEqualToString:@"ErrorNumber"])
            {
                NSLog(@"%ld",(long)[[NSUserDefaults standardUserDefaults] integerForKey :@"ErrorNumber"]);
                
                
                
                
                
                NSLog(@" %@",string);
                //                if ([[NSUserDefaults standardUserDefaults]objectForKey :@"ErrorNumber"] == (id)[NSNull null] && [[NSUserDefaults standardUserDefaults]objectForKey :@"ErrorNumber"] == NULL  && [[[NSUserDefaults standardUserDefaults]objectForKey :@"ErrorNumber"]isKindOfClass:[NSNull class]])
                //                {
//                [ojb_appdelegate.dict_PostalCode setObject:string forKey:@"ErrorNumber"];
                [[NSUserDefaults standardUserDefaults]setInteger:1  forKey:@"ErrorNumber"];
                //                }
                
            }
            else if ([str_currentElement isEqualToString:@"ErrorMessage"])
            {
                
                NSLog(@"%@",[[NSUserDefaults standardUserDefaults]objectForKey :@"ErrorMessage"]);
                
                NSLog(@" %@",string);
                if ([[[NSUserDefaults standardUserDefaults]objectForKey :@"ErrorMessage"] length]==0)
                {
//                    [ojb_appdelegate.dict_PostalCode setObject:string forKey:@"ErrorMessage"];
                    [[NSUserDefaults standardUserDefaults]setObject:string forKey:@"ErrorMessage"];
                }
            }
            
            
            
        }
        //        else
        //        {
        //
        //            if([str_currentElement isEqualToString:@"ErrorNumber"])
        //            {
        //                NSLog(@"%d",[[NSUserDefaults standardUserDefaults] integerForKey :@"ErrorNumber"]);
        //
        //                NSLog(@" %@",string);
        ////                if ([[NSUserDefaults standardUserDefaults]objectForKey :@"ErrorNumber"] == (id)[NSNull null] && [[NSUserDefaults standardUserDefaults]objectForKey :@"ErrorNumber"] == NULL  && [[[NSUserDefaults standardUserDefaults]objectForKey :@"ErrorNumber"]isKindOfClass:[NSNull class]])
        ////                {
        //                    [ojb_appdelegate.dict_PostalCode setObject:string forKey:@"ErrorNumber"];
        //                    [[NSUserDefaults standardUserDefaults]setInteger:1  forKey:@"ErrorNumber"];
        ////                }
        //
        //            }
        //            else if ([str_currentElement isEqualToString:@"ErrorMessage"])
        //            {
        //
        //                NSLog(@"%@",[[NSUserDefaults standardUserDefaults]objectForKey :@"ErrorMessage"]);
        //
        //                NSLog(@" %@",string);
        //                if ([[[NSUserDefaults standardUserDefaults]objectForKey :@"ErrorMessage"] length]==0)
        //                {
        //                    [ojb_appdelegate.dict_PostalCode setObject:string forKey:@"ErrorMessage"];
        //                    [[NSUserDefaults standardUserDefaults]setObject:string forKey:@"ErrorMessage"];
        //                }
        //            }
        //        }
        
        //    [[NSUserDefaults standardUserDefaults] setObject:dict_ forKey:@"PostalAddressDict"];
        //dict_=nil;
        
        
        // NSLog(@"POSTAL CODE DICT=%@",ojb_appdelegate.dict_PostalCode);
        
    }
    
    
}


@end
