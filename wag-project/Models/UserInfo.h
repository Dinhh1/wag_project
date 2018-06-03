//
//  UserInfo.h
//  wag-project
//
//  Created by Dinh Ho on 6/1/18.
//  Copyright © 2018 DInh Ho. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BadgeCount.h"

@interface UserInfo : NSObject

- (instancetype)initWithDictionary:(NSDictionary *)json;
- (NSURL *)profileImageURL;
- (NSString *)formattedReputation;

@property (nonatomic, strong) BadgeCount* badgeCount;
@property (nonatomic, strong) NSNumber* accountId;
@property (nonatomic, strong) NSNumber* reputation;
@property (nonatomic, strong) NSString *displayName;
@property (nonatomic, strong) NSString *profileImage;

@end

@interface UserInfo (NSCoding) <NSSecureCoding>
@end
