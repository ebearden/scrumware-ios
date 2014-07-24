//
//  SCWUser.m
//  SCRUMWare
//
//  Created by Elvin Bearden.
//  Copyright (c) 2014 scrumware. All rights reserved.
//

#import "SCWUser.h"

@implementation SCWUser

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        _userId = [dictionary[@"user_id"] intValue];
        _firstName = dictionary[@"first_name"];
        _lastName = dictionary[@"last_name"];
        _isLoggedIn = dictionary[@"isLoggedIn"] == nil ? NO : [dictionary[@"isLoggedIn"] boolValue];
    }
    
    return self;
}

- (NSDictionary *)dictionary {
    return @{ @"user_id": @(_userId), @"first_name": _firstName, @"last_name": _lastName, @"isLoggedIn": @(_isLoggedIn) };
             
}

@end
