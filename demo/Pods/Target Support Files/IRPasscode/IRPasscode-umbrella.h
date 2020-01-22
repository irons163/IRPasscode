#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "IRPasscode.h"
#import "IRSecurityPinManager.h"
#import "IRPasscodeLockSettingViewController.h"

FOUNDATION_EXPORT double IRPasscodeVersionNumber;
FOUNDATION_EXPORT const unsigned char IRPasscodeVersionString[];

