//
//  IRCustomIconButton.h
//  IRPasscode
//
//  Created by Phil on 2019/11/14.
//  Copyright © 2019 Phil. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, IconContentMode) {
    IconContentModeCenter       = 0,
    IconContentModeLeft,
    IconContentModeRight
};

IB_DESIGNABLE
@interface IRCustomIconButton : UIButton

#if !TARGET_INTERFACE_BUILDER
@property (nonatomic, assign) IBInspectable UIViewContentMode imageViewContentMode;
#else
@property (nonatomic, assign) IBInspectable NSInteger imageViewContentMode;
#endif

@property (nonatomic, assign) IBInspectable NSInteger iconContentMode;
//@property (nonatomic, assign) IBInspectable XXX iconPosition;


@property (nonatomic, assign) IBInspectable CGSize iconSizePersent; // >0
@property (nonatomic, assign) IBInspectable CGFloat cornerRadius;
@property (nonatomic, assign) IBInspectable CGFloat borderWidth;
@property (nonatomic, strong) IBInspectable UIColor *borderColor;

@property (nonatomic, assign) IBInspectable CGFloat titleEdgeTop;
@property (nonatomic, assign) IBInspectable CGFloat titleEdgeLeft;
@property (nonatomic, assign) IBInspectable CGFloat titleEdgeBottom;
@property (nonatomic, assign) IBInspectable CGFloat titleEdgeRight;

@end

NS_ASSUME_NONNULL_END
