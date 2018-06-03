//
//  StackOverflowAPIClient.h
//  wag-project
//
//  Created by Dinh Ho on 6/1/18.
//  Copyright © 2018 DInh Ho. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

@interface StackOverflowAPIClient : AFHTTPSessionManager

typedef void (^NSArrayResponseBlock)(NSArray *users, NSError *err);


+ (instancetype)sharedInstance;

- (NSURLSessionDataTask *)fetch:(NSArrayResponseBlock)block;

@end
