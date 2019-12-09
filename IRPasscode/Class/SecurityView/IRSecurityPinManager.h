//
//  IRSecurityPinManager.h
//  IRPasscode
//
//  Created by Phil on 2019/11/14.
//  Copyright © 2019 Phil. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, IRSecurityResultType){
    Created,
    Verified,
    Changed
};

typedef void (^ResultBlock)(IRSecurityResultType type);

@interface IRSecurityPinManager : NSObject

@property (nonatomic, strong, readonly) NSString *pinCode;

- (instancetype)init UNAVAILABLE_ATTRIBUTE;
+ (instancetype)new UNAVAILABLE_ATTRIBUTE;

+ (instancetype)sharedInstance;

- (void)removePinCode;

- (void)presentSecurityPinViewControllerForChangePasscodeWithAnimated: (BOOL)flag completion:(void (^ __nullable)(void))completion result:(ResultBlock _Nullable )result;
//- (void)presentSecurityPinViewControllerWithAnimated: (BOOL)flag completion:(void (^ __nullable)(void))completion;
- (void)presentSecurityPinViewControllerForCreateWithAnimated: (BOOL)flag completion:(void (^ __nullable)(void))completion result:(ResultBlock _Nullable )result;
- (void)presentSecurityPinViewControllerForRemoveWithAnimated: (BOOL)flag completion:(void (^ __nullable)(void))completion result:(ResultBlock _Nullable )result;
- (void)presentSecurityPinViewControllerForUnlockWithAnimated: (BOOL)flag completion:(void (^ __nullable)(void))completion result:(ResultBlock _Nullable )result;
@end


NS_ASSUME_NONNULL_END
