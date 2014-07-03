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

@interface SCWTaskViewController ()

@property (strong, nonatomic) IBOutlet UITextView *descriptionTextView;
@property (strong, nonatomic) IBOutlet UIButton *statusButton;

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
    self.navigationItem.leftBarButtonItem = backButton;
    
    self.descriptionTextView.text = _task.description;
    self.statusButton.titleLabel.text = [SCWStatus statusStringForStatusId:_task.statusId];
    
}

- (void)closeButtonPressed {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)didPressStatusButton:(id)sender {
    
}
@end
