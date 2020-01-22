//
//  UIColor+Helper.h
//  IRPasscode
//
//  Created by Phil on 2019/11/15.
//  Copyright © 2019 Phil. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ColorDefine.h"

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (Helper)
+ (UIColor *)colorWithColorCodeString:(NSString *)colorString;
+ (UIColor *)colorWithARGB:(NSUInteger)color;
+ (UIColor *)colorWithRGB:(NSUInteger)color;
+ (UIColor *)colorWithRGBA:(NSUInteger)color;
+ (UIColor *)colorWithRGBWithString:(NSString *)colorString;
@end

NS_ASSUME_NONNULL_END
