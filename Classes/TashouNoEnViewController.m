//
//  TashouNoEnViewController.m
//  TashouNoEn
//
//  Created by 上田 澄博 on 09/08/25.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import "TashouNoEnViewController.h"

#define kSessionID @"_tashounoen"

@implementation TashouNoEnViewController



/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];

	NSString *message = [[NSUserDefaults standardUserDefaults] objectForKey:@"message"];
	if(message) {
		[messageTextField setText:message];
	}

	mySession = [[GKSession alloc] initWithSessionID:kSessionID displayName:nil sessionMode:GKSessionModePeer];
	mySession.delegate = self;
	[mySession setDataReceiveHandler:self withContext:nil];
	mySession.available = YES;
	
	[self addLog:[NSString stringWithFormat:@"誰かを探し始めた！自分のIDは %@",mySession.peerID]];
}


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


- (void)dealloc {
	[logTextView release];
	[messageTextField release];
	
    [super dealloc];
}

#pragma mark Helper
- (void)addLog:(NSString*)logString {
	
	//mainTextView.text = [NSString stringWithFormat:@"- %@\n%@",logString,mainTextView.text];
	[self performSelectorOnMainThread:@selector(updateLog:) withObject:logString waitUntilDone:YES];
	
}

- (void)updateLog:(NSString*)logString {
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	logTextView.text = [NSString stringWithFormat:@"- %@\n%@",logString,logTextView.text];
	
	[pool release];
}


#pragma mark GKSessionDelegate

- (void)session:(GKSession *)session connectionWithPeerFailed:(NSString *)peerID withError:(NSError *)error {
	[self addLog:[NSString stringWithFormat:@"%@ とうまく接続できない。 (%@)",peerID,[error localizedDescription]]];
}

- (void)session:(GKSession *)session didFailWithError:(NSError *)error {
	[self addLog:[NSString stringWithFormat:@"ネットワークがおかしい？ (%@)",[error localizedDescription]]];
}

- (void)session:(GKSession *)session didReceiveConnectionRequestFromPeer:(NSString *)peerID {
	[self addLog:[NSString stringWithFormat:@"%@ から接続したいと言われた！",peerID]];

	NSError *error;
	if(![mySession acceptConnectionFromPeer:peerID error:&error]) {
		[self addLog:[NSString stringWithFormat:@"%@ と接続できなかった… (%@)",peerID,[error localizedDescription]]];
	} else {
		[self addLog:[NSString stringWithFormat:@"%@ と接続できた！",peerID]];

	}
}

- (void)session:(GKSession *)session peer:(NSString *)peerID didChangeState:(GKPeerConnectionState)state {	
	switch (state) {
		case GKPeerStateAvailable:
			[self addLog:[NSString stringWithFormat:@"%@ を見つけた！",peerID]];
			[self addLog:[NSString stringWithFormat:@"%@ に接続しに行く！",peerID]];
			[mySession connectToPeer:peerID withTimeout:10.0f];
			break;
		case GKPeerStateUnavailable:
			[self addLog:[NSString stringWithFormat:@"%@ を見失った！",peerID]];
			break;
		case GKPeerStateConnected:
			[self addLog:[NSString stringWithFormat:@"%@ が接続した！",peerID]];
			[mySession sendData:[[messageTextField text] dataUsingEncoding:NSUTF8StringEncoding] toPeers:[NSArray arrayWithObject:peerID] withDataMode:GKSendDataReliable error:nil];
			[self addLog:[NSString stringWithFormat:@"%@ にメッセージを送った！「%@」",peerID,[messageTextField text]]];
			break;
		case GKPeerStateDisconnected:
			[self addLog:[NSString stringWithFormat:@"%@ が切断された！",peerID]];
			break;
		case GKPeerStateConnecting:
			[self addLog:[NSString stringWithFormat:@"%@ が接続中！",peerID]];
			break;
		default:
			break;
	}
}

- (void) receiveData:(NSData *)data fromPeer:(NSString *)peer inSession:(GKSession *)session context:(void *)context {
	[self addLog:[NSString stringWithFormat:@"%@ からメッセージを受け取った！ 「%@」",peer,[[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease]]];
}

#pragma mark UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField {
	[[NSUserDefaults standardUserDefaults] setObject:textField.text forKey:@"message"];
}

@end
