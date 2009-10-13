//
//  DeviceViewController.h
//  UPnPBrowser
//
//  Created by Neil Davis on 10/08/2009.
//  Copyright 2009 Oppian Systems Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UPnP.h"
#import <MessageUI/MessageUI.h>


@interface DeviceViewController : UITableViewController <MFMailComposeViewControllerDelegate>
{
	CGUpnpDevice* device;
}

@property(nonatomic, retain) CGUpnpDevice* device;

@end
