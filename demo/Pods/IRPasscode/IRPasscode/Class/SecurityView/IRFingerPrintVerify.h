//
//  IRFingerPrintVerify.h
//  IRPasscode
//
//  Created by Phil on 2019/11/14.
//  Copyright © 2019 Phil. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IRFingerPrintVerify.h"

NS_ASSUME_NONNULL_BEGIN

@interface IRFingerPrintVerify : NSObject
/**
 System fingerPrint check.

 @param fallBackTitle Title of fallback
 @param reasonTitle hint
 @param fingerBlock callback
    isSuccess is verify sucess or not
    error error message
    referenceMsg for reference message
 */
+ (void)fingerPrintLocalAuthenticationFallBackTitle:(NSString *)fallBackTitle localizedReason:(NSString *)reasonTitle callBack:(void(^)(BOOL isSuccess,NSError *_Nullable error,NSString *referenceMsg))fingerBlock;
@end


NS_ASSUME_NONNULL_END
