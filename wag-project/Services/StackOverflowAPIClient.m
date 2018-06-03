//
//  StackOverflowAPIClient.m
//  wag-project
//
//  Created by Dinh Ho on 6/1/18.
//  Copyright © 2018 DInh Ho. All rights reserved.
//

#import "StackOverflowAPIClient.h"
#import "UserInfo.h"

NSString *const kStackOverflowApiUrl = @"https://api.stackexchange.com/2.2/";
NSString *const kUsersEndPoint = @"users?site=stackoverflow";

@implementation StackOverflowAPIClient

+ (instancetype)sharedInstance {
    static StackOverflowAPIClient *sharedInstace = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstace = [[StackOverflowAPIClient alloc] initWithBaseURL:[NSURL URLWithString:kStackOverflowApiUrl]];
        sharedInstace.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    });
    return sharedInstace;
}

- (NSURLSessionDataTask *)fetch:(NSArrayResponseBlock)block {
    
    return [self GET:kUsersEndPoint parameters:nil progress:nil success:^(NSURLSessionDataTask * __unused task, id json) {
        NSArray *usersFromResponse = [json valueForKeyPath:@"items"];
        NSMutableArray *usersArray = [NSMutableArray arrayWithCapacity:[usersFromResponse count]];
        
        [usersFromResponse enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [usersArray addObject:[[UserInfo alloc] initWithDictionary:obj]];
        }];
        
        if (block)
            block(usersArray, nil);
        
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        if (block)
            block(nil, error);
    }];
}

@end
