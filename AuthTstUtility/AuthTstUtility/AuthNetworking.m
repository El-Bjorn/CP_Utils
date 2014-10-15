//
//  AuthNetworking.m
//  AuthTstUtility
//
//  Created by BjornC on 10/1/14.
//  Copyright (c) 2014 Builtlight. All rights reserved.
//

#import "AuthNetworking.h"
#import "Crypto.h"

//#define AUTH_DEBUG

#define AUTH_REQ_URL @"https://dev.copatient.com/api/account/authenticate"
//#define AUTH_REQ_URL @"https://dev.google.com/api/account/auth"   // should fail

#define AUTH_REQ_PATH @"/api/account/authenticate"

#define ACCESS_KEY @"630ac3f4c85b2e7c7c828ee048f7b3d9936312a3fff1a33648bfb34c146ec532"
#define SECRET_KEY @"fd9bbb59fa527dc161b08f3df2d5e2aa6db0017447c3001420b0a4033c6e4cbe"

#define CP_USER_NAME @"demouser"
#define CP_PASSWORD @"password1"

@implementation AuthNetworking

-(void) requestAuthTokenForUser:(NSString *)user withPasswd:(NSString *)password andCompletionBlock:(void (^)(void))compBlk {
    Crypto *crypt = [[Crypto alloc] init];
    
    NSURL *url = [NSURL URLWithString:AUTH_REQ_URL];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    // generate the authorization request
    NSString *authRequest = [NSString stringWithFormat:@"%@?access_key=%@&username=%@&password=%@",
                                                                        AUTH_REQ_PATH,
                                                                        ACCESS_KEY,
                                                                        user,
                                                                        password];
#ifdef AUTH_DEBUG
    NSLog(@"auth Request: %@",authRequest);
#endif
    
    // generate SHA256 hash signature
    NSString *hashValue = [crypt signWithKey:SECRET_KEY usingData:authRequest];
#ifdef AUTH_DEBUG
    NSLog(@"hash value: %@",hashValue);
#endif
    
    
    NSString *postString = [NSString stringWithFormat:@"access_key=%@&username=%@&password=%@&signature=%@",
                                                                        ACCESS_KEY,
                                                                        CP_USER_NAME,
                                                                        CP_PASSWORD,
                                                                        hashValue];
#ifdef AUTH_DEBUG
    NSLog(@"postString = %@",postString);
#endif
    
    // setup HTTP request
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];

    // do request and set 'self.authToken' if successful
    self.authToken = nil;
    self.errString = nil;
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[[NSOperationQueue alloc] init]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                               if (data) {
                                   NSError *err = nil;
                                   self.errString = nil;
                                   self.authToken = nil;
                                   
                                   NSDictionary *authDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&err];
                                   if (!authDict) {
#ifdef AUTH_DEBUG
                                       NSLog(@"Error parsing JSON: %@",err);
#endif
                                       self.errString = @"JSON parse error";
                                   } else {
#ifdef AUTH_DEBUG
                                       NSLog(@"return message: %@", authDict);
#endif
                                       if ([authDict[@"success"] boolValue] == YES) {
                                           self.authToken = authDict[@"return"]; // auth success
                                       } else {
                                           self.errString = authDict[@"error"]; // auth failed
                                       }
                                   }
                                   dispatch_async(dispatch_get_main_queue(), compBlk);
                               } else { // network error
                                   if (connectionError) {
                                       self.errString = [connectionError localizedDescription];
                                   } else {
                                       self.errString = @"Unknown connection error";
 
                                   }
                                   dispatch_async(dispatch_get_main_queue(), compBlk);
                                   
                               }
                           }];
}


@end
