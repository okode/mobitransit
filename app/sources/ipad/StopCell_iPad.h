//
//  StopCell_iPad.h
//  Mobitransit
//
//  Created by Daniel Soro Coicaud on 14/10/10.
//  Copyright 2010 Okode S.L. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface StopCell_iPad : UITableViewCell {
	
	UILabel *hour;
	UILabel *destination;
	UILabel *line;
	
	UIImageView *imgDecor;

}

@property (nonatomic, retain) IBOutlet UILabel *hour;
@property (nonatomic, retain) IBOutlet UILabel *destination;
@property (nonatomic, retain) IBOutlet UILabel *line;
@property (nonatomic, retain) IBOutlet UIImageView *imgDecor;

@end
