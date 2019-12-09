//
//  IRSecurityPinManager.m
//  IRPasscode
//
//  Created by Phil on 2019/11/14.
//  Copyright © 2019 Phil. All rights reserved.
//

#import "IRSecurityPinManager.h"
#import "IRSecurityPinViewController.h"
#import "IRFingerPrintVerify.h"
#import "IRLanguageManager.h"
#import <UICKeyChainStore/UICKeyChainStore.h>

#define kCurrentPinKey @"kCurrentPinKey"

@interface IRSecurityPinManager()<IRSecurityPinViewControllerDelegate>
@property (nonatomic, strong) UIButton *fingerPrintIcon;
@property (nonatomic, strong) UIButton *referenceBtn;

@property (strong) IRSecurityPinViewController *securityPinViewController;
@property (strong) ResultBlock result;
@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) UICKeyChainStore *keychainStore;
@property (nonatomic, strong, readwrite) NSString *pinCode;
@end

@implementation IRSecurityPinManager

+ (instancetype)sharedInstance {
    static IRSecurityPinManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init {
    if (self = [super init]) {
        _keychainStore = [UICKeyChainStore keyChainStore];
        _pinCode = _keychainStore[kCurrentPinKey];
    }
    return self;
}

- (void)presentSecurityPinViewControllerWithAnimated:(BOOL)flag completion:(void (^ _Nullable)(void))completion cancellable:(BOOL)cancellable isChangeCode:(BOOL)isChangeCode {
    if(self.window)
        flag = NO;
    [self.securityPinViewController dismissViewControllerAnimated:NO completion:nil];
    [self cleanup];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    self.window.opaque = NO;
    
    self.window.rootViewController = [UIViewController new];
    [self.window makeKeyAndVisible];
    
    self.securityPinViewController = nil;
//    IRSecurityPinViewController *securityPinViewController = [IRSecurityPinViewController new];
    NSBundle *xibBundle = [NSBundle bundleForClass:[IRSecurityPinViewController class]];
    IRSecurityPinViewController *securityPinViewController = [[IRSecurityPinViewController alloc] initWithNibName:@"IRSecurityPinViewController" bundle:xibBundle];
    securityPinViewController.delegate = self;
    securityPinViewController.cancellable = cancellable;
    self.securityPinViewController = securityPinViewController;
    if(_pinCode)
        securityPinViewController.pinCodeToCheck = _pinCode;
    
    if(isChangeCode)
        securityPinViewController.shouldResetPinCode = isChangeCode;
    //    [[SecurityPinManager sharedInstance] presentViewController:securityPinViewController animated:YES completion:nil];
    //    [SecurityPinManager sharedInstance].window.rootViewController = securityPinViewController;
    
    [self.window.rootViewController presentViewController:securityPinViewController animated:flag completion:completion];
}

- (void)presentSecurityPinViewControllerForChangePasscodeWithAnimated: (BOOL)flag completion:(void (^ __nullable)(void))completion result:(ResultBlock _Nullable )result {
    [self presentSecurityPinViewControllerWithAnimated:flag cancellable:YES isChangeCode:YES usePolicyDeviceOwnerAuthentication:YES completion:completion result:result];
}

- (void)presentSecurityPinViewControllerForCreateWithAnimated: (BOOL)flag completion:(void (^ __nullable)(void))completion result:(ResultBlock _Nullable )result {
    [self presentSecurityPinViewControllerWithAnimated:flag cancellable:YES isChangeCode:NO usePolicyDeviceOwnerAuthentication:NO completion:completion result:result];
}

- (void)presentSecurityPinViewControllerForRemoveWithAnimated: (BOOL)flag completion:(void (^ __nullable)(void))completion result:(ResultBlock _Nullable )result {
    [self presentSecurityPinViewControllerWithAnimated:flag cancellable:YES isChangeCode:NO usePolicyDeviceOwnerAuthentication:YES completion:completion result:result];
}

- (void)presentSecurityPinViewControllerForUnlockWithAnimated: (BOOL)flag completion:(void (^ __nullable)(void))completion result:(ResultBlock _Nullable )result {
    [self presentSecurityPinViewControllerWithAnimated:flag cancellable:NO isChangeCode:NO usePolicyDeviceOwnerAuthentication:YES completion:completion result:result];
}

- (void)presentSecurityPinViewControllerWithAnimated:(BOOL)flag cancellable:(BOOL)cancellable isChangeCode:(BOOL)isChangeCode usePolicyDeviceOwnerAuthentication:(BOOL)use completion:(void (^ __nullable)(void))completion result:(ResultBlock _Nullable )result {
    self.result = result;
    [self presentSecurityPinViewControllerWithAnimated:flag completion:completion cancellable:cancellable isChangeCode:isChangeCode];
    
    if(use)
        [IRFingerPrintVerify fingerPrintLocalAuthenticationFallBackTitle:@"" localizedReason:_(@"PasscodeLock") callBack:^(BOOL isSuccess, NSError * _Nullable error, NSString *referenceMsg) {
            //        [btn setTitle:referenceMsg forState:UIControlStateNormal];
            if (isSuccess) {
                [self.securityPinViewController unlockPinCode];
            }
        }];
}

//- (void)presentSecurityPinViewControllerWithAnimated: (BOOL)flag completion:(void (^ __nullable)(void))completion result:(ResultBlock _Nullable )result {
//    self.result = result;
//    [self presentSecurityPinViewControllerWithAnimated:flag completion:completion cancellable:NO isChangeCode:NO];
//
//    [MHD_FingerPrintVerify mhd_fingerPrintLocalAuthenticationFallBackTitle:nil localizedReason:@"指紋/臉部辨識" callBack:^(BOOL isSuccess, NSError * _Nullable error, NSString *referenceMsg) {
////        [btn setTitle:referenceMsg forState:UIControlStateNormal];
//        if (isSuccess) {
//            [self.securityPinViewController unlockPinCode];
//        }
//    }];
//}

- (void)cleanup {
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[[[UIApplication sharedApplication] delegate] window] makeKeyWindow];
    [self.window removeFromSuperview];
    self.window = nil;
}

- (void)setPinCode:(NSString *)pinCode {
    _pinCode = pinCode;
    _keychainStore[kCurrentPinKey] = pinCode;
}

- (void)removePinCode {
    self.pinCode = nil;
}

#pragma mark - Delegates
//Create
- (void)pinCodeViewController:(IRSecurityPinViewController *)controller didCreatePinCode:(NSString *)pinCode {
    self.pinCode = pinCode;
    
    [controller dismissViewControllerAnimated:YES completion:nil];
    [self showAlertWithMessage:@"Pin created"];
    [self cleanup];
    if(self.result)
        self.result(Created);
}

//Verify
- (void)pinCodeViewController:(IRSecurityPinViewController *)controller didVerifiedPincodeSuccessfully:(NSString *)pinCode {
    [controller dismissViewControllerAnimated:YES completion:nil];
    [self showAlertWithMessage:@"Pin verified"];
    [self cleanup];
    if(self.result)
        self.result(Verified);
}

//Change
- (void)pinCodeViewController:(IRSecurityPinViewController *)controller didChangePinCode:(NSString *)pinCode {
    self.pinCode = pinCode;
    [controller dismissViewControllerAnimated:YES completion:nil];
    [self showAlertWithMessage:@"Pin changed"];
    [self cleanup];
    if(self.result)
        self.result(Changed);
}

//Cancel
- (void)pinCodeViewControllerDidCancel:(IRSecurityPinViewController *)controller {
    [controller dismissViewControllerAnimated:YES completion:nil];
    [self showAlertWithMessage:@"Pin canceld"];
    [self cleanup];
    if(self.result)
        self.result(Changed);
}

#pragma mark - Alert
- (void)showAlertWithMessage:(NSString *)message {
    
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
//                                                    message:message
//                                                   delegate:nil
//                                          cancelButtonTitle:@"Dismiss"
//                                          otherButtonTitles:nil];
//    [alert show];
}

- (UIButton *)fingerPrintIcon
{
//    if (!_fingerPrintIcon) {
//        _fingerPrintIcon = [UIButton buttonWithType:UIButtonTypeCustom];
//        [_fingerPrintIcon setImage:[UIImage imageNamed:@"open_lock_way_finger"] forState:UIControlStateNormal];
//        _fingerPrintIcon.imageView.contentMode = UIViewContentModeScaleAspectFill;
//        _fingerPrintIcon.bounds = CGRectMake(0, 0, MAIN_SIZE.width/2, MAIN_SIZE.height/4);
//        _fingerPrintIcon.center = self.view.center;
//        [_fingerPrintIcon addTarget:self action:@selector(fingerPrintIconAction:) forControlEvents:UIControlEventTouchUpInside];
//        [self.view addSubview:_fingerPrintIcon];
//    }
    return _fingerPrintIcon;
}
- (void)fingerPrintIconAction:(UIButton *)btn
{
    [self referenceBtnAction:_referenceBtn];
}
- (UIButton *)referenceBtn
{
//    if (!_referenceBtn) {
//        _referenceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        //        [_referenceBtn mhd_buttonWithTitle:@"点击验证指纹" backColor:[UIColor colorWithRed:0/255.0 green:204/255.0 blue:173/255.0 alpha:1] font:17 titleColor:[UIColor whiteColor] cornerRadius:5];
//        [_referenceBtn setTitle:@"点击验证指纹" forState:UIControlStateNormal];
//        _referenceBtn.bounds = CGRectMake(0, 0, MAIN_SIZE.width/2, 30);
//        _referenceBtn.center = CGPointMake(self.view.center.x, _fingerPrintIcon.center.y+MAIN_SIZE.height/8);
//        _referenceBtn.titleLabel.adjustsFontSizeToFitWidth = true;
//        [_referenceBtn addTarget:self action:@selector(referenceBtnAction:) forControlEvents:UIControlEventTouchUpInside];
//        [self.view addSubview:_referenceBtn];
//    }
    return _referenceBtn;
}
- (void)referenceBtnAction:(UIButton *)btn
{
    [IRFingerPrintVerify fingerPrintLocalAuthenticationFallBackTitle:@"Fail" localizedReason:@"fail" callBack:^(BOOL isSuccess, NSError * _Nullable error, NSString *referenceMsg) {
        [btn setTitle:referenceMsg forState:UIControlStateNormal];
    }];
}

@end

