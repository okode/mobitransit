//
//  OkodeInfo.h
//  Mobitransit
//
//  Created by Daniel Soro Coicaud on 25/09/10.
//  Copyright Okode S.L. 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MobitransitDelegate.h"

@interface OkodeInfo : UIViewController <UIWebViewDelegate> {
	
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
