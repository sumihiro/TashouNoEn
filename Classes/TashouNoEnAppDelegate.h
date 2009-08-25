//
//  TashouNoEnAppDelegate.h
//  TashouNoEn
//
//  Created by 上田 澄博 on 09/08/25.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TashouNoEnViewController;

@interface TashouNoEnAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    TashouNoEnViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet TashouNoEnViewController *viewController;

@end

