//
//  ShareMessageController.h
//  Mobitransit
//
//  Created by Daniel Soro Coicaud on 30/03/11.
//  Copyright 2011 Okode S.L. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MobitransitDelegate.h"

@interface ShareMessageController : UIViewController {
	
	id <MobitransitDelegate> delegate;
	
	UITextView *textView;
	
	UILabel *shareLabel;
    UILabel *charCountLabel;
    UILabel *limitCountTwitter;
	UIButton *shareFacebook;
	UIButton *shareTwitter;

}

-(IBAction)shareOnTwitter:(id)sender;
-(IBAction)shareOnFacebook:(id)sender;

@property (nonatomic, assign) IBOutlet id <MobitransitDelegate> delegate;
@property (nonatomic, retain) IBOutlet UITextView *textView;
@property (nonatomic, retain) IBOutlet UILabel *shareLabel;
@property (nonatomic, retain) IBOutlet UILabel *charCountLabel;
@property (nonatomic, retain) IBOutlet UILabel *limitCountTwitter;
@property (nonatomic, retain) IBOutlet UIButton *shareFacebook;
@property (nonatomic, retain) IBOutlet UIButton *shareTwitter;

@end
