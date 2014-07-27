//
//  SCWUserLogin.m
//  SCRUMWare
//
//  Created by Elvin Bearden.
//  Copyright (c) 2014 scrumware. All rights reserved.
//
// TODO: Create a user object on success.

#import "SCWUserLogin.h"
#import "AFNetworking.h"
#import "SCWUser.h"
#import "SCWAppDelegate.h"

NSString *const SCWLoginBaseUrl = @"http://localhost:8080/SCRUMware/Login";

@interface SCWUserLogin ()

@property (nonatomic) NSString *username;
@property (nonatomic) NSString *password;
@property (nonatomic) NSDictionary *responseObject;

@end

@implementation SCWUserLogin

- (instancetype)init {
    self = [super init];
    if (self) {
        NSDictionary *userDictionary = [[NSUserDefaults standardUserDefaults] objectForKey:SCWUserKey];
        if (userDictionary) {
            _user = [[SCWUser alloc] initWithDictionary:userDictionary];
        }
        else {
            _user = [[SCWUser alloc] init];
        }
            
                     
    }
    return self;
}

- (void)loginWithUsername:(NSString *)username andPassword:(NSString *)password {
    self.username = username;
    self.password = password; //[self encryptString:password];
    
    NSString *urlString = [NSString stringWithFormat:@"%@?user_name=%@&password=%@&login_type=mobile", SCWLoginBaseUrl, username, password];
    
    NSURL *url = [NSURL URLWithString:urlString];
    NSLog(@"%@", url);
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        self.responseObject = (NSDictionary *)responseObject;
        self.user = [[SCWUser alloc] initWithDictionary:_responseObject[@"result"]];
        self.user.isLoggedIn = YES;
        [self.delegate loginSuccessful];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.delegate loginFailed];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:@"Error logging in."
                                                           delegate:self
                                                  cancelButtonTitle:@"Okay"
                                                  otherButtonTitles:nil];
        [alertView show];

    }];
    
    [operation start];
    
}

- (void)logout {
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:SCWStayLoggedInKey];
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:SCWUserKey];
}


@end
