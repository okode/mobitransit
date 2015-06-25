//
//  OkodeInfo_iPad.h
//  Mobitransit
//
//  Created by Daniel Soro Coicaud on 02/10/10.
//  Copyright 2010 Okode S.L. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MobitransitDelegate.h"

@interface OkodeInfo_iPad : UIViewController <UIWebViewDelegate> {

	UIWebView *textInformation;
	
	UILabel *appVersion;
	
}

-(IBAction) sendMail:(id)sender;
-(IBAction) goToOkode:(id)sender;
-(IBAction) goToMap:(id)sender;
-(IBAction) goToFacebook:(id)sender;
-(IBAction) goToRate:(id)sender;

@property (nonatomic, retain) IBOutlet UIWebView* textInformation;
@property (nonatomic, retain) IBOutlet UILabel *appVersion;

@end
