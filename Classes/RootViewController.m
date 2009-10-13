//
//  RootViewController.m
//  UPnPBrowser
//
//  Created by Neil Davis on 10/08/2009.
//  Copyright Oppian Systems Ltd 2009. All rights reserved.
//

#import "RootViewController.h"
#import "UPnPBrowserAppDelegate.h"
#import "DeviceViewController.h"
#import "SplashViewController.h"

@interface RootViewController()
- (void) upnpDiscoverDevices;
- (void) doUpnpDiscovery:(id)obj;
- (void) onDiscoveredUpnpDevices:(NSArray*)devs;
- (void) startReachabilityNotifier;
- (void) reachabilityChanged:(NSNotification *)note;
@end


#define kUpnpDeviceTypeInternetGatewayPrefix @"urn:schemas-upnp-org:device:InternetGatewayDevice"
#define kUpnpDeviceTypeMediaRendererPrefix @"urn:schemas-upnp-org:device:MediaRenderer"
#define kUpnpDeviceTypeMediaServerPrefix @"urn:schemas-upnp-org:device:MediaServer"
#define kUpnpDeviceTypeWiNASPrefix @"urn:schemas-upnp-org:device:WiNAS"
@implementation RootViewController

@synthesize upnpCp;
@synthesize devices;
@synthesize nwStatus;
@synthesize refreshButton;
@synthesize splashViewController;


#pragma mark New methods
#pragma mark - 

- (IBAction) onRefreshButtonPressed:(id)button
{
	// clear out the existing table items
	self.devices = nil;
	[self.tableView reloadData];
	[self upnpDiscoverDevices];
}

- (void) upnpDiscoverDevices
{
	UIApplication* app = [UIApplication sharedApplication];
	app.networkActivityIndicatorVisible = YES;
	if (self.modalViewController)
		[splashViewController.activityIndicator startAnimating];
	self.refreshButton.enabled = NO;
	[self performSelectorInBackground:@selector(doUpnpDiscovery:) withObject:self.upnpCp];
}

- (void) doUpnpDiscovery:(id)obj
{
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	CGUpnpControlPoint* cp = (CGUpnpControlPoint*)obj;
	//	[cp setSsdpSearchMX:5];
	[cp search];
	NSArray* devs = [cp devices];
	NSUInteger numTries = 5;
	while ([devs count] == 0 && --numTries > 0)
	{
		[devs release];
		[cp search];
		devs = [cp devices];
	}
	[self performSelectorOnMainThread:@selector(onDiscoveredUpnpDevices:) withObject:devs waitUntilDone:YES];
	[pool drain];
}

- (void) onDiscoveredUpnpDevices:(NSArray*)devs
{
	UIApplication* app = [UIApplication sharedApplication];
	app.networkActivityIndicatorVisible = NO;
	if (self.modalViewController)
		[splashViewController.activityIndicator stopAnimating];
	self.devices = [NSArray arrayWithArray:devs];
	[self.tableView reloadData];
	self.refreshButton.enabled = YES;
	[self dismissModalViewControllerAnimated:YES];
}

- (void) startReachabilityNotifier
{
	Reachability* reachability = [Reachability sharedReachability];
	[reachability setHostName:@"www.apple.com"];
	//[reachability setAddress:@"192.168.1.1"];
	[reachability setNetworkStatusNotificationsEnabled:YES];
	[self reachabilityChanged:nil];
    // Observe the kNetworkReachabilityChangedNotification. When that notification is posted, the
    // method "reachabilityChanged" will be called. 
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:@"kNetworkReachabilityChangedNotification" object:nil];
}

- (void) stopReachabilityNotifier
{
	[[Reachability sharedReachability] setNetworkStatusNotificationsEnabled:NO];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:@"kNetworkReachabilityChangedNotification" object:nil];
}

- (void) reachabilityChanged:(NSNotification *)note
{
	Reachability* reachability = [Reachability sharedReachability];
	[reachability remoteHostStatus]; // seems to be needed to 'bootstrap' the notifier
	[reachability localWiFiConnectionStatus];
	NetworkStatus status  = [reachability internetConnectionStatus];
	if (status != self.nwStatus)
	{
		self.nwStatus = status;
		if (ReachableViaWiFiNetwork == status)
		{
			self.refreshButton.enabled = YES;
			if (!self.devices)
				[self upnpDiscoverDevices];
			if (self.modalViewController)
			{
				splashViewController.label = @"Scanning";
			}
		}
		else
		{
			self.refreshButton.enabled = NO;
			self.devices = nil;
			if (self.modalViewController)
			{
				splashViewController.label = @"Waiting for WiFi";
			}
		}
		[self.tableView reloadData];
	}
}

#pragma mark UIViewController methods

- (void)viewDidLoad 
{
    [super viewDidLoad];
	// Display splash screen
	SplashViewController* splashVC = [[SplashViewController alloc] initWithNibName:@"SplashViewController" bundle:nil];
	splashVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
	self.splashViewController = splashVC;
	[splashVC release];
	[self presentModalViewController:splashViewController animated:NO];
	self.title = @"Devices";
	self.upnpCp = [[CGUpnpControlPoint alloc] init];	
	self.nwStatus = NotReachable;
	self.refreshButton.enabled = NO;
	[self startReachabilityNotifier];
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
}


/*
- (void)viewWillAppear:(BOOL)animated 
{
    [super viewWillAppear:animated];
}
*/

/*
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}
*/

/*
- (void)viewWillDisappear:(BOOL)animated 
{
	[super viewWillDisappear:animated];
}
*/

/*
- (void)viewDidDisappear:(BOOL)animate
{
	[super viewDidDisappear:animated];
}
*/

/*
 // Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	// Return YES for supported orientations.
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
 */

- (void)didReceiveMemoryWarning 
{
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload
{
	// Release anything that can be recreated in viewDidLoad or on demand.
	// e.g. self.myOutlet = nil;
}


#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	if (self.devices)
		return [self.devices count];
	return 0;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    
    static NSString *CellIdentifier = @"UPnPDeviceNameCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) 
	{
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
	// Configure the cell.
	NSUInteger row = [indexPath row];
	CGUpnpDevice* device = (CGUpnpDevice*)[devices objectAtIndex:row];
	NSString* friendlyName = [device friendlyName];
	cell.textLabel.text = friendlyName;
	// icon
	NSString* devType = [device deviceType];
	if ([devType hasPrefix:kUpnpDeviceTypeInternetGatewayPrefix])
		cell.imageView.image = [UIImage imageNamed:@"Crystal_Modem.png"];
	else if ([devType hasPrefix:kUpnpDeviceTypeMediaServerPrefix] || [devType hasPrefix:kUpnpDeviceTypeMediaRendererPrefix])
		cell.imageView.image = [UIImage imageNamed:@"Crystal_multimedia.png"];
	if ([devType hasPrefix:kUpnpDeviceTypeWiNASPrefix])
		// Don't know what this is and google reveals nothing, but WD ShareSpace NAS boxes implement it!
		cell.imageView.image = [UIImage imageNamed:@"Crystal_hdd_unmount.png"];
    return cell;
}




// Override to support row selection in the table view.
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    // Navigation logic may go here -- for example, create and push another view controller.
	// AnotherViewController *anotherViewController = [[AnotherViewController alloc] initWithNibName:@"AnotherView" bundle:nil];
	// [self.navigationController pushViewController:anotherViewController animated:YES];
	// [anotherViewController release];
	NSUInteger row = [indexPath row];
	UPnPBrowserAppDelegate* delegate = (UPnPBrowserAppDelegate*)[[UIApplication sharedApplication] delegate];
	UINavigationController* navController = delegate.navigationController;
	DeviceViewController* devViewCnt = [[DeviceViewController alloc] initWithStyle:UITableViewStylePlain];
	CGUpnpDevice* device = (CGUpnpDevice*)[self.devices objectAtIndex:row];
	devViewCnt.device = device;
	[navController pushViewController:devViewCnt animated:YES];
	[devViewCnt release];
}



- (UITableViewCellAccessoryType)tableView:(UITableView *)tableView accessoryTypeForRowWithIndexPath:(NSIndexPath *)indexPath
{
	return UITableViewCellAccessoryDisclosureIndicator;
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
	[self tableView:tableView didSelectRowAtIndexPath:indexPath];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source.
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }   
}
*/


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


- (void)dealloc
{
	[devices release];
	[upnpCp release];
	[refreshButton release];
	[splashViewController release];
    [super dealloc];
}


@end

