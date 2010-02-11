//
//  AudioStream.m
//  phonegap-edge-test
//
//  Created by Christian Stocker on 06.02.10.
//  Copyright 2010 Liip AG. All rights reserved.
//

#import "AudioStream.h"
#import "AudioStreamer.h"
#import <MediaPlayer/MediaPlayer.h>
#import <CFNetwork/CFNetwork.h>


#ifndef __IPHONE_3_0
@synthesize webView;
#endif

@implementation AudioStream

-(PhoneGapCommand*) initWithWebView:(UIWebView*)theWebView
{
    self = (AudioStream*)[super initWithWebView:theWebView];
    /*if (self) 
	{
        tabBarItems = [[NSMutableDictionary alloc] initWithCapacity:5];
    }*/
    return self;
}


//
// destroyStreamer
//
// Removes the streamer, the UI update timer and the change notification
//
- (void)destroyStreamer
{
	if (streamer)
	{
		
	/*
	 [[NSNotificationCenter defaultCenter]
		 removeObserver:self
		 name:ASStatusChangedNotification
		 object:streamer];
	*/	
		 
		
		 /*
		 [progressUpdateTimer invalidate];
		 progressUpdateTimer = nil;
		 */
		[streamer stop];
		[streamer release];
		streamer = nil;
	}
}


//
// createStreamer
//
// Creates or recreates the AudioStreamer object.
//
- (void)createStreamer:(NSString*)urlin
{
	if (streamer)
	{
		return;
	}
	
	[self destroyStreamer];
	
	NSString *escapedValue =
	[(NSString *)CFURLCreateStringByAddingPercentEscapes(
														 nil,
														 (CFStringRef)urlin,
														 NULL,
														 NULL,
														 kCFStringEncodingUTF8)
	 autorelease];
	
	NSURL *url = [NSURL URLWithString:escapedValue];
	streamer = [[AudioStreamer alloc] initWithURL:url];
	streamer.delegate = self;
	/*	progressUpdateTimer =
	 [NSTimer
	 scheduledTimerWithTimeInterval:0.1
	 target:self
	 selector:@selector(updateProgress:)
	 userInfo:nil
	 repeats:YES];
	 */
/*
 [[NSNotificationCenter defaultCenter]
	 addObserver:self
	 selector:@selector(playbackStateChanged:)
	 name:ASStatusChangedNotification
	 object:streamer];
*/	
}

- (void)play:(NSArray*)arguments withDict:(NSDictionary*)options
{
	NSString  *url      = [arguments objectAtIndex:0];
	
	//NSUInteger argc = [arguments count];
	//if (argc > 1) metaCallback = [arguments objectAtIndex:1];
	
	
	[self createStreamer:url ];
	[streamer start];
}

- (void)stop:(NSArray*)arguments withDict:(NSDictionary*)options
{
	[streamer stop];
}

- (void)getMetaData:(NSArray*)arguments withDict:(NSDictionary*)options
{
	
		
	
}


- (void)metaDataUpdated:(NSString *)metaData 
{
	
	NSArray *listItems = [metaData componentsSeparatedByString:@";"];

	NSString *metadata;
	
	if ([listItems count] > 0)
		metadata = [listItems objectAtIndex:0];
	
	
	NSString * jsCallBack = [NSString stringWithFormat:@"window.plugins.AudioStream.setMetaData( %@ )",  metadata];
    NSLog(@"%@", jsCallBack);
    
    [webView stringByEvaluatingJavaScriptFromString:jsCallBack];
	
	
	NSLog(@"Foo: %@",metaData);
}




@end
