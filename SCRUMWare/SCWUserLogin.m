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

NSString *const SCWLoginKey = @"DbfL^IicCZ\\N;JkTl:d=@SBQ?z>PVKEF74hnMsrHu";

@interface SCWUserLogin ()

@property (nonatomic) NSString *username;
@property (nonatomic) NSString *password;

@end

@implementation SCWUserLogin

- (instancetype)init {
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)loginWithUsername:(NSString *)username andPassword:(NSString *)password {
    self.username = username;
    self.password = [self encryptString:password];
}

- (void)logout {
    //TODO: ....
}

- (NSString *)encryptString:(NSString *)input {
    NSData *data = [input dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    
    NSData *encryptedData = [RNEncryptor encryptData:data withSettings:kRNCryptorAES256Settings password:SCWLoginKey error:&error];
    NSString *encryptedString = [[NSString alloc] initWithData:encryptedData encoding:NSUTF8StringEncoding];
    NSLog(@"Encrypted String - %@", encryptedString);
    //TODO: Return data instead of string?
    //Then send the data object throught the request?

    return encryptedString;
}


@end
