# WVWalkthroughView

A simple utility written in Objective C to help developers walk a user through their app. It allows a message to be dispalyed, a particular part of the screen to be (optionally) highlighted and the touch in the highlighted area to be (optionally) passed through.

The first runs and walkthroughs, in my opinion, are one of the most important ways to make a user feel comfortable in a new app.

### Demo
You can see it in action here: [https://gfycat.com/DirectShamefulFlycatcher](https://gfycat.com/DirectShamefulFlycatcher).

Use it however you like - highlighting a particular element, with a touch pointer or covering the whole screen.

<img src="https://cloud.githubusercontent.com/assets/2060518/14589171/35ae10f8-04f9-11e6-8244-a7fd770f608c.png" width="30%"></img> <img src="https://cloud.githubusercontent.com/assets/2060518/14589178/4dd958c2-04f9-11e6-9e4c-803e8ef11047.gif" width="30%"></img> <img src="https://cloud.githubusercontent.com/assets/2060518/14589179/502cd4aa-04f9-11e6-8a95-df1a2ca842b4.png" width="30%"></img>

### Usage
It's ridiculously easy to use this view. Since it extends ```UIView```, just create a new instance of ```WVWalkthroughView``` and add it as a subview to any view. I recommend adding it to the window using:
````objective-c
[[UIApplication sharedApplication].keyWindow addSubview:_walkthrough];
````
There are various properties to play around with and they have been explained in ```WVWalkthroughView.h```.

### Demo
There is a demo project included to showcase a few of the options.

### License
`WVWalkthroughView` has been released under an [MIT License](http://opensource.org/licenses/MIT). I'll be extremely happy if you provide attribution and let me know if you use it in your app.