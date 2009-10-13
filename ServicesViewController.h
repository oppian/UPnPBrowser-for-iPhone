//
//  ServicesViewController.h
//  UPnPBrowser
//
//  Created by Neil Davis on 10/08/2009.
//  Copyright 2009 Oppian Systems Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UPnP.h"


@interface ServicesViewController : UITableViewController 
{
	CGUpnpDevice* device;
	NSArray* services;
}

@property(nonatomic, retain) CGUpnpDevice* device;
@property(nonatomic, retain) NSArray* services;

@end
