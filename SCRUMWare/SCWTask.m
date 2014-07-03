//
//  SCWTask.m
//  SCRUMWare
//
//  Created by Elvin Bearden on 6/30/14.
//  Copyright (c) 2014 scrumware. All rights reserved.
//

#import "SCWTask.h"

@implementation SCWTask

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        _taskId = [dictionary[@"task_id"] intValue];
        _assignedTo = [dictionary[@"assigned_to"] intValue];
        _statusId = [dictionary[@"status_id"] intValue];
        _name = [NSString stringWithFormat:@"%@", dictionary[@"task_name"]];
        _description = [NSString stringWithFormat:@"%@", dictionary[@"description"]];
        _workNotes = [NSString stringWithFormat:@"%@", dictionary[@"work_notes"]];
    }
    
    return self;
}

@end
