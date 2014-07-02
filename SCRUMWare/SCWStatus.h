//
//  SCWStatus.h
//  SCRUMWare
//
//  Created by Elvin Bearden on 7/1/14.
//  Copyright (c) 2014 scrumware. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, SCWStatusType) {
    SCWStatusTypeTodo = 1,
    SCWStatusTypeInProcess = 2,
    SCWStatusTypeToVerify = 3,
    SCWStatusTypeDone = 4
};


@interface SCWStatus : NSObject

+ (NSString *)statusStringForStatusId:(NSInteger)statusId;
+ (NSInteger)statusIdForStatusType:(SCWStatusType)status;

@end
