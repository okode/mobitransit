//
//  InformationController.h
//  Mobitransit
//
//  Created by Daniel Soro Coicaud on 29/03/11.
//  Copyright 2011 Okode. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "OkodeInfo.h"
#import "NewslettersController.h"
#import "Utils.h"
#import "SMSViewController.h"

@interface InformationController : UIViewController {
    
    UILabel *advicesLabel;
    UILabel *ticketsLabel;
    
    UIButton *ticketsButton;
    UIButton *aboutButton;
    
    UILabel *mobitransitAppLabel;
    
    OkodeInfo *okodeInfo;
    SMSViewController *smsInfo;
}


-(IBAction)showOkodeInfo;
-(IBAction)showTicketsInfo;

@property (nonatomic, retain) IBOutlet NewslettersController *newsController;
@property (nonatomic, retain) IBOutlet UILabel *advicesLabel;
@property (nonatomic, retain) IBOutlet UILabel *ticketsLabel;
@property (nonatomic, retain) IBOutlet UILabel *mobitransitAppLabel;

@property (nonatomic, retain) IBOutlet UIButton *ticketsButton;
@property (nonatomic, retain) IBOutlet UIButton *aboutButton;

@property (nonatomic, retain) IBOutlet OkodeInfo *okodeInfo;
@property (nonatomic, retain) IBOutlet SMSViewController *smsInfo;

@end
