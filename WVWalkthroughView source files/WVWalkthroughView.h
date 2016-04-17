//
//  WVWalkthroughView.h
//  Walkthrough View Demo
//
//  Created by Praagya Joshi on 17/04/16.
//  Copyright © 2016 Praagya Joshi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WVWalkthroughView;

@protocol WVWalkthroughViewDelegate <NSObject>

@optional
- (void) didTapMaskedAreaForWalkthrough: (WVWalkthroughView *) walkView;
- (void) didTapEmptyAreaForWalkthrough: (WVWalkthroughView *) walkView;
- (void) didTapTooltipForWalkthrough: (WVWalkthroughView *) walkView;

@end

@interface WVWalkthroughView : UIView

#pragma mark - properties

/**
 * Delegate for receiving callbacks.
 */
@property (nonatomic, weak) id<WVWalkthroughViewDelegate> delegate;

/**
 * The text to be shown as a tooltip.
 */
@property (nonatomic, strong) NSString *text;

/**
 * Font of the icon label.
 */
@property (nonatomic, strong) UIFont *iconFont;

/**
 * The icon to be displayed in the tooltip. Visible
 * only if the `text` property is set.
 */
@property (nonatomic, strong) NSString *iconText;

/**
 * When set to YES, then it allows touches on the masked area
 * to pass through to the view below. Default is NO.
 */
@property (nonatomic, assign) BOOL passTouchThroughEmptyArea;

/**
 * When set to YES, then it shows an animated touch pointer
 * in the middle of the masked area. Default is NO.
 */
@property (nonatomic, assign) BOOL showTouchPointer;

/**
 * When set to YES, then the WalkthoughView hides itself
 * when an empty area (area other than the tooltip and the
 * masked area) is tapped. Default is NO.
 */
@property (nonatomic, assign) BOOL hideOnTappingEmptyArea;

/**
 * When set to YES, then the WalkthoughView hides itself
 * when the tooltip is tapped. Default is NO.
 */
@property (nonatomic, assign) BOOL hideOnTappingTooltip;

/**
 * When set to YES, and when passTouchThroughEmptyArea is NO
 * then the WalkthroughView hides itself on tapping the masked area.
 * Default is NO.
 */
@property (nonatomic, assign) BOOL hideOnTappingMaskedArea;

#pragma mark - methods

/**
 * Shows the WalkthroughView with a subtle animation. Use this to
 * show the WalkthoughView after adding it as a subview.
 */
- (void) show;

/**
 * Hides the WalkthroughView with a subtle animation and removes it from
 * it's superview after completing the animation. Use this to
 * hide the WalkthoughView after adding it as a subview.
 */
- (void) hide;

/**
 * Masks the specified CGRect with the specified radius. Which means that
 * the given CGRect will be cut out.
 */
- (void) addMaskWithRect: (CGRect) rect andCornerRadius: (CGFloat) radius;

@end

