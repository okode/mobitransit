//
//  NewslettersController.h
//  Mobitransit
//
//  Created by Daniel Soro Coicaud on 29/03/11.
//  Copyright 2011 Okode. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MobitransitDelegate.h"


@interface NewslettersController : UITableViewController <NSXMLParserDelegate> {
    
    id <MobitransitDelegate> delegate;
    
    NSMutableArray *newsletters;
    NSMutableArray *targetedLines;
    NSMutableArray *disruptions;
    
    BOOL adviceText;
    BOOL newAdvices;
    BOOL showingAdvices;
    
    int unreadNewsletter;
    
}

-(void)requestNews;

@property (nonatomic, assign) IBOutlet id <MobitransitDelegate> delegate;
@property (nonatomic, retain) NSMutableArray *newsletters;
@property (nonatomic, retain) NSMutableArray *targetedLines;
@property (nonatomic, retain) NSMutableArray *disruptions;
@property (nonatomic, assign) BOOL adviceText;
@property (nonatomic, assign) BOOL newAdvices;
@property (nonatomic, assign) BOOL showingAdvices;
@property (nonatomic, assign) int unreadNewsletter;

@end
