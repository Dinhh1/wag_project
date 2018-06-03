//
//  BadgeCount.h
//  wag-project
//
//  Created by Dinh Ho on 6/1/18.
//  Copyright © 2018 DInh Ho. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BadgeCount : NSObject

-(instancetype)initWithDictionary:(NSDictionary *)json;

@property (nonatomic, strong) NSNumber* bronze;
@property (nonatomic, strong) NSNumber* silver;
@property (nonatomic, strong) NSNumber* gold;

@end
