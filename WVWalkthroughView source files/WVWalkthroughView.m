//
//  WVWalkthroughView.m
//  Walkthrough View Demo
//
//  Created by Praagya Joshi on 17/04/16.
//  Copyright © 2016 Praagya Joshi. All rights reserved.
//

#import "WVWalkthroughView.h"

#define getHeight(v)            v.frame.size.height
#define getWidth(v)             v.frame.size.width
#define getOriginX(v)           v.frame.origin.x
#define getOriginY(v)           v.frame.origin.y
#define afterView(v)            v.frame.origin.x + v.frame.size.width

@implementation WVWalkthroughView {
    
    UIView *tooltipView;
    UIView *tooltipContainerView;
    UILabel *tooltipLabel;
    UILabel *tooltipIconLabel;
    CGRect cutoutRect;
    
    UIView *touchPointer;
    UIView *touchPointerBackgroundView;
    CGFloat touchPointerSize;
    
    CGPoint lastTouchLocation;
    
    CGFloat backgroundViewAlpha;
    
    BOOL animateTooltipFromTop;
    BOOL animationShouldStop;
}

#pragma mark - init methods

- (id) init {
    
    if (self = [super init]) {
        [self initialize];
    }
    return self;
}

- (id) initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        [self initialize];
    }
    return self;
}

- (void) setFrame:(CGRect)frame {
    
    [super setFrame:frame];
    [self refreshFramesOfTooltip];
}

- (void) initialize {
    
    _passTouchThroughEmptyArea = NO;
    _showTouchPointer = NO;
    _hideOnTappingEmptyArea = NO;
    _hideOnTappingTooltip = NO;
    animationShouldStop = NO;
    
    backgroundViewAlpha = 0.8f;
    
    lastTouchLocation = CGPointZero;
    
    [self setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:backgroundViewAlpha]];
    [self setAlpha:0.0f];
    
}

#pragma mark - appearence methods

- (void) show {
    
    [UIView animateWithDuration:0.3f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         [self setAlpha:1.0f];
                     }
                     completion:nil];
    
    CGRect originalFrame = tooltipContainerView.frame;
    CGRect modifiedFrame = tooltipContainerView.frame;
    modifiedFrame.origin.y = animateTooltipFromTop ? modifiedFrame.origin.y - 25.0f : modifiedFrame.origin.y + 25.0f;
    [tooltipContainerView setFrame:modifiedFrame];
    
    [UIView animateWithDuration:0.3f
                          delay:0.1f
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         
                         [tooltipContainerView setFrame:originalFrame];
                         [tooltipContainerView setAlpha:1.0f];
                     }
                     completion:^(BOOL finished) {
                         if (_showTouchPointer) {
                             [self startAnimatingTouchPointer];
                         }
                     }];
}

- (void) hide {
    
    [UIView animateWithDuration:0.3f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         [self setAlpha:0.0f];
                     }
                     completion:^(BOOL finished) {
                         animationShouldStop = YES;
                         [touchPointer.layer removeAllAnimations];
                     }];
    
    CGRect originalFrame = tooltipContainerView.frame;
    CGRect modifiedFrame = tooltipContainerView.frame;
    modifiedFrame.origin.y = animateTooltipFromTop ? modifiedFrame.origin.y - 25.0f : modifiedFrame.origin.y + 25.0f;
    [tooltipContainerView setFrame:originalFrame];
    
    [UIView animateWithDuration:0.3f
                          delay:0.1f
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         
                         [tooltipContainerView setFrame:modifiedFrame];
                         [tooltipContainerView setAlpha:0.0f];
                     }
                     completion:^(BOOL finished) {
                         [self removeFromSuperview];
                     }];
}

- (void) startAnimatingTouchPointer {
    
    [self touchPointerAppearAnimationWithDelay:0.0f];
}

- (void) touchPointerAppearAnimationWithDelay: (CGFloat) delay {
    
    [UIView animateWithDuration:0.6f
                          delay:delay
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         [touchPointer setAlpha:1.0f];
                     }
                     completion:^(BOOL finished) {
                         if (!animationShouldStop) {
                             [self touchPointerShrinkAnimation];
                         }
                     }];
}

- (void) touchPointerShrinkAnimation {
    
    [UIView animateWithDuration:0.4f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         [touchPointer setTransform:CGAffineTransformMakeScale(0.8f, 0.8f)];
                     }
                     completion:^(BOOL finished) {
                         if (!animationShouldStop) {
                             [self touchPointerDisappearAnimationAndShowAgain:YES];
                         }
                     }];
}

- (void) touchPointerDisappearAnimationAndShowAgain: (BOOL) showAgain {
    
    [UIView animateWithDuration:0.8f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         [touchPointer setAlpha:0.0f];
                         [touchPointer setTransform:CGAffineTransformMakeScale(1.0f, 1.0f)];
                     }
                     completion:^(BOOL finished) {
                         if (showAgain && !animationShouldStop) {
                             [self touchPointerAppearAnimationWithDelay:0.1f];
                         }
                     }];
}

#pragma mark - custom setters

- (void) setText:(NSString *)text {
    
    _text = text;
    
    if (!tooltipView && _text.length) {
        [self createTooltipView];
    }
    
    if (tooltipLabel) {
        [tooltipLabel setText:_text];
        [self refreshFramesOfTooltip];
    }
}

- (void) setIconText:(NSString *)iconText {
    
    _iconText = iconText;
    
    if (!tooltipView && _iconText.length) {
        [self createTooltipView];
    }
    
    if (tooltipIconLabel) {
        [tooltipIconLabel setText:_iconText];
    }
}

- (void) setIconFont:(UIFont *)iconFont {
    
    if (!tooltipView) {
        [self createTooltipView];
    }
    
    if (tooltipIconLabel) {
        [tooltipIconLabel setFont:iconFont];
    }
}

#pragma mark - subview creation method

- (void) createTouchPointer {
    
    if (!touchPointer) {
        
        touchPointer = [[UIView alloc] initWithFrame:CGRectZero];
        [touchPointer setAlpha:0.0f];
        [touchPointer.layer setShadowColor:[[UIColor blackColor] CGColor]];
        [touchPointer.layer setShadowOffset:CGSizeMake(0, 0)];
        [touchPointer.layer setShadowOpacity:0.8f];
        [touchPointer.layer setShadowRadius:2.0f];
        
        touchPointerBackgroundView = [[UIView alloc] initWithFrame:CGRectZero];
        [touchPointerBackgroundView setBackgroundColor:[UIColor whiteColor]];
        [touchPointerBackgroundView.layer setMasksToBounds:YES];
        
        [touchPointer addSubview:touchPointerBackgroundView];
    }
}

- (void) resizeTouchPointer {
    
    if (!touchPointer) {
        [self createTouchPointer];
    }
    
    if (cutoutRect.size.width > 45.0f &&
        cutoutRect.size.height > 45.0f) {
        
        touchPointerSize = 40.0f;
        [touchPointer setFrame:CGRectMake(0, 0, touchPointerSize, touchPointerSize)];
    } else {
        
        touchPointerSize = MIN(cutoutRect.size.height - 5.0f, cutoutRect.size.width - 5.0f);
        [touchPointer setFrame:CGRectMake(0, 0, touchPointerSize, touchPointerSize)];
    }
    
    CGFloat centerX = cutoutRect.origin.x + cutoutRect.size.width/2.0f;
    CGFloat centerY = cutoutRect.origin.y + cutoutRect.size.height/2.0f;
    [touchPointer setCenter:CGPointMake(centerX, centerY)];
    
    [touchPointerBackgroundView setFrame:touchPointer.bounds];
    [touchPointerBackgroundView.layer setCornerRadius:getHeight(touchPointerBackgroundView)/2.0f];
    
    [self addSubview:touchPointer];
}

- (void) createTooltipView {
    
    tooltipLabel = [[UILabel alloc] init];
    [tooltipLabel setFont:[UIFont systemFontOfSize:17]];
    [tooltipLabel setTextAlignment:NSTextAlignmentLeft];
    [tooltipLabel setLineBreakMode:NSLineBreakByWordWrapping];
    [tooltipLabel setBackgroundColor:[UIColor whiteColor]];
    [tooltipLabel setNumberOfLines:0];
    
    tooltipIconLabel = [[UILabel alloc] init];
    [tooltipIconLabel setTextColor:[UIColor colorWithRed:39.0f/255.0f green:174.0f/255.0f blue:96.0f/255.0f alpha:1.0f]];
    
    tooltipView = [[UIView alloc] init];
    [tooltipView setBackgroundColor:[UIColor whiteColor]];
    [tooltipView.layer setMasksToBounds:YES];
    [tooltipView.layer setCornerRadius:3.0f];
    
    tooltipContainerView = [[UIView alloc] init];
    [tooltipContainerView.layer setShadowColor:[[UIColor blackColor] CGColor]];
    [tooltipContainerView.layer setShadowOffset:CGSizeMake(0, 2.5f)];
    [tooltipContainerView.layer setShadowOpacity:0.5f];
    [tooltipContainerView.layer setShadowRadius:3.0f];
    
    [tooltipView addSubview:tooltipLabel];
    [tooltipView addSubview:tooltipIconLabel];
    [tooltipContainerView addSubview:tooltipView];
    
    [tooltipContainerView setAlpha:0.0f];
    
    [self addSubview:tooltipContainerView];
}

- (void) refreshFramesOfTooltip {
    
    if (tooltipLabel && tooltipView) {
        
        CGFloat iconLabelWidth = (tooltipIconLabel.text.length) ? 18.0f : 0.0f;
        CGFloat iconLabelHeight = (tooltipIconLabel.text.length) ? 20.0f : 0.0f;
        CGFloat iconOriginX = (tooltipIconLabel.text.length) ? 15.0f : 0.0f;
        CGFloat iconOriginY = (tooltipIconLabel.text.length) ? 15.0f : 0.0f;
        
        [tooltipIconLabel setFrame:CGRectMake(iconOriginX, iconOriginY, iconLabelWidth, iconLabelHeight)];
        
        CGRect requiredFrame = [tooltipLabel.text boundingRectWithSize:CGSizeMake(getWidth(self) - iconLabelWidth - getOriginX(tooltipIconLabel) - (iconLabelWidth ? 10.0f : 15.0f) - 3 * 15.0f, getHeight(self) - 4 * 15.0f)
                                                               options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                                            attributes:@{NSFontAttributeName : tooltipLabel.font}
                                                               context:nil];
        
        requiredFrame.size.height = MAX(iconLabelHeight, requiredFrame.size.height);
        requiredFrame.origin.y = 15.0f;
        requiredFrame.origin.x = afterView(tooltipIconLabel) + (iconLabelWidth ? 10.0f : 15.0f);
        
        requiredFrame.size.height = ceil(requiredFrame.size.height);
        requiredFrame.size.width = ceil(requiredFrame.size.width);
        
        [tooltipLabel setFrame:requiredFrame];
        
        if (iconLabelWidth) {
            requiredFrame.size.width += 2 * 15.0f + 10.0f + iconLabelWidth;
        } else {
            requiredFrame.size.width += 2 * 15.0f;
        }
        requiredFrame.size.height += 2 * 15.0f;
        
        requiredFrame.origin.x = 0;
        requiredFrame.origin.y = 0;
        [tooltipView setFrame:requiredFrame];
        
        //if a cutout has been specified
        if (!CGRectIsEmpty(cutoutRect)) {
            
            //get the space available
            //below the cutout part
            CGFloat heightAvailable = getHeight(self) - cutoutRect.size.height - cutoutRect.origin.y;
            
            //if space is available below
            //is sufficient
            if (heightAvailable > (2 * 15.0f + requiredFrame.size.height)) {
                
                requiredFrame.origin.y = cutoutRect.origin.y + cutoutRect.size.height + 15.0f;
                [tooltipContainerView setFrame:requiredFrame];
                [tooltipContainerView setCenter:CGPointMake(getWidth(self)/2.0f, tooltipContainerView.center.y)];
                animateTooltipFromTop = NO;
            }
            
            //if the space is not sufficient
            //then place the tooltip above the cutout
            else {
                
                requiredFrame.origin.y = cutoutRect.origin.y - requiredFrame.size.height - 15.0f;
                [tooltipContainerView setFrame:requiredFrame];
                [tooltipContainerView setCenter:CGPointMake(getWidth(self)/2.0f, tooltipContainerView.center.y)];
                animateTooltipFromTop = YES;
            }
        }
        
        //if a cutout rect has not been specified
        //then place the tooltip in the center
        //of the view
        else {
            
            [tooltipContainerView setFrame:requiredFrame];
            [tooltipContainerView setCenter:CGPointMake(getWidth(self)/2.0f, getHeight(self)/2.0f)];
            animateTooltipFromTop = NO;
        }
        
        [self bringSubviewToFront:tooltipContainerView];
    }
}

#pragma mark - masking methods

- (void) addMaskWithRect: (CGRect) rect andCornerRadius: (CGFloat) radius {
    
    [self setBackgroundColor:[UIColor clearColor]];
    cutoutRect = rect;
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height) cornerRadius:0];
    UIBezierPath *cutoutPath = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:radius];
    [path appendPath:cutoutPath];
    [path setUsesEvenOddFillRule:YES];
    
    CAShapeLayer *fillLayer = [CAShapeLayer layer];
    fillLayer.path = path.CGPath;
    fillLayer.fillRule = kCAFillRuleEvenOdd;
    fillLayer.fillColor = [[UIColor blackColor] colorWithAlphaComponent:backgroundViewAlpha].CGColor;
    [self.layer addSublayer:fillLayer];
    
    [self refreshFramesOfTooltip];
    [self resizeTouchPointer];
}

#pragma mark - touch related methods

- (BOOL) pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    
    //If the masked area was tapped
    if (CGRectContainsPoint(cutoutRect, point)) {
        
        if (![self isPointSameAsPreviousPoint:point]) {
            if ([self.delegate respondsToSelector:@selector(didTapMaskedAreaForWalkthrough:)]) {
                [self.delegate didTapMaskedAreaForWalkthrough:self];
            }
        }
        
        if (_passTouchThroughEmptyArea) {
            return NO;
        } else {
            
            if (_hideOnTappingMaskedArea) {
                [self hide];
            }
            
            return YES;
        }
    }
    
    //If any part of the WalkthroughView is tapped
    //other than the masked area
    else {
        
        for (UIView* subview in self.subviews ) {
            if ([subview hitTest:[self convertPoint:point toView:subview] withEvent:event] != nil && subview == tooltipContainerView) {
                
                if (![self isPointSameAsPreviousPoint:point]) {
                    if ([self.delegate respondsToSelector:@selector(didTapTooltipForWalkthrough:)]) {
                        [self.delegate didTapTooltipForWalkthrough:self];
                    }
                }
                
                if (_hideOnTappingTooltip) {
                    [self hide];
                }
                
                return YES;
            }
        }
        
        if (![self isPointSameAsPreviousPoint:point]) {
            if ([self.delegate respondsToSelector:@selector(didTapEmptyAreaForWalkthrough:)]) {
                [self.delegate didTapEmptyAreaForWalkthrough:self];
            }
        }
        
        if (_hideOnTappingEmptyArea) {
            [self hide];
        }
        
        return YES;
    }
}

- (BOOL) isPointSameAsPreviousPoint: (CGPoint) point {
    
    if (lastTouchLocation.x == point.x &&
        lastTouchLocation.y == point.y) {
        
        return YES;
    } else {
        
        lastTouchLocation = point;
        return NO;
    }
}

@end
