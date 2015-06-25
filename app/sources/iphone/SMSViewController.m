//
//  SMSViewController.m
//  Mobitransit
//
//  Created by Daniel Soro Coicaud on 31/03/11.
//  Copyright 2011 Okode. All rights reserved.
//

#import "SMSViewController.h"
#import "ActivityIndicator.h"

@implementation SMSViewController

@synthesize delegate;
@synthesize firstTitleLabel;
@synthesize secondTitleLabel;
@synthesize moreInfoLabel;
@synthesize moreInfoLabel2;
@synthesize buyMobileTicket;
@synthesize callHKLInfo;
@synthesize orderTaxi;


- (void)dealloc {
    [firstTitleLabel release];
    [secondTitleLabel release];
    [moreInfoLabel release];
    [moreInfoLabel2 release];
    [buyMobileTicket release];
    [callHKLInfo release];
    [orderTaxi release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle


- (void)viewDidLoad{
    [super viewDidLoad];
    [firstTitleLabel setText:NSLocalizedString(@"SMS_FIRST_TITLE",@"")];
    [secondTitleLabel setText:NSLocalizedString(@"SMS_SECOND_TITLE",@"")];
    [moreInfoLabel setText:NSLocalizedString(@"SMS_MORE_INFO",@"")];
    [moreInfoLabel2 setText:NSLocalizedString(@"SMS_MORE_INFO",@"")];
    [buyMobileTicket setTitle:NSLocalizedString(@"SMS_BUY_TICKET",@"") forState:UIControlStateNormal];
    [callHKLInfo setTitle:NSLocalizedString(@"SMS_CALL_HKL",@"") forState:UIControlStateNormal];
    [orderTaxi setTitle:NSLocalizedString(@"SMS_CALL_TAXI",@"") forState:UIControlStateNormal];
}

-(IBAction)sendBuyMobileTicketSMS:(id) sender{
	MFMessageComposeViewController *controller = [[[MFMessageComposeViewController alloc] init] autorelease];
	if([MFMessageComposeViewController canSendText]){
		controller.body = @"A1";
		controller.recipients = [NSArray arrayWithObjects:@"16355", nil];
		controller.messageComposeDelegate = self;
		[self presentModalViewController:controller animated:YES];
	}
}

-(IBAction)callForInfo:(id)sender{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel:0600393600"]];
}

-(IBAction)seeHKLWebInfo{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSArray *languages = [defaults objectForKey:@"AppleLanguages"];
	if(![[languages objectAtIndex:0] isEqualToString:@"fi"]){
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.hel2.fi/HKL/mobile/mobileticket.html"]];
    }else{
       [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.hel2.fi/HKL/mobile/kannykkalippu.html"]];
    }
    
}

-(IBAction)seeTaksiHelsinkiWebInfo{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSArray *languages = [defaults objectForKey:@"AppleLanguages"];
	if(![[languages objectAtIndex:0] isEqualToString:@"fi"]){
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.taksihelsinki.fi/htdeng/page2.aspx"]];
    }else{
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.taksihelsinki.fi/htdswe/page003.aspx"]];
    }
}

-(IBAction)callTaxiSMS:(id) sender{
    [delegate startReverseGeocoding];
}

-(void)populateTaxiSMS:(NSString*)city onStreet:(NSString*)street andNumber:(NSString *)number{
    MFMessageComposeViewController *controller = [[[MFMessageComposeViewController alloc] init] autorelease];
	if([MFMessageComposeViewController canSendText]){
		controller.body = [NSString stringWithFormat:@"%@\n%@\n%@",city,street,number];
		controller.recipients = [NSArray arrayWithObjects:@"13170", nil];
		controller.messageComposeDelegate = self;
		[self presentModalViewController:controller animated:YES];
	}
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result {
    
    if(result == MessageComposeResultSent){
        [[ActivityIndicator currentIndicator] displayCompleted:NSLocalizedString(@"SHARE_COMPLETE",@"")];
    }else if(result == MessageComposeResultFailed){
        [[ActivityIndicator currentIndicator] displayError:NSLocalizedString(@"UNEXPECTED_ERROR",@"")];
    }
    
    [controller dismissModalViewControllerAnimated:YES];

}

- (void)viewDidUnload{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
