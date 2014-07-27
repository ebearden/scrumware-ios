//
//  SCWTasksViewController.m
//  SCRUMWare
//
//  Created by Elvin Bearden on 6/30/14.
//  Copyright (c) 2014 scrumware. All rights reserved.
//

#import "SCWTasksViewController.h"
#import "SCWTaskTableViewCell.h"
#import "SCWTaskViewController.h"
#import "AFNetworking.h"
#import "SCWTask.h"
#import "SCWStatus.h"
#import "SCWUser.h"
#import "SCWAppDelegate.h"

NSString *const SCWActiveTaskKey = @"active";
NSString *const SCWCompletedTaskKey = @"completed";
NSString *const SCWTasksCellIdentifier = @"SCWTasksCellID";
NSString *const SCWTasksBaseUrl = @"http://localhost:8080/SCRUMware/task/tasks";

@interface SCWTasksViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) NSDictionary *responseObject;
@property (nonatomic, retain) NSDictionary *taskDictionary;
@property (nonatomic) BOOL loadingTasks;
@property (nonatomic, retain) SCWUser *user;

@end

@implementation SCWTasksViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _loadingTasks = YES;
        _user = [[SCWUser alloc] initWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:SCWUserKey]];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Tasks";
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.frame];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:_tableView];
}

- (void)viewDidAppear:(BOOL)animated {
    [self retrieveTasks];
}

- (void) viewWillDisappear:(BOOL)animated {
    [_tableView deselectRowAtIndexPath:[_tableView indexPathForSelectedRow] animated:animated];
    [super viewWillDisappear:animated];
}

// TODO: Use current userId.
- (void)retrieveTasks {
    NSString *urlString = [NSString stringWithFormat:@"%@?user_id=%d&data_type=json&key=%@", SCWTasksBaseUrl, _user.userId, SCWLoginKey];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        self.responseObject = (NSDictionary *)responseObject;
        NSMutableArray *activeArray = [[NSMutableArray alloc] init];
        NSMutableArray *completedArray = [[NSMutableArray alloc] init];
        for (NSDictionary *taskDict in _responseObject[@"result"]) {
            SCWTask *task = [[SCWTask alloc] initWithDictionary:taskDict];
            if (task.statusId == SCWStatusTypeTodo || task.statusId == SCWStatusTypeInProcess) {
                [activeArray addObject:task];
            }
            else {
                [completedArray addObject:task];
            }
        }

        self.taskDictionary = @{SCWActiveTaskKey: activeArray, SCWCompletedTaskKey:completedArray};
        [self tasksSuccessfullyLoaded];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:@"Error retrieving tasks."
                                                           delegate:self
                                                  cancelButtonTitle:@"Okay"
                                                  otherButtonTitles:nil];
        [alertView show];
    }];
    
    [operation start];
}

#pragma mark - TableView Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return _loadingTasks ? 1 : [[_taskDictionary objectForKey:SCWActiveTaskKey] count];
        case 1:
            return _loadingTasks ? 1 : [[_taskDictionary objectForKey:SCWCompletedTaskKey] count];
        default:
            return 0;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return @"Active Tasks";
        case 1:
            return @"Inactive Tasks";
        default:
            return nil;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SCWTaskTableViewCell *cell = (SCWTaskTableViewCell *)[_tableView dequeueReusableCellWithIdentifier:SCWTasksCellIdentifier];
    
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SCWTaskTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }

    NSArray *taskArray;
    
    switch (indexPath.section) {
        case 0:
            taskArray = _taskDictionary[SCWActiveTaskKey];
            break;
            
        case 1:
            taskArray = _taskDictionary[SCWCompletedTaskKey];
            break;
        default:
            NSLog(@"Error in _taskDictionary retrieval.");
            break;
    }
    
    cell.taskNameLabel.text = [taskArray[indexPath.row] name];
    cell.descriptionTextView.text = [taskArray[indexPath.row] description];
    cell.statusLabel.text = [SCWStatus statusStringForStatusId:[taskArray[indexPath.row] statusId]];
    cell.taskIdLabel.text = [NSString stringWithFormat:@"%d", [taskArray[indexPath.row] taskId]];
    cell.statusColorLabel.backgroundColor = [self colorForStatus:[taskArray[indexPath.row] statusId]];
    cell.statusColorLabel.alpha = 0.3;
    
    if (_loadingTasks) {
        [cell addSubview:[self overlayForCell:cell]];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SCWTaskViewController *controller = [[SCWTaskViewController alloc] initWithNibName:@"SCWTaskViewController" bundle:nil];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:controller];
    
    switch (indexPath.section) {
        case 0:
            controller.task = _taskDictionary[SCWActiveTaskKey][indexPath.row];
            break;
        case 1:
            controller.task = _taskDictionary[SCWCompletedTaskKey][indexPath.row];
            break;
        default:
            break;
    }
    
    controller.modalPresentationStyle = UIModalPresentationPageSheet;

    [self presentViewController:navigationController animated:YES completion:nil];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    view.tintColor = [UIColor darkGrayColor];
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    [header.textLabel setTextColor:[UIColor whiteColor]];
}

#pragma mark - Private Methods

- (UIView *)overlayForCell:(UITableViewCell *)cell {
    UIView *overlay = [[UIView alloc] init];
    overlay.frame = cell.frame;
    overlay.backgroundColor = [UIColor colorWithWhite:0 alpha:0.8];
    
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    activityIndicator.center = cell.center;
    [activityIndicator startAnimating];
    
    [overlay addSubview:activityIndicator];
    return overlay;
}

- (void)tasksSuccessfullyLoaded {
    _loadingTasks = NO;
    [self.tableView reloadData];
}

- (UIColor *)colorForStatus:(SCWStatusType)status {
    switch (status) {
        case SCWStatusTypeTodo:
            return [UIColor blackColor];
        case SCWStatusTypeInProcess:
            return [UIColor greenColor];
        case SCWStatusTypeToVerify:
        case SCWStatusTypeDone:
        default:
            return [UIColor clearColor];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
