//
//  SMSViewController.h
//  Mobitransit
//
//  Created by Daniel Soro Coicaud on 31/03/11.
//  Copyright 2011 Okode. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "MobitransitDelegate.h"

@interface SMSViewController : UIViewController <MFMessageComposeViewControllerDelegate> {
    
    id <MobitransitDelegate> delegate;
    
    UILabel *firstTitleLabel;
    UILabel *secondTitleLabel;
    UILabel *moreInfoLabel;
    UILabel *moreInfoLabel2;
    
    
    UIButton *buyMobileTicket;
    UIButton *callHKLInfo;
    UIButton *orderTaxi;
}

-(IBAction)sendBuyMobileTicketSMS:(id) sender;
-(IBAction)callForInfo:(id)sender;
-(IBAction)seeHKLWebInfo;
-(IBAction)seeTaksiHelsinkiWebInfo;
-(IBAction)callTaxiSMS:(id)sender;

-(void)populateTaxiSMS:(NSString*)city onStreet:(NSString*)street andNumber:(NSString *)number;

@property (nonatomic, assign) IBOutlet id <MobitransitDelegate> delegate;
@property (nonatomic, retain) IBOutlet UILabel *firstTitleLabel;
@property (nonatomic, retain) IBOutlet UILabel *secondTitleLabel;
@property (nonatomic, retain) IBOutlet UILabel *moreInfoLabel;
@property (nonatomic, retain) IBOutlet UILabel *moreInfoLabel2;
@property (nonatomic, retain) IBOutlet UIButton *buyMobileTicket;
@property (nonatomic, retain) IBOutlet UIButton *callHKLInfo;
@property (nonatomic, retain) IBOutlet UIButton *orderTaxi;

@end
