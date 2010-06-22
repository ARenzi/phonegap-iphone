//
//  PhoneGapDelegate2.m
//  tmpPhonegap2
//
//  Created by Christian Stocker on 10.02.10.
//  Copyright 2010 Liip AG. All rights reserved.
//

#import "PhoneGapDelegateXib.h"
#import "PhoneGapViewController.h"


@implementation PhoneGapDelegateXib


/**
 * This is main kick off after the app inits, the views and Settings are setup here.
 */
- (void)applicationDidFinishLaunching:(UIApplication *)application
{	
	
	/*
	 * PhoneGap.plist
	 *
	 * This block of code navigates to the PhoneGap.plist in the Config Group and reads the XML into an Hash (Dictionary)
	 *
	 */
    NSDictionary *temp = [PhoneGapDelegate getBundlePlist:@"PhoneGap"];
    settings = [[NSDictionary alloc] initWithDictionary:temp];
    
#if __IPHONE_OS_VERSION_MIN_REQUIRED < 30000
    NSNumber *detectNumber         = [settings objectForKey:@"DetectPhoneNumber"];
#endif
    NSNumber *useLocation          = [settings objectForKey:@"UseLocation"];
    NSNumber *autoRotate           = [settings objectForKey:@"AutoRotate"];
    NSString *startOrientation     = [settings objectForKey:@"StartOrientation"];
    NSString *rotateOrientation    = [settings objectForKey:@"RotateOrientation"];
    NSString *topActivityIndicator = [settings objectForKey:@"TopActivityIndicator"];
	
	/*
	 * Fire up the GPS Service right away as it takes a moment for data to come back.
	 */
    if ([useLocation boolValue]) {
        [[self getCommandInstance:@"Location"] startLocation:nil withDict:nil];
    }
    
	webView.delegate = self;
    
	[window addSubview:viewController.view];
    
	/*
	 * webView
	 * This is where we define the inital instance of the browser (WebKit) and give it a starting url/file.
	 */
    NSURL *appURL        = [NSURL fileURLWithPath:[PhoneGapDelegate pathForResource:@"index.html"]];
    NSURLRequest *appReq = [NSURLRequest requestWithURL:appURL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:20.0];
	[webView loadRequest:appReq];
    
#if __IPHONE_OS_VERSION_MIN_REQUIRED < 30000
	webView.detectsPhoneNumbers = [detectNumber boolValue];
#endif
    
	/*
	 * imageView - is the Default loading screen, it stay up until the app and UIWebView (WebKit) has completly loaded.
	 * You can change this image by swapping out the Default.png file within the resource folder.
	 */
	UIImage* image = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Default" ofType:@"png"]];
	imageView = [[UIImageView alloc] initWithImage:image];
	[image release];
	
    imageView.tag = 1;
	[window addSubview:imageView];
	[imageView release];
	
    /*
     * autoRotate - If you want your phone to automatically rotate its display when the phone is rotated
     * Value should be BOOL (YES|NO)
     */
    [viewController setAutoRotate:[autoRotate boolValue]];
    
    /*
     * startOrientation - This option dictates what the starting orientation will be of the application 
     * Value should be one of: portrait, portraitUpsideDown, landscapeLeft, landscapeRight
     */
    orientationType = UIInterfaceOrientationPortrait;
    if ([startOrientation isEqualToString:@"portrait"]) {
        orientationType = UIInterfaceOrientationPortrait;
    } else if ([startOrientation isEqualToString:@"portraitUpsideDown"]) {
        orientationType = UIInterfaceOrientationPortraitUpsideDown;
    } else if ([startOrientation isEqualToString:@"landscapeLeft"]) {
        orientationType = UIInterfaceOrientationLandscapeLeft;
    } else if ([startOrientation isEqualToString:@"landscapeRight"]) {
        orientationType = UIInterfaceOrientationLandscapeRight;
    }
    [[UIApplication sharedApplication] setStatusBarOrientation:orientationType animated:NO];
    
    /*
     * rotateOrientation - This option is only enabled when AutoRotate is enabled.  If the phone is still rotated
     * when AutoRotate is disabled, this will control what orientations will be rotated to.  If you wish your app to
     * only use landscape or portrait orientations, change the value in PhoneGap.plist to indicate that.
     * Value should be one of: any, portrait, landscape
     */
    [viewController setRotateOrientation:rotateOrientation];
    
	/*
	 * The Activity View is the top spinning throbber in the status/battery bar. We init it with the default Grey Style.
	 *
	 *	 whiteLarge = UIActivityIndicatorViewStyleWhiteLarge
	 *	 white      = UIActivityIndicatorViewStyleWhite
	 *	 gray       = UIActivityIndicatorViewStyleGray
	 *
	 */
    UIActivityIndicatorViewStyle topActivityIndicatorStyle = UIActivityIndicatorViewStyleGray;
    if ([topActivityIndicator isEqualToString:@"whiteLarge"]) {
        topActivityIndicatorStyle = UIActivityIndicatorViewStyleWhiteLarge;
    } else if ([topActivityIndicator isEqualToString:@"white"]) {
        topActivityIndicatorStyle = UIActivityIndicatorViewStyleWhite;
    } else if ([topActivityIndicator isEqualToString:@"gray"]) {
        topActivityIndicatorStyle = UIActivityIndicatorViewStyleGray;
    }
    activityView = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:topActivityIndicatorStyle] retain];
    activityView.tag = 2;
    [window addSubview:activityView];
    [activityView startAnimating];
    
	[window makeKeyAndVisible];
}


@end
