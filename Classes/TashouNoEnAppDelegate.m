//
//  TashouNoEnAppDelegate.m
//  TashouNoEn
//
//  Created by 上田 澄博 on 09/08/25.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import "TashouNoEnAppDelegate.h"
#import "TashouNoEnViewController.h"

@implementation TashouNoEnAppDelegate

@synthesize window;
@synthesize viewController;


- (void)applicationDidFinishLaunching:(UIApplication *)application {    
    
    // Override point for customization after app launch    
    [window addSubview:viewController.view];
    [window makeKeyAndVisible];
}


- (void)dealloc {
    [viewController release];
    [window release];
    [super dealloc];
}


@end
