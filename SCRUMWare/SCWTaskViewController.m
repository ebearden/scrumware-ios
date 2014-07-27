//
//  SCWTaskViewController.m
//  SCRUMWare
//
//  Created by Elvin Bearden on 7/2/14.
//  Copyright (c) 2014 scrumware. All rights reserved.
//

#import "SCWTaskViewController.h"
#import "SCWTask.h"
#import "SCWStatus.h"
#import "AFNetworking.h"
#import "SCWAppDelegate.h"

NSString *const SCWDependencyCellIdentifier = @"DependencyCell";

@interface SCWTaskViewController ()

@property (strong, nonatomic) IBOutlet UITextView *descriptionTextView;
@property (strong, nonatomic) IBOutlet UIButton *statusButton;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

- (IBAction)didPressStatusButton:(id)sender;

@end

@implementation SCWTaskViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = _task.name;
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(closeButtonPressed)];
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStyleDone target:self action:@selector(saveButtonPressed)];
    
    self.navigationItem.leftBarButtonItem = backButton;
    self.navigationItem.rightBarButtonItem = saveButton;
    
    self.navigationController.navigationBar.titleTextAttributes = @{NSFontAttributeName: [UIFont fontWithName:@"Avenir Next" size:16]};
    
    self.descriptionTextView.text = _task.description;
    [self setStatusButtonTitleForStatusId:_task.statusId];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UITableView

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SCWDependencyCellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SCWDependencyCellIdentifier];
    }
    cell.textLabel.text = [_task.dependsOn objectAtIndex:indexPath.row];
    cell.textLabel.font = [UIFont fontWithName:@"Avenir Next" size:16];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_task.dependsOn count];
}

#pragma mark - Selectors

- (IBAction)didPressStatusButton:(id)sender {
    NSArray *buttonTitles;
    if ([_task.dependsOn count] > 0) {
        buttonTitles = @[@"Todo", @"In Process", @"To Verify"];
    }
    else {
        buttonTitles = @[@"Todo", @"In Process", @"To Verify", @"Done"];
    }
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Status"
                                                             delegate:self
                                                    cancelButtonTitle:nil
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:nil];
    
    for (NSString *title in buttonTitles) {
        [actionSheet addButtonWithTitle:title];
    }
    [actionSheet addButtonWithTitle:@"Cancel"];
    actionSheet.cancelButtonIndex = [buttonTitles count];
    
    [actionSheet showInView:self.view];
}

- (void)closeButtonPressed {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)saveButtonPressed {
    [self saveTask:_task];
}

- (void)saveTask:(SCWTask *)task {
    _task.description = _descriptionTextView.text;
    NSString *urlString = [NSString stringWithFormat:@"http://localhost:8080/SCRUMware/task/edit"];

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{@"user_id": @(_task.assignedTo),
                                 @"assigned_to": @(_task.assignedTo),
                                 @"task_id": @(_task.taskId),
                                 @"status_id": @(_task.statusId),
                                 @"task_name": _task.name,
                                 @"description": _task.description,
                                 @"work_notes": _task.workNotes,
                                 @"request_type": @"mobile",
                                 @"key": SCWLoginKey
                                 };
    
    [manager POST:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Success");
        [self dismissViewControllerAnimated:YES completion:nil];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Failed to save changes" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles: nil];
        [alertView show];
        NSLog(@"%@", error);
    }];
}

- (void)setStatusButtonTitleForStatusId:(NSInteger)statusId {
    [self.statusButton setTitle:[SCWStatus statusStringForStatusId:statusId] forState:UIControlStateNormal];
    [self.statusButton setTitle:[SCWStatus statusStringForStatusId:statusId] forState:UIControlStateSelected];
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"Cancel"]) {
        return;
    }
    self.task.statusId = buttonIndex + 1;
    [self setStatusButtonTitleForStatusId:_task.statusId];
}


@end
