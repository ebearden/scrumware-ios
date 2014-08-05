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
    SCWMainMenuOptionLogout
};

// Constants
NSInteger const SCWTableViewCellCount = 3;
NSString *const SCWMenuTableViewCellIdentifier = @"MainMenuCell";

// Private Interface
@interface SCWMainMenuViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) SCWUserLogin *userLogin;

@end

@implementation SCWMainMenuViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _userLogin = [[SCWUserLogin alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

- (void) viewWillDisappear:(BOOL)animated {
    [_tableView deselectRowAtIndexPath:[_tableView indexPathForSelectedRow] animated:animated];
    [super viewWillDisappear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    // Present the login screen if user isn't logged in.
    if (!_userLogin.user.isLoggedIn) {
        [self showLoginScreen];
    } else {
        [self.tableView reloadData];
    }
    
}

#pragma mark - TableView Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [NSString stringWithFormat:@"%@ %@", _userLogin.user.firstName, _userLogin.user.lastName];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return SCWTableViewCellCount;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    view.tintColor = [UIColor grayColor];
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    [header.textLabel setTextColor:[UIColor whiteColor]];
    view.alpha = 0.9;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = (UITableViewCell *)[_tableView dequeueReusableCellWithIdentifier:SCWMenuTableViewCellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:SCWMenuTableViewCellIdentifier];
    }
    

    
    switch (indexPath.row) {
        case SCWMainMenuOptionTasks:
            cell.textLabel.text = @"Tasks";
            cell.detailTextLabel.text = @"View your current task assignments.";
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
        
        case SCWMainMenuOptionLogout: {
            [_userLogin logout];
            [self showLoginScreen];
        }
        break;

    }
}

#pragma mark - Private Methods

- (void)showLoginScreen {
    SCWLoginViewController *loginController = [[SCWLoginViewController alloc] initWithNibName:@"SCWLoginViewController" bundle:nil];
    loginController.userLogin = _userLogin;
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
