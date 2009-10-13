//
//  UPnPBrowserAppDelegate.h
//  UPnPBrowser
//
//  Created by Neil Davis on 10/08/2009.
//  Copyright Oppian Systems Ltd 2009. All rights reserved.
//

@interface UPnPBrowserAppDelegate : NSObject <UIApplicationDelegate> {
    
    UIWindow *window;
    UINavigationController *navigationController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;

@end

