//
//  SCWUserLogin.h
//  SCRUMWare
//
//  Created by Elvin Bearden.
//  Copyright (c) 2014 scrumware. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SCWUserLoginDelegate <NSObject>

- (void)loginSuccessful;
- (void)loginFailed;

@end

@interface SCWUserLogin : NSObject

@property (nonatomic) id <SCWUserLoginDelegate> delegate;
@property (nonatomic) BOOL saveInformation;

// Only need to expose the username, the password can stay internal.
@property (nonatomic, readonly) NSString *username;
@property (nonatomic) BOOL isLoggedIn;

- (instancetype)init;
- (void)loginWithUsername:(NSString *)username andPassword:(NSString *)password;
- (void)logout;


@end
