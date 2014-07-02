//
//  SCWTasksViewController.m
//  SCRUMWare
//
//  Created by Elvin Bearden on 6/30/14.
//  Copyright (c) 2014 scrumware. All rights reserved.
//

#import "SCWTasksViewController.h"
#import "SCWTaskTableViewCell.h"
#import "AFNetworking.h"
#import "SCWTask.h"
#import "SCWStatus.h"

NSString *const SCWActiveTaskKey = @"active";
NSString *const SCWCompletedTaskKey = @"completed";
NSString *const SCWTasksCellIdentifier = @"SCWTasksCellID";
NSString *const SCWTasksBaseUrl = @"http://localhost:8080/SCRUMware/tasks";

@interface SCWTasksViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) NSDictionary *responseObject;
@property (nonatomic, retain) NSDictionary *taskDictionary;

@end

@implementation SCWTasksViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
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
    
    [self retrieveTasks];
    
    
}

- (void)retrieveTasks {
    NSString *urlString = [NSString stringWithFormat:@"%@?user_id=3&data_type=json", SCWTasksBaseUrl];
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
        [self.tableView reloadData];
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:[NSString stringWithFormat:@"%@", error]
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
            return [[_taskDictionary objectForKey:SCWActiveTaskKey] count];
        case 1:
            return [[_taskDictionary objectForKey:SCWCompletedTaskKey] count];
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
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
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
    cell.statusColorLabel.alpha = 0.5;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    view.tintColor = [UIColor grayColor];
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    [header.textLabel setTextColor:[UIColor blackColor]];
    view.alpha = 0.9;
}

- (UIColor *)colorForStatus:(SCWStatusType)status {
    switch (status) {
        case SCWStatusTypeTodo:
            return [UIColor yellowColor];
        case SCWStatusTypeInProcess:
            return [UIColor greenColor];
        case SCWStatusTypeToVerify:
        case SCWStatusTypeDone:
            return [UIColor lightGrayColor];
    }
    return [UIColor clearColor];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
