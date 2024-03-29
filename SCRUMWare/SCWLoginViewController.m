//
//  SCWLoginViewController.m
//  SCRUMWare
//
//  Created by Elvin Bearden.
//  Copyright (c) 2014 scrumware. All rights reserved.
//
//  TODO: Handle keyboard delegates.

#import "SCWLoginViewController.h"
#import "SCWUserLogin.h"
#import "SCWUser.h"
#import "SCWAppDelegate.h"

@interface SCWLoginViewController ()

@property (strong, nonatomic) IBOutlet UITextField *userNameTextField;
@property (strong, nonatomic) IBOutlet UITextField *passwordTextField;
@property (strong, nonatomic) IBOutlet UISwitch *stayLoggedInSwitch;
@property (strong, nonatomic) IBOutlet UIButton *loginButton;

- (IBAction)didPressLogin:(id)sender;

@end

@implementation SCWLoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.passwordTextField.delegate = self;
    self.userLogin.delegate = self;
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)didPressLogin:(id)sender {
    _userLogin.saveInformation = _stayLoggedInSwitch.on;

    NSString *username = _userNameTextField.text;
    NSString *password = _passwordTextField.text;

    if (!([username isEqualToString:@""] || [password isEqualToString:@""])) {
        [_userLogin loginWithUsername:username andPassword:password];
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oops!"
                                                        message:@"You forgot to enter something..."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles: nil];
        [alert show];

    }
}

#pragma mark - SCWUserLoginDelegate

- (void)loginSuccessful {
    [self writeToUserDefaults];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)loginFailed {
    
}


- (void)writeToUserDefaults {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    [userDefaults setObject:_userLogin.user.dictionary forKey:SCWUserKey];
    [userDefaults setBool:self.stayLoggedInSwitch.on forKey:SCWStayLoggedInKey];
    [userDefaults synchronize];

}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

@end
