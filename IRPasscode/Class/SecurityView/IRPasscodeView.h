//
//  IRPasscodeView.h
//  IRPasscode
//
//  Created by Phil on 2019/11/14.
//  Copyright © 2019 Phil. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#define IRDefinedPinsCount 4

@class IRPasscodeView;

@protocol IRPasscodeViewDelegate <NSObject>

@optional
- (void)pinCodeView:(IRPasscodeView *)view didEnterPin:(NSString *)pinCode;

@end

@interface IRPasscodeView : UIView

@property (nonatomic, weak) id <IRPasscodeViewDelegate> delegate;

@property (nonatomic, strong, nullable) NSString *pinCode;
@property (nonatomic, strong) UIImage *normalPinImage;
@property (nonatomic, strong) UIImage *selectedPinImage;

@end

NS_ASSUME_NONNULL_END
