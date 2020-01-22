//
//  IRSecurityPinViewController.h
//  IRPasscode
//
//  Created by Phil on 2019/11/14.
//  Copyright © 2019 Phil. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IRPasscodeView.h"

NS_ASSUME_NONNULL_BEGIN

@class IRSecurityPinViewController;

@protocol IRSecurityPinViewControllerDelegate <NSObject>
@optional

/*
 Will be called when pinCodeToCheck isEqualTo: entered PinCode
 */

- (void)pinCodeViewController:(IRSecurityPinViewController *)controller didVerifiedPincodeSuccessfully:(NSString *)pinCode;

/*
 Will be called when entered pin code don't match pinCodeToCheck;
 */

- (void)pinCodeViewController:(IRSecurityPinViewController *)controller didFailVerificationWithCount:(NSUInteger)failsCount;

/*
 Will be called when pin code created
 */

- (void)pinCodeViewController:(IRSecurityPinViewController *)controller didCreatePinCode:(NSString *)pinCode;


/*
 Will be called when pin code changed
 */

- (void)pinCodeViewController:(IRSecurityPinViewController *)controller didChangePinCode:(NSString *)pinCode;

- (void)pinCodeViewControllerDidCancel:(IRSecurityPinViewController *)controller;

@end

@interface IRSecurityPinViewController : UIViewController <IRPasscodeViewDelegate>
@property (weak, nonatomic) IBOutlet IRPasscodeView *pinCodeView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;

//You can set it on order to compare entered pin code with this var.
@property (nonatomic, strong) NSString *pinCodeToCheck;

//Failed attempts incrementer
@property (nonatomic, readonly) NSUInteger failedAttempts;

//Set this property to YES if you want to reset your current pinCode.
//Note: self.pinCodeToCheck must be non nil; Will raise an exception othervise
@property (nonatomic) BOOL shouldResetPinCode;

@property (nonatomic) BOOL cancellable;

//Delegate
@property (nonatomic, weak) id <IRSecurityPinViewControllerDelegate> delegate;

//You can override it for initial properties
- (void)commonInit;

- (void)unlockPinCode;

/*
 Strings.
 You can override all of them to show messages like alerts, set labels, etc...
 */

@property (nonatomic, strong) NSString *enterYourPinString;
@property (nonatomic, strong) NSString *createYourPinString;
@property (nonatomic, strong) NSString *pinVerifiedString;

@property (nonatomic, strong) NSString *pinsDontMatchTryOnceAgainString;
@property (nonatomic, strong) NSString *pinCreatedString;
@property (nonatomic, strong) NSString *enterOnceAgainString;


/*
 
 If not overrided, all of them will just NSLog about what message was shown.
 You should override them to show message in your custom UI (labels, alerts, etc...);
 
 */

- (void)showCreateThePinMessage;
- (void)showEnterYourPinMessage;
- (void)showPinsDontMatchMessage;
- (void)showPinCreatedMessage;
- (void)showEnterOnceAgainMessage;
- (void)showPinVerifiedMessage;

@end

NS_ASSUME_NONNULL_END
