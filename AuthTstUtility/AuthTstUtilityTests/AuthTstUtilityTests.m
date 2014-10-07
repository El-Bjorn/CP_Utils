//
//  AuthTstUtilityTests.m
//  AuthTstUtilityTests
//
//  Created by BjornC on 10/1/14.
//  Copyright (c) 2014 Builtlight. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "Crypto.h"
#import "AuthNetworking.h"

@interface AuthTstUtilityTests : XCTestCase

@end

@implementation AuthTstUtilityTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

-(void) testSHA256 {
    Crypto *crypt = [[Crypto alloc] init];
    
    NSString *auth_request = @"/api/account/authenticate?access_key=630ac3f4c85b2e7c7c828ee048f7b3d9936312a3fff1a33648bfb34c146ec532&username=demouser&password=password1";
    NSString *secretKey = @"fd9bbb59fa527dc161b08f3df2d5e2aa6db0017447c3001420b0a4033c6e4cbe";
    NSString *desiredHash = @"806e738a83c4c2f0c8f3f4116f666aaba6cbd151077d9dcbd7b03c8f9852de48";
    
    NSString *hashResult = [crypt signWithKey:secretKey usingData:auth_request];
    NSLog(@"hashResult= %@",hashResult);
    XCTAssertTrue([hashResult isEqualToString:desiredHash]);    
}

/*-(void) testAuth {
    AuthNetworking *auth = [[AuthNetworking alloc] init];

    NSString *authToken = [auth requestAuthTokenForUser:@"demouser" withPasswd:@"password1"];
    NSLog(@"auth token= %@",authToken);
    XCTAssertNotNil(authToken);
} */

- (void)testExample {
    // This is an example of a functional test case.
    XCTAssert(YES, @"Pass");
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
