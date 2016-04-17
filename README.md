# WVWalkthroughView

A simple utility written in Objective C to help developers walk a user through their app. It allows a particular part of the screen be highlighted and the touch in the highlighted area to be optionally passed through.

The first runs and walkthroughs, in my opinion, are one of the key most important ways to make a user feel comfortable with a new app.

### Usage
It's ridiculously easy to use this view. Since it extends ```UIView```, just create a new instance of ```WVWalkthroughView``` and add it as a subview to any view. I recommend adding it to the window using:
````objective-c
[[UIApplication sharedApplication].keyWindow addSubview:_walkthrough];
````
There are various properties to play around with and they have been explained in ```WVWalkthroughView.h```.

### Demo
There is a demo project included to showcase a few of the options.

### License
`WVWalkthroughView` has been released under an [MIT License](http://opensource.org/licenses/MIT). I'll be extremely happy if you provice attribution and let me know if you use it in your app.