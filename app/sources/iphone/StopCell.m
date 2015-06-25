//
//  StopCell.m
//  Mobitransit
//
//  Created by Daniel Soro Coicaud on 14/10/10.
//  Copyright 2010 Okode S.L. All rights reserved.
//

#import "StopCell.h"


@implementation StopCell

@synthesize hour, destination, line, imgDecor;

 /*	
 /	@method: initWithStyle:reuseIdentifier
 /	@description: Design initialization for a stop cell
 /  @param: style. 
 /  @param: reuseIdentifier.
 /  @return: id - self reference.
 */

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
		
		CGRect contentRect = [self.contentView bounds];
		
		UIImageView *bgnd = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,115,42)];
		[bgnd setImage:[UIImage imageNamed:@"stopTimeBgndCell.png"]];
		[self.contentView addSubview:bgnd];
        [bgnd release];
		
		hour = [[UILabel alloc]initWithFrame:CGRectMake(10,0,70,50)];
		[hour setFont:[UIFont fontWithName:@"DBLCDTempBlack" size:18]];
		hour.textColor = [UIColor blackColor];
		hour.backgroundColor = [UIColor clearColor];
		[self.contentView addSubview:hour];
		
		imgDecor = [[UIImageView alloc] initWithFrame:CGRectMake(67,3,39,32)];
		imgDecor.contentMode = UIViewContentModeBottom;
		[self.contentView addSubview:imgDecor];
		
		line = [[UILabel alloc]initWithFrame:CGRectMake(73,11,28,21)];
		[line setFont:[UIFont fontWithName:@"Helvetica-Bold" size:14]];
		line.textAlignment =  UITextAlignmentCenter;
		line.textColor = [UIColor whiteColor];
		line.backgroundColor = [UIColor clearColor];
		[self.contentView addSubview:line];

		
		
		destination = [[UILabel alloc]initWithFrame:CGRectMake(115,7,contentRect.size.width - 115,29)];
		[destination setFont:[UIFont fontWithName:@"Helvetica" size:14]];
		destination.textColor = [UIColor blackColor];
		destination.backgroundColor = [UIColor clearColor];
		[self.contentView addSubview:destination];
		
		[self setSelectionStyle:UITableViewCellSelectionStyleNone];
		
    }
    return self;
}


- (void)dealloc {
	[hour release];
    [destination release];
	[line release];
	[imgDecor release];
	[super dealloc];
}


@end
