//
//  OkodeInfo.m
//  Mobitransit
//
//  Created by Daniel Soro Coicaud on 25/09/10.
//  Copyright Okode S.L. 2010. All rights reserved.
//

#import "OkodeInfo.h"
#import "Utils.h"

@implementation OkodeInfo

@synthesize textInformation, appVersion;


- (void)viewDidLoad {
	//[textInformation setText:NSLocalizedString(@"OKODE_INFO", @"")];
	[appVersion setText:kMobVersion];
	
	[textInformation loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"index" ofType:@"html"]isDirectory:NO]]];
	[textInformation setOpaque:NO];
	
	[textInformation setBackgroundColor:[UIColor clearColor]];
	
	[[textInformation.subviews objectAtIndex:0] setIndicatorStyle:UIScrollViewIndicatorStyleWhite];
	//[scrollView  
	
	//textInformation.bakgroundColor = [UIColor clearColor]
	//[textInformation ]
}

 /*	
 /   @method: sendMail
 /	 @description: Redirects to the mail application with the okode mail information.
 /	 @param: sender - references the UIBarButtonItem.
 /	 @return: IBAction - Connected to the mail button on OkodeInfo.xib
 */
 
-(IBAction) sendMail:(id)sender{
	[Utils trackPageView:kOkodeMail];
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"mailto://info@okode.com"]];
}

 /*	
 /   @method: goToOkde
 /	 @description: Redirects to Safari navigator showing Okode's web page.
 /	 @param: sender - references the UIBarButtonItem.
 /	 @return: IBAction - Connected to the okode button on OkodeInfo.xib
 */

-(IBAction) goToOkode:(id)sender{
	[Utils trackPageView:kOkodeWeb];
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.okode.com"]];
}

 /*	
 /   @method: goToMap
 /	 @description: Redirects to the google Maps application showing Okode's location.
 /	 @param: sender - references the UIBarButtonItem.
 /	 @return: IBAction - Connected to the marker button on OkodeInfo.xib
 */

-(IBAction) goToMap:(id)sender{
	[Utils trackPageView:kOkodeMap];
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://maps.google.es/maps?f=q&source=s_q&hl=es&geocode=&q=okode&sll=40.396764,-3.713379&sspn=10.988054,22.873535&ie=UTF8&hq=okode&hnear=&ll=39.480726,-0.334568&spn=0.087049,0.178699&z=13&iwloc=A"]];
}

 /*	
 /   @method: goToFacebook
 /	 @description: Redirects to the Facebook's mobitransit page.
 /	 @param: sender - references the UIBarButtonItem.
 /	 @return: IBAction - Connected to the marker button on OkodeInfo.xib
 */

-(IBAction) goToFacebook:(id)sender{
	[Utils trackPageView:kMobFacebook];
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://touch.facebook.com/mobitransit"]];
}

/*	
 /   @method: goToRate
 /	 @description: Redirects to the mobitransit's page on App Store.
 /	 @param: sender - references the UIBarButtonItem.
 /	 @return: IBAction - Connected to the marker button on OkodeInfo.xib
 */

-(IBAction) goToRate:(id)sender{
	NSString *urlString = [NSString stringWithFormat:@"http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=%@&onlyLatestVersion=false&type=Purple+Software",kMobitransitId];
	NSLog(@"%@",urlString);
	[Utils trackPageView:kMobRate];
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType; {
	
    NSURL *requestURL = [ [ request URL ] retain ];
    // Check to see what protocol/scheme the requested URL is.
    if ( ( [ [ requestURL scheme ] isEqualToString: @"http" ]
		  || [ [ requestURL scheme ] isEqualToString: @"https" ] )
        && ( navigationType == UIWebViewNavigationTypeLinkClicked ) ) {
        return ![ [ UIApplication sharedApplication ] openURL: [ requestURL autorelease ] ];
    }
    // Auto release
    [ requestURL release ];
    // If request url is something other than http or https it will open
    // in UIWebView. You could also check for the other following
    // protocols: tel, mailto and sms
    return YES;
}


- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return YES;
}

- (void)viewDidUnload {
    [super viewDidUnload];
}


- (void)dealloc {
	[textInformation release];
	[appVersion release];
    [super dealloc];
}


@end
