//
//  BadgeCount.m
//  wag-project
//
//  Created by Dinh Ho on 6/1/18.
//  Copyright © 2018 DInh Ho. All rights reserved.
//

#import "BadgeCount.h"

@implementation BadgeCount

-(instancetype)initWithDictionary:(NSDictionary *)json {
    if (self = [super init]) {
        _bronze = [NSNumber numberWithInteger:[[json valueForKey:@"bronze"] integerValue]];
        _silver = [NSNumber numberWithInteger:[[json valueForKey:@"silver"] integerValue]];
        _gold = [NSNumber numberWithInteger:[[json valueForKey:@"gold"] integerValue]];
    }
    return self;
}

@end


#pragma mark - NSCoding

@implementation BadgeCount (NSCoding)

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.bronze forKey:@"bronze"];
    [aCoder encodeObject:self.silver forKey:@"silver"];
    [aCoder encodeObject:self.gold forKey:@"gold"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        _bronze = [aDecoder decodeObjectForKey:@"bronze"];
        _silver = [aDecoder decodeObjectForKey:@"silver"];
        _gold = [aDecoder decodeObjectForKey:@"gold"];
    }
    return self;
}

+ (BOOL)supportsSecureCoding {
    return YES;
}

@end
