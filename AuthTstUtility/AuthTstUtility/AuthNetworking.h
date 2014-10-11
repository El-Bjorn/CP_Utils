//
//  AuthNetworking.h
//  AuthTstUtility
//
//  Created by BjornC on 10/1/14.
//  Copyright (c) 2014 Builtlight. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AuthNetworking : NSObject

-(void) requestAuthTokenForUser:(NSString*)user withPasswd:(NSString*)password andCompletionBlock:(void (^)(void))compBlk;

@property (nonatomic,strong) NSString *authToken;
@property (nonatomic,strong) NSString *errString;

@end
