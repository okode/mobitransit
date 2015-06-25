//
//  InformationController.m
//  Mobitransit
//
//  Created by Daniel Soro Coicaud on 29/03/11.
//  Copyright 2011 Okode. All rights reserved.
//

#import "InformationController.h"


@implementation InformationController

@synthesize newsController;
@synthesize advicesLabel;
@synthesize ticketsLabel;
@synthesize mobitransitAppLabel;
@synthesize okodeInfo;
@synthesize smsInfo;
@synthesize ticketsButton;
@synthesize aboutButton;


- (void)dealloc {
    [newsController release];
    [advicesLabel release];
    [ticketsLabel release];
    [mobitransitAppLabel release];
    [okodeInfo release];
    [smsInfo release];
    [ticketsButton release];
    [aboutButton release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [advicesLabel setText:NSLocalizedString(@"INFO_ADVICES",@"")];
    [ticketsLabel setText:NSLocalizedString(@"INFO_TICKETS",@"")];
    [ticketsButton setTitle:NSLocalizedString(@"INFO_SMS_TICKETS",@"") forState:UIControlStateNormal];
    [mobitransitAppLabel setText:NSLocalizedString(@"INFO_MOBITRANSIT_APP",@"")];
    [aboutButton setTitle:NSLocalizedString(@"INFO_ABOUT",@"") forState:UIControlStateNormal];
    if(![MFMessageComposeViewController canSendText]){
        [ticketsButton setEnabled:NO];
    }
}


- (void)viewDidUnload{
    [super viewDidUnload];
}

/*
 /	@method: showOkodeInfo
 /	@description: Pushes the Okode information viewController on the navigationController.
 /  @return: IBAction - Connected to the info button on MainWindow.xib
 */

-(IBAction)showOkodeInfo{
	[Utils trackPageView:kOkodePage];
	[self.navigationController pushViewController:okodeInfo animated:YES];
}

-(IBAction)showTicketsInfo{
    [self.navigationController pushViewController:smsInfo animated:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
