//
//  SCWUser.h
//  SCRUMWare
//
//  Created by Elvin Bearden.
//  Copyright (c) 2014 scrumware. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SCWUser : NSObject


@property (nonatomic) BOOL isLoggedIn;
@property (nonatomic) NSInteger userId;
@property (nonatomic, retain) NSString *firstName;
@property (nonatomic, retain) NSString *lastName;
@property (nonatomic, retain) NSString *role;
@property (nonatomic, retain) NSString *username;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;
- (NSDictionary *)dictionary;

@end
