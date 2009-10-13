//
//  UPnPBrowserAppDelegate.m
//  UPnPBrowser
//
//  Created by Neil Davis on 10/08/2009.
//  Copyright Oppian Systems Ltd 2009. All rights reserved.
//

#import "UPnPBrowserAppDelegate.h"
#import "RootViewController.h"


@implementation UPnPBrowserAppDelegate

@synthesize window;
@synthesize navigationController;


#pragma mark -
#pragma mark Application lifecycle

- (void)applicationDidFinishLaunching:(UIApplication *)application {    
    
    // Override point for customization after app launch    
	
	[window addSubview:[navigationController view]];
    [window makeKeyAndVisible];
}


- (void)applicationWillTerminate:(UIApplication *)application 
{
	// Save data if appropriate
}


#pragma mark -
#pragma mark Memory management

- (void)dealloc {
	[navigationController release];
	[window release];
	[super dealloc];
}


@end

