//
//  TashouNoEnViewController.h
//  TashouNoEn
//
//  Created by 上田 澄博 on 09/08/25.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GameKit/GameKit.h>

@interface TashouNoEnViewController : UIViewController <GKSessionDelegate,UITextFieldDelegate> {
	GKSession *mySession;
	
	IBOutlet UITextView *logTextView;
	IBOutlet UITextField *messageTextField;
}

- (void)addLog:(NSString*)logString;

@end

