//
//  SCWUserLogin.m
//  SCRUMWare
//
//  Created by Elvin Bearden.
//  Copyright (c) 2014 scrumware. All rights reserved.
//
// TODO: Create a user object on success.

#import "SCWUserLogin.h"
#import "RNCryptor/RNEncryptor.h"
#import "AFNetworking.h"
#import "SCWUser.h"

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
        NSDictionary *userDictionary = [[NSUserDefaults standardUserDefaults] objectForKey:@"SCWUser"];
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
    //TODO: ....
}

//- (NSString *)encryptString:(NSString *)input {
//    NSData *data = [input dataUsingEncoding:NSUTF8StringEncoding];
//    NSError *error;
//    
//    NSData *encryptedData = [RNEncryptor encryptData:data withSettings:kRNCryptorAES256Settings password:SCWLoginKey error:&error];
//    NSString *encryptedString = [[NSString alloc] initWithData:encryptedData encoding:NSUTF8StringEncoding];
//    NSLog(@"Encrypted String - %@", encryptedString);
//    //TODO: Return data instead of string?
//    //Then send the data object throught the request?
//
//    return encryptedString;
//}


@end
