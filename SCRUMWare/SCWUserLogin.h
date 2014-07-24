//
//  SCWUserLogin.h
//  SCRUMWare
//
//  Created by Elvin Bearden.
//  Copyright (c) 2014 scrumware. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SCWUser;
@protocol SCWUserLoginDelegate <NSObject>

- (void)loginSuccessful;
- (void)loginFailed;

@end

@interface SCWUserLogin : NSObject

@property (nonatomic) id <SCWUserLoginDelegate> delegate;
@property (nonatomic) BOOL saveInformation;
@property (nonatomic, retain) SCWUser *user;

- (instancetype)init;
- (void)loginWithUsername:(NSString *)username andPassword:(NSString *)password;
- (void)logout;


@end
