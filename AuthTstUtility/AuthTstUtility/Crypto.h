//
//  Crypto.h
//  AuthTstUtility
//
//  Created by BjornC on 10/1/14.
//  Copyright (c) 2014 Builtlight. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Crypto : NSObject

-(NSString*) signWithKey:(NSString *)key usingData:(NSString *)data;

@end
