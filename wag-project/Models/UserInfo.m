//
//  UserInfo.m
//  wag-project
//
//  Created by Dinh Ho on 6/1/18.
//  Copyright © 2018 DInh Ho. All rights reserved.
//

#import "UserInfo.h"
#import "BadgeCount.h"

@implementation UserInfo

-(instancetype)initWithDictionary:(NSDictionary *)json {
    if (self = [super init]) {
        _badgeCount = [[BadgeCount alloc] initWithDictionary:json[@"badge_counts"]];
        _accountId = [NSNumber numberWithInteger:[[json valueForKey:@"account_id"] integerValue]];
        _reputation = [NSNumber numberWithInteger:[[json valueForKey:@"reputation"] integerValue]];
        _displayName = json[@"display_name"];
        _profileImage = json[@"profile_image"];
    }
    return self;
}

- (NSURL *)profileImageURL {
    return [NSURL URLWithString:self.profileImage];
}

- (NSString *)formattedReputation {
    if ([self.reputation integerValue] >= 1000) {
        NSInteger kFormatted = [self.reputation integerValue] / 1000;
        return [NSString stringWithFormat:@"%lik", kFormatted];
    }
    return [self.reputation stringValue];
}

@end

#pragma mark - NSCoding

@implementation UserInfo (NSCoding)

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.badgeCount forKey:@"badgeCount"];
    [aCoder encodeObject:self.accountId forKey:@"accountId"];
    [aCoder encodeObject:self.reputation forKey:@"reputation"];
    [aCoder encodeObject:self.displayName forKey:@"displayName"];
    [aCoder encodeObject:self.profileImage forKey:@"profileImage"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        _badgeCount = [aDecoder decodeObjectForKey:@"badgeCount"];
        _accountId = [aDecoder decodeObjectForKey:@"accountId"];
        _reputation = [aDecoder decodeObjectForKey:@"reputation"];
        _displayName = [aDecoder decodeObjectForKey:@"displayName"];
        _profileImage = [aDecoder decodeObjectForKey:@"profileImage"];
    }
    return self;
}

+ (BOOL)supportsSecureCoding {
    return YES;
}

@end
