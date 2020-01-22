//
//  IRSecurityPinButton.m
//  IRPasscode
//
//  Created by Phil on 2019/11/14.
//  Copyright © 2019 Phil. All rights reserved.
//

#import "IRSecurityPinButton.h"
#import "UIColor+Helper.h"

@implementation IRSecurityPinButton

- (instancetype)init {
    if (self = [super init]) {
        [self initButton];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self initButton];
    }
    return self;
}

- (void)initButton {
//    [self setContentEdgeInsets:UIEdgeInsetsMake(8, 4, 8, 4)];
    [self setBackgroundImage:[self imageFromColor:[UIColor colorWithColorCodeString:@"FF18937B"]] forState:UIControlStateHighlighted];
}

- (UIImage *)imageFromColor:(UIColor *)color {
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end

