//
//  SCWTaskTableViewCell.h
//  SCRUMWare
//
//  Created by Elvin Bearden on 6/30/14.
//  Copyright (c) 2014 scrumware. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SCWTaskTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *taskNameLabel;
@property (strong, nonatomic) IBOutlet UITextView *descriptionTextView;

@property (strong, nonatomic) IBOutlet UILabel *statusLabel;
@property (strong, nonatomic) IBOutlet UILabel *taskIdLabel;
@property (strong, nonatomic) IBOutlet UIView *statusColorLabel;

@end
