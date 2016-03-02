//
//  StopCell.m
//  Mobitransit
//
//  Created by Daniel Soro Coicaud on 14/10/10.
//  Copyright 2010 Okode S.L. All rights reserved.
//

#import "NewsCell.h"


@implementation NewsCell

@synthesize textView, line, imgDecor;

 /*	
 /	@method: initWithStyle:reuseIdentifier
 /	@description: Design initialization for a stop cell
 /  @param: style. 
 /  @param: reuseIdentifier.
 /  @return: id - self reference.
 */

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
		imgDecor = [[UIImageView alloc] initWithFrame:CGRectMake(6,12,33,45)];
		imgDecor.contentMode = UIViewContentModeBottom;
		[self.contentView addSubview:imgDecor];
		
		line = [[UILabel alloc]initWithFrame:CGRectMake(9,34,28,21)];
		[line setFont:[UIFont fontWithName:@"Helvetica-Bold" size:14]];
		line.textAlignment =  UITextAlignmentCenter;
		line.textColor = [UIColor blackColor];
		line.backgroundColor = [UIColor clearColor];
        
        [self.contentView addSubview:line];
        
        textView = [[UITextView alloc] initWithFrame:CGRectMake(40, 4, 200, 60)];
        textView.backgroundColor = [UIColor clearColor];
        [textView setScrollEnabled:NO];
        [textView setEditable:NO];
        [textView setFont:[UIFont systemFontOfSize:12.0]];
        
		[self.contentView addSubview:textView];
		
		[self setSelectionStyle:UITableViewCellSelectionStyleNone];
		
    }
    return self;
}


- (void)dealloc {
    [textView release];
	[line release];
	[imgDecor release];
	[super dealloc];
}


@end
