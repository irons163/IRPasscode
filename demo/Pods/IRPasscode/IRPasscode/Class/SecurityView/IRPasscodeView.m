//
//  IRPasscodeView.m
//  IRPasscode
//
//  Created by Phil on 2019/11/14.
//  Copyright © 2019 Phil. All rights reserved.
//

#import "IRPasscodeView.h"
#import "UIImage+Bundle.h"

@interface IRPasscodeView () {
    NSArray *_pinViewsArray;
    UITextField *_fakeTextField;
}
@property (nonatomic, readonly, getter = isInitialized) BOOL initialized;
@end

@implementation IRPasscodeView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (id)init {
    self = [super init];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    if (!self.isInitialized) {
        //You can freely use background color in XIB's
        self.backgroundColor = [UIColor clearColor];
        
        _normalPinImage = [UIImage imageNamedForCurrentBundle:@"pinViewUnSelected"];
        _selectedPinImage = [UIImage imageNamedForCurrentBundle:@"pinViewSelected"];
        
        //Fake text field
        _fakeTextField = [[UITextField alloc] initWithFrame:CGRectZero];
        _fakeTextField.keyboardType = UIKeyboardTypeNumberPad;
        [_fakeTextField addTarget:self action:@selector(textFieldTextChanged:)
                 forControlEvents:UIControlEventEditingChanged];
        [self addSubview:_fakeTextField];
    
        //Build pins
        [self buildPins];
        
        //Tap gesture
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                     action:@selector(tapGestureOccured:)];
        [self addGestureRecognizer:tapGesture];
        
        _initialized = YES;
    }
}

#pragma mark - Build View
- (void)buildPins {
    //Remove old pins
    [_pinViewsArray makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    CGFloat width = self.bounds.size.width;
    CGFloat itemWidth = floor(width / (CGFloat)IRDefinedPinsCount);
    
    //Add pincodes
    NSMutableArray *pinCodesContainer = [NSMutableArray new];
    for (NSInteger i = 0;i < IRDefinedPinsCount; i++) {
        UIImageView *pinImageView = [[UIImageView alloc] initWithFrame:CGRectMake(i * itemWidth,
                                                                                  0.0f,
                                                                                  itemWidth,
                                                                                  self.bounds.size.height)];
        pinImageView.image = _normalPinImage;
        pinImageView.highlightedImage = _selectedPinImage;
        pinImageView.contentMode = UIViewContentModeScaleAspectFit;
        pinImageView.autoresizingMask =
        UIViewAutoresizingFlexibleWidth
        | UIViewAutoresizingFlexibleHeight
        | UIViewAutoresizingFlexibleLeftMargin
        | UIViewAutoresizingFlexibleRightMargin;
        
        [self addSubview:pinImageView];
        
        [pinCodesContainer addObject:pinImageView];
    }
    _pinViewsArray = [pinCodesContainer copy];
}

#pragma mark - Images
- (void)setNormalPinImage:(UIImage *)normalPinImage {
    _normalPinImage = normalPinImage;
    
    //Set normal image
    [_pinViewsArray makeObjectsPerformSelector:@selector(setImage:)
                                    withObject:normalPinImage];
}

- (void)setSelectedPinImage:(UIImage *)selectedPinImage {
    _selectedPinImage = selectedPinImage;
    
    //Set selected image
    [_pinViewsArray makeObjectsPerformSelector:@selector(setHighlightedImage:)
                                    withObject:selectedPinImage];
}

#pragma mark - UITextField
- (void)textFieldTextChanged:(UITextField *)textField {
    //Trimmed text
    textField.text = [self trimmedStringWithMaxLenght:textField.text];
    
    _pinCode = textField.text;
    
    //Colorize pins
    [self colorizePins];
    
    //Notify delegate if needed
    [self checkForEnteredPin];
}

- (void)setPinCode:(nullable NSString *)pinCode {
    //Trimmed text
    NSString *enteredCode = [self trimmedStringWithMaxLenght:pinCode];
    
    _pinCode = enteredCode;
    _fakeTextField.text = enteredCode;
    
    //Colorize pins
    [self colorizePins];
    
    //Notify delegate if needed
    [self checkForEnteredPin];
}

#pragma mark - ColorizeViews
- (void)colorizePins {
    NSInteger pinsEntered = self.pinCode.length;
    NSInteger itemsCount = _pinViewsArray.count;
    for (NSInteger i = 0; i < itemsCount; i++) {
        UIImageView *pinImageView = _pinViewsArray[i];
        pinImageView.highlighted = i < pinsEntered;
    }
}

#pragma mark - Delegate
- (void)checkForEnteredPin {
    if (self.pinCode.length == IRDefinedPinsCount) {
        if ([self.delegate respondsToSelector:@selector(pinCodeView:didEnterPin:)]) {
            [self.delegate pinCodeView:self didEnterPin:self.pinCode];
        }
    }
}

#pragma mark - Gestures
- (void)tapGestureOccured:(UITapGestureRecognizer *)tapGesture {
    [self becomeFirstResponder];
}

#pragma mark - Helpers
- (NSString *)trimmedStringWithMaxLenght:(NSString *)sourceString {
    if (sourceString.length > IRDefinedPinsCount) {
        sourceString = [sourceString substringToIndex:IRDefinedPinsCount];
    }
    return sourceString;
}

@end
