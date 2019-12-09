//
//  Utilities.m
//  demo
//
//  Created by Phil on 2019/12/9.
//  Copyright © 2019 Phil. All rights reserved.
//

#import "Utilities.h"
#import <IRPasscode/IRPasscode.h>

@implementation Utilities

+ (void)openSecurityPinPage {
    if ([IRSecurityPinManager sharedInstance].pinCode)
        [[IRSecurityPinManager sharedInstance] presentSecurityPinViewControllerForUnlockWithAnimated:YES completion:nil result:nil];
}

+ (void)removeSecurityPin {
    [[IRSecurityPinManager sharedInstance] removePinCode];
}

@end
