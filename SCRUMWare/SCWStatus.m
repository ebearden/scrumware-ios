//
//  SCWStatus.m
//  SCRUMWare
//
//  Created by Elvin Bearden on 7/1/14.
//  Copyright (c) 2014 scrumware. All rights reserved.
//

#import "SCWStatus.h"

@implementation SCWStatus

+ (NSString *)statusStringForStatusId:(NSInteger)statusId {
    switch (statusId) {
        case SCWStatusTypeTodo:
            return @"Todo";
        case SCWStatusTypeInProcess:
            return @"In Process";
        case SCWStatusTypeToVerify:
            return @"To Verify";
        case SCWStatusTypeDone:
            return @"Done";
    }
    return nil;
}

+ (NSInteger)statusIdForStatusType:(SCWStatusType)status {
    switch (status) {
        case SCWStatusTypeTodo:
            return 1;
        case SCWStatusTypeInProcess:
            return 2;
        case SCWStatusTypeToVerify:
            return 3;
        case SCWStatusTypeDone:
            return 4;
    }
}

@end
