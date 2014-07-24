//
//  SCWLoginViewController.h
//  SCRUMWare
//
//  Created by Elvin Bearden.
//  Copyright (c) 2014 scrumware. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCWUserLogin.h"

@interface SCWLoginViewController : UIViewController <UITextFieldDelegate, SCWUserLoginDelegate>

@property (strong, nonatomic) SCWUserLogin *userLogin;

@end
