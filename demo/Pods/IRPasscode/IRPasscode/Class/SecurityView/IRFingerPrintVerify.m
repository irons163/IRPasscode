//
//  IRFingerPrintVerify.m
//  IRPasscode
//
//  Created by Phil on 2019/11/14.
//  Copyright © 2019 Phil. All rights reserved.
//

#import "IRFingerPrintVerify.h"
#import <LocalAuthentication/LocalAuthentication.h>

@implementation IRFingerPrintVerify

#pragma mark FingerPrint
+ (void)fingerPrintLocalAuthenticationFallBackTitle:(NSString *)fallBackTitle localizedReason:(NSString *)reasonTitle callBack:(void(^)(BOOL isSuccess,NSError *_Nullable error,NSString *referenceMsg))fingerBlock {
    LAContext *context = [LAContext new];
    context.localizedFallbackTitle = fallBackTitle;
    NSError *error = nil;
    if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics
                             error:&error]) {
        NSLog(@"[IRFingerPrintVerify] FingerPrint Supported");
        [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics
                localizedReason:reasonTitle reply:^(BOOL success, NSError * _Nullable error) {
                    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                        fingerBlock(success,error,[self referenceErrorCode:error.code fallBack:fallBackTitle]);
                    }];
                    NSLog(@"[IRFingerPrintVerify] failure reason:%@",error.localizedDescription);
                }];
    }else{
        NSLog(@"[IRFingerPrintVerify] FingerPrint Not Support");
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            fingerBlock(false,error,[self referenceErrorCode:error.code fallBack:fallBackTitle]);
        }];

        NSLog(@"[IRFingerPrintVerify] failure reason:%@",error.localizedDescription);
    }
}

#pragma mark ErrorCode
+ (NSString *)referenceErrorCode:(NSInteger)errorCode fallBack:(NSString *)fallBackStr
{
    switch (errorCode) {
        case LAErrorAuthenticationFailed:
            return @"Authentication Failed";
            break;
        case LAErrorUserCancel:
            return @"User Cancel Touch ID";
            break;
        case LAErrorUserFallback:
            return fallBackStr;
            break;
        case LAErrorSystemCancel:
            return @"System Cancel";
            break;
        case LAErrorPasscodeNotSet:
            return @"Passcode Not Set";
            break;
        case LAErrorTouchIDNotAvailable:
            return @"Touch ID Not Availabl";
            break;
        case LAErrorTouchIDNotEnrolled:
            return @"Touch ID Not Enrolled";
            break;
        case LAErrorTouchIDLockout:
            return @"Touch ID Lockout";
            break;
        case LAErrorAppCancel:
            return @"App Cancel";
            break;
        case LAErrorInvalidContext:
            return @"Invalid Context";
            break;
        case LAErrorNotInteractive:
            return @"Not Interactive";
            break;
            
        default:
            return @"Success";
            break;
    }
}
@end

