//
//  Crypto.m
//  AuthTstUtility
//
//  Created by BjornC on 10/1/14.
//  Copyright (c) 2014 Builtlight. All rights reserved.
//

#import "Crypto.h"
#import <CommonCrypto/CommonCrypto.h>

@implementation Crypto

-(NSString *)signWithKey:(NSString *)key usingData:(NSString *)data
{
    const char *cKey  = [key cStringUsingEncoding:NSASCIIStringEncoding];
    const char *cData = [data cStringUsingEncoding:NSASCIIStringEncoding];
    
    unsigned char cHMAC[CC_SHA256_DIGEST_LENGTH];
    
    CCHmac(kCCHmacAlgSHA256, cKey, strlen(cKey), cData, strlen(cData), cHMAC);
    
    NSData *HMAC = [[NSData alloc] initWithBytes:cHMAC length:sizeof(cHMAC)];
    
    return [[HMAC.description stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]] stringByReplacingOccurrencesOfString:@" " withString:@""];
}


@end
