//
//  IRCustomIconButton.m
//  IRPasscode
//
//  Created by Phil on 2019/11/14.
//  Copyright © 2019 Phil. All rights reserved.
//

#import "IRCustomIconButton.h"

@implementation IRCustomIconButton

@synthesize iconSizePersent = _iconSizePersent;
@synthesize iconContentMode = _iconContentMode;

- (instancetype)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]){
        [self invalidateIntrinsicContentSize];
        [self setNeedsLayout];
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if(self = [super initWithCoder:aDecoder]){
        [self invalidateIntrinsicContentSize];
        [self setNeedsLayout];
    }
    
    return self;
}

- (UIViewContentMode)imageViewContentMode {
    return self.imageView.contentMode;
}

- (void)setImageViewContentMode:(UIViewContentMode)imageViewContentMode {
    self.imageView.contentMode = imageViewContentMode;
    
    [self.imageView invalidateIntrinsicContentSize];
    [self.imageView setNeedsLayout];
    [self invalidateIntrinsicContentSize];
    [self setNeedsLayout];
}

- (NSInteger)iconContentMode {
    return _iconContentMode;
}

- (void)setIconContentMode:(NSInteger)iconContentMode {
    _iconContentMode = iconContentMode;
    
    [self.imageView invalidateIntrinsicContentSize];
    [self.imageView setNeedsLayout];
    [self invalidateIntrinsicContentSize];
    [self setNeedsLayout];
}

- (CGSize)iconSizePersent {
    return _iconSizePersent;
}

- (void)setIconSizePersent:(CGSize)iconSizePersent {
    _iconSizePersent = iconSizePersent;
    
    if(_iconSizePersent.width < 0){
        _iconSizePersent.width = 0;
    }
    if(_iconSizePersent.height < 0){
        _iconSizePersent.height = 0;
    }
    
    [self invalidateIntrinsicContentSize];
    [self setNeedsLayout];
}

- (void)setTitleEdgeTop:(CGFloat)titleEdgeTop {
    _titleEdgeTop = titleEdgeTop;
    UIEdgeInsets newEdge = self.titleEdgeInsets;
    newEdge.top = titleEdgeTop;
    self.titleEdgeInsets = newEdge;
}

- (void)setTitleEdgeLeft:(CGFloat)titleEdgeLeft {
    _titleEdgeLeft = titleEdgeLeft;
    UIEdgeInsets newEdge = self.titleEdgeInsets;
    newEdge.left = titleEdgeLeft;
    self.titleEdgeInsets = newEdge;
}

- (void)setTitleEdgeBottom:(CGFloat)titleEdgeBottom {
    _titleEdgeBottom = titleEdgeBottom;
    UIEdgeInsets newEdge = self.titleEdgeInsets;
    newEdge.bottom = titleEdgeBottom;
    self.titleEdgeInsets = newEdge;
}

- (void)setTitleEdgeRight:(CGFloat)titleEdgeRight {
    _titleEdgeRight = titleEdgeRight;
    UIEdgeInsets newEdge = self.titleEdgeInsets;
    newEdge.right = titleEdgeRight;
    self.titleEdgeInsets = newEdge;
}

- (CGFloat)cornerRadius {
    return self.layer.cornerRadius;
}

- (void)setCornerRadius:(CGFloat)cornerRadius {
    self.layer.cornerRadius = cornerRadius;
}

- (CGFloat)borderWidth {
    return self.layer.borderWidth;
}

- (void)setBorderWidth:(CGFloat)borderWidth {
    self.layer.borderWidth = borderWidth;
}

- (UIColor *)borderColor {
    return [UIColor colorWithCGColor:self.layer.borderColor];
}

- (void)setBorderColor:(UIColor *)borderColor {
    self.layer.borderColor = [borderColor CGColor];
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect {
    contentRect = [super imageRectForContentRect:contentRect];
    
    CGSize imageSize = contentRect.size;
    if(_iconSizePersent.width == 0){
        imageSize.width = 0;
    }else{
        imageSize.width = imageSize.width * _iconSizePersent.width;
    }
    
    if(_iconSizePersent.height == 0){
        imageSize.height = 0;
    }else{
        imageSize.height = imageSize.height * _iconSizePersent.height;
    }
    
    CGRect tmp =contentRect;
    tmp.size = imageSize;

    CGPoint tmpPoint = contentRect.origin;
    switch (_iconContentMode) {
        case IconContentModeCenter:
            tmpPoint.x = tmpPoint.x + (contentRect.size.width - imageSize.width) / 2;
            tmpPoint.y = tmpPoint.y + (contentRect.size.height - imageSize.height) / 2;
            break;
        case IconContentModeLeft:
            tmpPoint.y = tmpPoint.y + (contentRect.size.height - imageSize.height) / 2;
            break;
        case IconContentModeRight:
            tmpPoint.x = tmpPoint.x + (contentRect.size.width - imageSize.width);
            tmpPoint.y = tmpPoint.y + (contentRect.size.height - imageSize.height) / 2;
            break;
    }
    
    tmp.origin = tmpPoint;
    
    return tmp;
}

@end

