//
//  ModalView.m
//  Mobitransit_Helsinki
//
//  Created by Daniel Soro Coicaud on 21/09/10.
//  Copyright 2010 Okode S.L. All rights reserved.
//

#import "ModalView.h"


@implementation ModalView

@synthesize label, image, descriptionLabel;

 /*	
 /	@method: initLoadingBox:
 /	@description: Modal View initialization. Shows the Loading message.
 /	@param: frame - modal view size
 /	@param: device - 0: iPhone, 1:iPad
 /	@return: id - self reference
 */

-(id)initLoadingBox:(CGRect)frame forDevice:(int)device{
	if ((self = [super initWithFrame:frame])) {
		UIImage *img;
		if(device==0){
			img = [UIImage imageNamed:@"Default.png"];
		}else{ 
			img = [UIImage imageNamed:@"Default-Portrait~ipad.png"];
		}
		image = [[UIImageView alloc] initWithImage:img];
		image.frame = frame;
		[self addSubview:image];
		
		label = [[UILabel alloc] initWithFrame:CGRectMake((frame.size.width/2.46), (frame.size.height/2.14), 160, 20)];
		[label setFont:[UIFont boldSystemFontOfSize:17]]; 
		[label setTextAlignment:UITextAlignmentLeft];
		[label setBackgroundColor:[UIColor clearColor]];
		UIColor *bgColor = [[UIColor alloc] initWithRed:1 green:1 blue:1 alpha:1.0];
		[label setTextColor:bgColor];
		[bgColor release];
		[label setText:NSLocalizedString(@"LOADING", @"")];
		[self addSubview:label];
		
		
		UIActivityIndicatorView *activity = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge] autorelease];
		[activity startAnimating];
		[activity setCenter:CGPointMake((frame.size.width/2.46)-30, (frame.size.height/2.14)+10)];
		[self addSubview:activity];
		
	}
    return self;	
}

/*	
 /	@method: initLoadingBox:
 /	@description: Modal View initialization. Customized Modal Box.
 /	@param: frame - modal view size
 /	@param: imageName - Image file's name
 /	@param: labelText - Text to add on the title label
 /	@return: id - self reference
 */

-(id)initModalBox:(CGRect)frame withImage:(NSString *)imageName withLabel:(NSString *)labelText{
	if ((self = [super initWithFrame:frame])) {
		UIColor *bgColor = [[UIColor alloc] initWithRed:0.0 green:0.0 blue:0.0 alpha:0.7];
		[self setBackgroundColor: bgColor];
		[bgColor release];
		image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
		[image setCenter:CGPointMake(frame.size.width/2, frame.size.height/2 - 50)];
		[image setAlpha:0.6];
		label = [[UILabel alloc] initWithFrame:CGRectMake(0, frame.size.height/2, frame.size.width, 80)];
		[label setFont:[UIFont boldSystemFontOfSize:18]];
		[label setTextAlignment:UITextAlignmentCenter];
		[label setBackgroundColor:[UIColor clearColor]];
		bgColor = [[UIColor alloc] initWithRed:0.8 green:0.8 blue:0.8 alpha:1.0];
		[label setTextColor:bgColor];
		[bgColor release];
		[label setText:labelText];
		[self addSubview:label];
		[self addSubview:image];
	}
    return self;	
}

 /*	
 /	@method: addDescriptionLabel:
 /	@description: Adds subtitle's message on a scrollable textView.
 /	@param: text - subtitle's content.
 */

-(void)addDescriptionLabel:(NSString*)text{
	descriptionLabel = [[UITextView alloc] initWithFrame:CGRectMake(0, self.frame.size.height/2 +50, self.frame.size.width, self.frame.size.height/2 -50)];
	[descriptionLabel setFont:[UIFont boldSystemFontOfSize:16]];
	[descriptionLabel setTextAlignment:UITextAlignmentCenter];
	[descriptionLabel setBackgroundColor:[UIColor clearColor]];
	UIColor *bgColor = [[UIColor alloc] initWithRed:0.8 green:0.8 blue:0.8 alpha:1.0];
	[descriptionLabel setTextColor:bgColor];
	[descriptionLabel setEditable:NO];
	[bgColor release];
	[descriptionLabel setText: text];
	[self addSubview:descriptionLabel];
}


- (void)dealloc {
	[label release];
	[image release];
	[descriptionLabel release];
    [super dealloc];
}


@end
