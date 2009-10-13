//
//  SplashViewController.h
//  UPnPBrowser
//
//  Created by Neil Davis on 05/10/2009.
//  Copyright 2009 Oppian Systems Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SplashViewController : UIViewController 
{
	IBOutlet UILabel*	label;
	IBOutlet UIActivityIndicatorView* activityIndicator;
}

@property(nonatomic, retain) UILabel* label;
@property(nonatomic, retain) UIActivityIndicatorView* activityIndicator;

@end
