//
//  AuthNetworking.m
//  AuthTstUtility
//
//  Created by BjornC on 10/1/14.
//  Copyright (c) 2014 Builtlight. All rights reserved.
//

#import "AuthNetworking.h"
#import "Crypto.h"

#define AUTH_REQ_URL @"https://dev.copatient.com/api/account/authenticate"
#define AUTH_REQ_PATH @"/api/account/authenticate"

#define ACCESS_KEY @"630ac3f4c85b2e7c7c828ee048f7b3d9936312a3fff1a33648bfb34c146ec532"
#define SECRET_KEY @"fd9bbb59fa527dc161b08f3df2d5e2aa6db0017447c3001420b0a4033c6e4cbe"

#define CP_USER_NAME @"demouser"
#define CP_PASSWORD @"password1"

@implementation AuthNetworking

-(NSString*) requestAuthTokenForUser:(NSString *)user withPasswd:(NSString *)password {
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
    NSLog(@"auth Request: %@",authRequest);
    
    // generate SHA256 hash signature
    NSString *hashValue = [crypt signWithKey:SECRET_KEY usingData:authRequest];
    NSLog(@"hash value: %@",hashValue);
    
    
    NSString *postString = [NSString stringWithFormat:@"access_key=%@&username=%@&password=%@&signature=%@",
                                                                        ACCESS_KEY,
                                                                        CP_USER_NAME,
                                                                        CP_PASSWORD,
                                                                        hashValue];
    NSLog(@"postString = %@",postString);
    
    // setup HTTP request
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    
    // send request
    NSURLResponse *resp = nil;
    NSError *err = nil;
    NSData *respData = [NSURLConnection sendSynchronousRequest:request returningResponse:&resp error:&err];
    
    // parse json
    err=nil;
    NSDictionary *authDict = [NSJSONSerialization JSONObjectWithData:respData options:NSJSONReadingAllowFragments error:&err];
    if (!authDict) {
        NSLog(@"Error parsing JSON: %@",err);
    } else {
        NSLog(@"authDict= %@",authDict);
        return authDict[@"return"];
    }
    return nil;
}


@end
