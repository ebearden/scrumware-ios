//
//  SCWMainMenuViewController.m
//  SCRUMWare
//
//  Created by Elvin Bearden.
//  Copyright (c) 2014 scrumware. All rights reserved.
//

#import "SCWMainMenuViewController.h"
#import "SCWLoginViewController.h"
#import "SCWTasksViewController.h"
#import "SCWUserLogin.h"
#import "SCWUser.h"

// Main Menu Options
typedef NS_ENUM(NSUInteger, SCWMainMenuOption) {
    SCWMainMenuOptionTasks,
    SCWMainMenuOptionStories,
    SCWMainMenuOptionLogout
};

// Constants
NSInteger const SCWTableViewCellCount = 3;
NSString *const SCWTableViewCellIdentifier = @"MainMenuCell";

// Private Interface
@interface SCWMainMenuViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) SCWUserLogin *userLogin;
@property (strong, nonatomic) SCWUser *user;

@end

@implementation SCWMainMenuViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _userLogin = [[SCWUserLogin alloc] init];
        _user = [[SCWUser alloc] init];
        _user.firstName = @"Test";
        _user.lastName = @"User";
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

- (void)viewDidAppear:(BOOL)animated {
    // Present the login screen if user isn't logged in.
//    if (!_userLogin.isLoggedIn) {
//        [self showLoginScreen];
//    }
}

#pragma mark - TableView Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [NSString stringWithFormat:@"%@ %@", _user.firstName, _user.lastName];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return SCWTableViewCellCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SCWTableViewCellIdentifier];
    
    switch (indexPath.row) {
        case SCWMainMenuOptionTasks:
            cell.textLabel.text = @"Tasks";
            break;
        case SCWMainMenuOptionStories:
            cell.textLabel.text = @"Stories";
            break;
        case SCWMainMenuOptionLogout:
            cell.textLabel.text = @"Logout";
            break;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case SCWMainMenuOptionTasks: {
            SCWTasksViewController *controller = [[SCWTasksViewController alloc] init];
            [self.navigationController pushViewController:controller animated:YES];
        }
            break;
        case SCWMainMenuOptionStories:
            break;
        case SCWMainMenuOptionLogout:
            [_userLogin logout];
            [self showLoginScreen];
            break;

    }
}

#pragma mark - Private Methods

- (void)showLoginScreen {
    SCWLoginViewController *loginController = [[SCWLoginViewController alloc] initWithNibName:@"SCWLoginViewController" bundle:nil];
    loginController.modalPresentationStyle = UIModalPresentationPageSheet;
    loginController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self.navigationController presentViewController:loginController animated:YES completion:nil];
}

#pragma mark

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
