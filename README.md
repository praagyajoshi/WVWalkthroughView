# WVWalkthroughView

A simple utility written in Objective C to help developers walk a user through their app. It allows a message to be displayed, a particular part of the screen to be (optionally) highlighted and the touch in the highlighted area to be (optionally) passed through.

The first runs and walkthroughs, in my opinion, are one of the most important ways to make a user feel comfortable in a new app.

## Demo

<img src="https://cloud.githubusercontent.com/assets/2060518/14589171/35ae10f8-04f9-11e6-8244-a7fd770f608c.png" width="30%"></img> <img src="https://cloud.githubusercontent.com/assets/2060518/14589178/4dd958c2-04f9-11e6-9e4c-803e8ef11047.gif" width="30%"></img> <img src="https://cloud.githubusercontent.com/assets/2060518/14589179/502cd4aa-04f9-11e6-8a95-df1a2ca842b4.png" width="30%"></img>

Use it however you like - highlighting a particular element, with a touch pointer or covering the whole screen.

You can see it in action here: [https://gfycat.com/DirectShamefulFlycatcher](https://gfycat.com/DirectShamefulFlycatcher).
There is also a demo project included to showcase a few of the options.

## Installation

Just drag and drop `WVWalkthroughView.h` and `WVWalkthroughView.m` files into your iOS project and you'll be ready to go!

## Usage

It's ridiculously easy to use this view. Since it extends ```UIView```, just create a new instance of ```WVWalkthroughView``` and add it as a subview to any view.

1. Import the WVWalkthroughView

````objective-c
#import "WVWalkthroughView.h"
````

2. Create an instance of WVWalkthroughView and set it's options and delegate

````objective-c
_walkthrough = [[WVWalkthroughView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
[_walkthrough setHideOnTappingEmptyArea:YES];
[_walkthrough setHideOnTappingTooltip:YES];
[_walkthrough setDelegate:self];
````

3. Conform your ViewController to the WVWalkthroughViewDelegate protocol and implement the methods as required

````objective-c
@interface ViewController () <WVWalkthroughViewDelegate, UITableViewDataSource, UITableViewDelegate>

...

- (void) didTapEmptyAreaForWalkthrough:(WVWalkthroughView *)walkView {
  //...
}

- (void) didTapMaskedAreaForWalkthrough:(WVWalkthroughView *)walkView {
  //...
}

- (void) didTapTooltipForWalkthrough:(WVWalkthroughView *)walkView {
  //...
}
````

4. Add it to the view of your app. I recommend adding it to the window using:

````objective-c
[[UIApplication sharedApplication].keyWindow addSubview:_walkthrough];
````

5. Whenever you want to show the overlay, use the method `show`

````objective-c
[_walkthrough show];
````

## Properties

There are various properties to play around with and they have also been explained in ```WVWalkthroughView.h```.

````objective-c
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
````

## Methods

The following methods are supported as of now:
````objective-c
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
````

## Delegates

The following delegates have been implemented:
````objective-c
@optional
- (void) didTapMaskedAreaForWalkthrough: (WVWalkthroughView *) walkView;
- (void) didTapEmptyAreaForWalkthrough: (WVWalkthroughView *) walkView;
- (void) didTapTooltipForWalkthrough: (WVWalkthroughView *) walkView;
````

## License

`WVWalkthroughView` has been released under an [MIT License](http://opensource.org/licenses/MIT).
I'll be extremely happy if you let me know when you use it in your app.

---

[www.praagya.com](http://www.praagya.com)