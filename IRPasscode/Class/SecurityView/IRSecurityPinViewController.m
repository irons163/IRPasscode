//
//  IRSecurityPinViewController.m
//  IRPasscode
//
//  Created by Phil on 2019/11/14.
//  Copyright © 2019 Phil. All rights reserved.
//

#import "IRSecurityPinViewController.h"
#import "IRLanguageManager.h"

@interface IRSecurityPinViewController () {
    BOOL _firstTimePinVerified;
}
@property (nonatomic, strong) NSString *firstTimeEnteredPin;

- (IBAction)numberClick:(UIButton*)sender;
- (IBAction)cancelClick:(id)sender;
- (IBAction)deleteClick:(id)sender;

@end

@implementation IRSecurityPinViewController

- (void)commonInit {
    _enterYourPinString = _(@"EnterPinString");
    _createYourPinString = _(@"CreatePinString");
    _enterOnceAgainString = _(@"EnterOnceAgainString");
    
    _pinsDontMatchTryOnceAgainString = _(@"PinsDontMatchTryOnceAgainString");
    
//    _pinCreatedString = NSLocalizedString(@"Pin Created", nil);
//    _pinVerifiedString = NSLocalizedString(@"Pin Verified", nil);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.pinCodeView.delegate = self;
    self.cancelButton.hidden = !self.cancellable;
    
    NSAssert(self.pinCodeView != nil, @"pinCodeView is not initialized");
    [self commonInit];
    [self setupDefaultMessage];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)unlockPinCode {
    self.pinCodeView.pinCode = _pinCodeToCheck;
}

#pragma mark - Pin Code View Delegate
- (void)pinCodeView:(IRPasscodeView*)view didEnterPin:(NSString*)pinCode
{
    // Small Hack to give time to show the last entered number
    double delayInSeconds = 0.15;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
        view.pinCode = nil;
        
        //Verify case
        if (self.pinCodeToCheck != nil && !self.shouldResetPinCode) {
            [self verifyPinWithEntered:pinCode];
        } else if (self.pinCodeToCheck != nil && self.shouldResetPinCode) {
            [self changePinWithEntered:pinCode];
        } else {
            [self setEnteredPin:pinCode];
        }
    });
}

#pragma mar - Pins Logic
- (void)verifyPinWithEntered:(NSString *)pinCode {
    //Pins matched
    if ([self.pinCodeToCheck isEqualToString:pinCode]) {
        
        if ([self.delegate respondsToSelector:@selector(pinCodeViewController:didVerifiedPincodeSuccessfully:)]) {
            [self.delegate pinCodeViewController:self didVerifiedPincodeSuccessfully:pinCode];
        }
        
        [self showPinVerifiedMessage];
    } else {
        _failedAttempts++;
        
        if ([self.delegate respondsToSelector:@selector(pinCodeViewController:didFailVerificationWithCount:)]) {
            [self.delegate pinCodeViewController:self didFailVerificationWithCount:self.failedAttempts];
        }
        [self showPinsDontMatchMessage];
    }
}

- (void)setEnteredPin:(NSString *)pinCode {
    
    //This is first attempt
    if (self.firstTimeEnteredPin == nil) {
        self.firstTimeEnteredPin = [pinCode copy];
        
        //Message
        [self showEnterOnceAgainMessage];
        
        //Here we should compare them
    } else {
        
        //They are equal
        if ([pinCode isEqualToString:self.firstTimeEnteredPin]) {
            if ([self.delegate respondsToSelector:@selector(pinCodeViewController:didCreatePinCode:)]) {
                [self.delegate pinCodeViewController:self didCreatePinCode:pinCode];
            }
            
            //Message
            [self showPinCreatedMessage];
            
            //Passwords don't match. Let's go over again
        } else {
            
            self.firstTimeEnteredPin = nil;
            _failedAttempts++;
            
            if ([self.delegate respondsToSelector:@selector(pinCodeViewController:didFailVerificationWithCount:)]) {
                [self.delegate pinCodeViewController:self didFailVerificationWithCount:self.failedAttempts];
            }
            
            //Message
            [self showPinsDontMatchMessage];
        }
    }
}

- (void)changePinWithEntered:(NSString *)pinCode {
    //User have not verified password yet
    if (!_firstTimePinVerified) {
        
        //user entered valid
        if ([self.pinCodeToCheck isEqualToString:pinCode]) {
            
            _firstTimePinVerified = YES;
            
            //Message
            [self showCreateThePinMessage];
        } else {
            
            //Notify about fail
            _failedAttempts++;
            if ([self.delegate respondsToSelector:@selector(pinCodeViewController:didFailVerificationWithCount:)]) {
                [self.delegate pinCodeViewController:self didFailVerificationWithCount:self.failedAttempts];
            }
            
            //Message
            [self showPinsDontMatchMessage];
        }
    } else {
        
        //Create new password
        if (self.firstTimeEnteredPin == nil) {
            self.firstTimeEnteredPin = [pinCode copy];
            
            [self showEnterOnceAgainMessage];
        } else {
            
            //Everything is good
            if ([self.firstTimeEnteredPin isEqualToString:pinCode]) {
                
                if ([self.delegate respondsToSelector:@selector(pinCodeViewController:didChangePinCode:)]) {
                    [self.delegate pinCodeViewController:self didChangePinCode:pinCode];
                }
                
                [self showPinCreatedMessage];
                
                //Password don't match. Let's go to step 2
            } else {
                
                self.firstTimeEnteredPin = nil;
                _failedAttempts++;
                
                if ([self.delegate respondsToSelector:@selector(pinCodeViewController:didFailVerificationWithCount:)]) {
                    [self.delegate pinCodeViewController:self didFailVerificationWithCount:self.failedAttempts];
                }
                //Message
                [self showPinsDontMatchMessage];
            }
        }
    }
}

#pragma mark - Messages
- (void)setupDefaultMessage {
    //Verify case
    if (self.pinCodeToCheck != nil && self.cancellable) {
        [self showEnterYourOldPinMessage];
    }else if (self.pinCodeToCheck != nil && !self.shouldResetPinCode) {
        [self showEnterYourPinMessage];
    } else if (self.pinCodeToCheck != nil && self.shouldResetPinCode) {
        [self showEnterYourOldPinMessage];
    } else {
        [self showCreateThePinMessage];
    }
}

/*
 
 Sample messages you can override them.
 
 */

- (void)showCreateThePinMessage {
    self.titleLabel.text = self.createYourPinString;
    self.messageLabel.text = _(@"CreatePinMsgString");
}

- (void)showEnterOnceAgainMessage {
    self.titleLabel.text = self.enterOnceAgainString;
    self.messageLabel.text = _(@"ConfirmPinMsgString");
}

- (void)showPinCreatedMessage {
//    self.titleLabel.text = self.pinCreatedString;
}

- (void)showPinsDontMatchMessage {
    self.messageLabel.text = self.pinsDontMatchTryOnceAgainString;
}

- (void)showEnterYourPinMessage {
    self.titleLabel.text = self.enterYourPinString;
    self.messageLabel.text = _(@"EnterPinMsgString");
}

- (void)showEnterYourOldPinMessage {
    self.titleLabel.text = self.enterYourPinString;
    self.messageLabel.text = _(@"EnterOldPinMsgString");
}

- (void)showPinVerifiedMessage {
//    self.titleLabel.text = self.pinCreatedString;
}

- (IBAction)numberClick:(UIButton*)sender {
    self.pinCodeView.pinCode = [NSString stringWithFormat:@"%@%@", self.pinCodeView.pinCode ? self.pinCodeView.pinCode : @"", sender.titleLabel.text];
}

- (IBAction)cancelClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(pinCodeViewControllerDidCancel:)]) {
        [self.delegate pinCodeViewControllerDidCancel:self];
    }
}

- (IBAction)deleteClick:(id)sender {
    if(self.pinCodeView.pinCode.length > 0)
        self.pinCodeView.pinCode = [self.pinCodeView.pinCode substringToIndex:[self.pinCodeView.pinCode length]-1];
}
@end

