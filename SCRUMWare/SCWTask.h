//
//  SCWTask.h
//  SCRUMWare
//
//  Created by Elvin Bearden on 6/30/14.
//  Copyright (c) 2014 scrumware. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SCWTask : NSObject

@property (nonatomic) NSInteger taskId;
@property (nonatomic) NSInteger assignedTo;
@property (nonatomic) NSInteger statusId;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *description;
@property (nonatomic, retain) NSString *workNotes;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
