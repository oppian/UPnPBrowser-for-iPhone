//
//  RootViewController.h
//  UPnPBrowser
//
//  Created by Neil Davis on 10/08/2009.
//  Copyright Oppian Systems Ltd 2009. All rights reserved.
//

#import "UPnP.h"
#import "Reachability.h"

@class SplashViewController;

@interface RootViewController : UITableViewController 
{
	CGUpnpControlPoint* upnpCp;
	NSArray* devices;
	NetworkStatus nwStatus;
	IBOutlet UIBarButtonItem*	refreshButton;
	SplashViewController*	splashViewController;
}

@property(nonatomic, retain) CGUpnpControlPoint* upnpCp; 
@property(nonatomic, retain) NSArray* devices; // array of CGUpnpDevice
@property NetworkStatus nwStatus;
@property (nonatomic, retain) UIBarButtonItem*	refreshButton;
@property (nonatomic, retain) SplashViewController*	splashViewController;

- (IBAction) onRefreshButtonPressed:(id)button;

@end
