//
//  SCWUserLoginTests.m
//  SCRUMWare
//
//  Created by Elvin Bearden on 6/1/14.
//  Copyright (c) 2014 scrumware. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "SCWUserLogin.h"

@interface SCWUserLoginTests : XCTestCase

@property (nonatomic) NSString *username;
@property (nonatomic) NSString *password;
@property (nonatomic) SCWUserLogin *userLogin;


@end

@implementation SCWUserLoginTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    self.userLogin = [[SCWUserLogin alloc] init];
    self.username = @"testUser";
    self.password = @"myPassword";
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testEncryption {
    [_userLogin loginWithUsername:_username andPassword:_password];
}


@end
