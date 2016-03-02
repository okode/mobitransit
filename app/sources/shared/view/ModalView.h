//
//  ModalView.h
//  Mobitransit_Helsinki
//
//  Created by Daniel Soro Coicaud on 21/09/10.
//  Copyright 2010 Okode S.L. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ModalView : UIView {
	UILabel *label;
	UIImageView *image;
	UITextView *descriptionLabel;

}

-(id)initLoadingBox:(CGRect)frame forDevice:(int)device;
-(id)initModalBox:(CGRect)frame withImage:(NSString *)imageName withLabel:(NSString *)labelText;
-(void)addDescriptionLabel:(NSString*)text;

@property (nonatomic, retain) UILabel *label;
@property (nonatomic, retain) UIImageView *image;
@property (nonatomic, retain) UITextView *descriptionLabel;

@end
