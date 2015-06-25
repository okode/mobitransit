    //
//  ShareMessageController.m
//  Mobitransit
//
//  Created by Daniel Soro Coicaud on 30/03/11.
//  Copyright 2011 Okode S.L. All rights reserved.
//

#import "ShareMessageController.h"

@implementation ShareMessageController

@synthesize delegate;
@synthesize textView;
@synthesize shareLabel;
@synthesize limitCountTwitter;
@synthesize charCountLabel;
@synthesize shareFacebook;
@synthesize shareTwitter;

- (void)viewDidLoad {
    [super viewDidLoad];
    [shareFacebook setTitle:NSLocalizedString(@"SHARE_ON_FACEBOOK", @"") forState:UIControlStateNormal];
    [shareTwitter setTitle:NSLocalizedString(@"SHARE_ON_TWITTER", @"") forState:UIControlStateNormal];
    [shareLabel setText:NSLocalizedString(@"SHARE_MESSAGE_TITLE", @"")];
}


-(void)viewWillAppear:(BOOL)animated{
	[shareTwitter setEnabled:[delegate twitterConnected]];
    [shareFacebook setEnabled:[delegate facebookConnected]];
    [charCountLabel setText:[NSString stringWithFormat:@"%d",[textView.text length]]];
}

-(IBAction)shareOnTwitter:(id)sender{
	[delegate twitMessage:textView.text];
}

-(IBAction)shareOnFacebook:(id)sender{
	[delegate facebookMessage:textView.text];
}

-(void)textViewDidChange:(UITextView *)theTextView{
    [charCountLabel setText:[NSString stringWithFormat:@"%d",[textView.text length]]];
    if([textView.text length] >= 140){
        [limitCountTwitter setTextColor:[UIColor redColor]];
    }else{
        [limitCountTwitter setTextColor:[UIColor whiteColor]];
    }
}

- (BOOL)textView:(UITextView *)theTextView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return FALSE;
    }
    return TRUE;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}


- (void)dealloc {
	[textView release];
	[shareLabel release];
	[shareFacebook release];
    [limitCountTwitter release];
    [charCountLabel release];
	[shareTwitter release];
    [super dealloc];
}


@end
