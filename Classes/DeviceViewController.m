//
//  DeviceViewController.m
//  UPnPBrowser
//
//  Created by Neil Davis on 10/08/2009.
//  Copyright 2009 Oppian Systems Ltd. All rights reserved.
//

#import "DeviceViewController.h"
#import "UPnPBrowserAppDelegate.h"
#import "ServicesViewController.h"

@interface DeviceViewController()
- (void) onComposeButtonPressed;
@end

@implementation DeviceViewController

@synthesize device;

- (void) onComposeButtonPressed
{
	// Use MessageUI framework to compose in app email
	MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
	picker.mailComposeDelegate = self; // <- very important step if you want feedbacks on what the user did with your email sheet
	
	[picker setSubject:[NSString stringWithFormat:@"[UPnP Browser for iPhone] Device details - %@", [device friendlyName]]];
	
	// Fill out the email body text
	NSString* url = @"Not available";
	@try { url = [device urlBase]; }
	@catch(NSException* ignored) {}
	NSString* emailBody = [NSString stringWithFormat:@"<html><body><h3>UPnP Browser device details - %@</h3><table><tr><td><b>Device Type:</b></td><td>%@</td></tr><tr><td><b>Manufacturer:</b></td><td>%@</td></tr><tr><td><b>UDN:</b></td><td>%@</td></tr><tr><td><b>IP Address:</b></td><td>%@</td></tr><tr><td><b>URL:</b></td><td>%@</td></tr></table><hr/>Created by UPnP Browser for iPhone, (c) 2009 <a href='http://www.oppian.com'>Oppian Systems Ltd</a></body></html>", [device friendlyName], [device deviceType], [device manufacturer], [device udn], [device ipaddress], url];
	[picker setMessageBody:emailBody isHTML:YES]; // depends. Mostly YES, unless you want to send it as plain text (boring)
	picker.navigationBar.barStyle = UIBarStyleBlack; // choose your style, unfortunately, Translucent colors behave quirky.
	[self presentModalViewController:picker animated:YES];
	[picker release];
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    // Notifies users about errors associated with the interface
    switch (result)
    {
		case MFMailComposeResultCancelled:
			break;
		case MFMailComposeResultSaved:
			break;
		case MFMailComposeResultSent:
			break;
		case MFMailComposeResultFailed:
			break;
		default:
		{
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Email" message:@"Sending Failed – Unknown Error :-( "
														   delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
			[alert show];
			[alert release];
		}
								  
		break;
	}
	[self dismissModalViewControllerAnimated:YES];
}
								  
			/*
- (id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    if (self = [super initWithStyle:style]) {
    }
    return self;
}
*/


- (void)viewDidLoad 
{
    [super viewDidLoad];
	NSString* friendlyName = [self.device friendlyName];
	self.title = friendlyName;
	
	// Create an 'email' button
	UIBarButtonItem* emailBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(onComposeButtonPressed)];

     self.navigationItem.rightBarButtonItem = emailBarButton;
}


/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/
/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
}
*/

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 6;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    
    NSUInteger row = [indexPath row];
	switch (row)
	{
		case 0:	// Device type
			cell.textLabel.text = @"Device Type";
			cell.detailTextLabel.text = [device deviceType];
			break;
		case 1:	// Manufacturer
			cell.textLabel.text = @"Manufacturer";
			cell.detailTextLabel.text = [device manufacturer];
			break;
		case 2:	// UDN
			cell.textLabel.text = @"UDN";
			cell.detailTextLabel.text = [device udn];
			break;
		case 3:	// IP Address
			cell.textLabel.text = @"IP Address";
			cell.detailTextLabel.text = [device ipaddress];
			break;
		case 4:	// Base URL
			cell.textLabel.text = @"URL";
			NSString* url = nil;
			// This can throw an exception
			@try
			{
				url = [device urlBase];
			}
			@catch (NSException* ignored)
			{
				url = @"Not available";
			}
			cell.detailTextLabel.text = url;
			break;
		case 5:	// Services
			cell.textLabel.text = @"Services";
			cell.detailTextLabel.text = @"Click to see available services";
			break;
	}
	
    return cell;
}


- (UITableViewCellAccessoryType)tableView:(UITableView *)tableView accessoryTypeForRowWithIndexPath:(NSIndexPath *)indexPath
{
	NSUInteger row = [indexPath row];
	if (5 == row)
		return UITableViewCellAccessoryDisclosureIndicator;
	return UITableViewCellAccessoryNone;
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
	[self tableView:tableView didSelectRowAtIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
	// AnotherViewController *anotherViewController = [[AnotherViewController alloc] initWithNibName:@"AnotherView" bundle:nil];
	// [self.navigationController pushViewController:anotherViewController];
	// [anotherViewController release];
	NSUInteger row = [indexPath row];
	switch (row)
	{
		case 1:	// Manufacturer
		{
			// We have no direct access to manufacturer url through cyberlinkc, but we can workaround with google 'I'm feeling lucky' ;)
			NSString* url = [NSString stringWithFormat:@"http://www.google.com/search?q=%@&btnI=745", [device manufacturer]];
			[[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
			break;
		}
		case 3: // IP Address
		{
			NSString* url = [NSString stringWithFormat:@"http://%@", [device ipaddress]];
			[[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
			break;
		}
		case 4:	// Url 
			// This can throw an exception
			@try
			{
				[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[device urlBase]]];
			}
			@catch (NSException* ignored) {}
			break;
		case 5:
		{
			UPnPBrowserAppDelegate* delegate = (UPnPBrowserAppDelegate*)[[UIApplication sharedApplication] delegate];
			UINavigationController* navController = delegate.navigationController;
			ServicesViewController* svcsViewCnt = [[ServicesViewController alloc] initWithStyle:UITableViewStylePlain];
			svcsViewCnt.device = device;
			[navController pushViewController:svcsViewCnt animated:YES];
			[svcsViewCnt release];
			break;
		}
		default:
			break;
	}
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
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
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


- (void)dealloc {
	[device release];
    [super dealloc];
}


@end

