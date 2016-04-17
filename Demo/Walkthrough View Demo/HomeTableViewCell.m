//
//  HomeTableViewCell.m
//  Walkthrough View Demo
//
//  Created by Praagya Joshi on 17/04/16.
//  Copyright © 2016 Praagya Joshi. All rights reserved.
//

#import "HomeTableViewCell.h"

@implementation HomeTableViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createViews];
    }
    return self;
}

- (void) createViews {
    
    _cellBackgroundView = [[UIView alloc] init];
    [_cellBackgroundView setBackgroundColor:[UIColor whiteColor]];
    [_cellBackgroundView.layer setMasksToBounds:YES];
    [_cellBackgroundView.layer setCornerRadius:3.0f];
    [_cellBackgroundView.layer setBorderColor:[[[UIColor blackColor] colorWithAlphaComponent:0.2f] CGColor]];
    [_cellBackgroundView.layer setBorderWidth:1.0f];
    
    _cellImageView = [[UIImageView alloc] init];
    [_cellImageView setContentMode:UIViewContentModeScaleAspectFill];
    [_cellImageView.layer setMasksToBounds:YES];
    
    _descriptionLabel = [[UILabel alloc] init];
    [_descriptionLabel setFont:[UIFont systemFontOfSize:14]];
    [_descriptionLabel setNumberOfLines:1];
    [_descriptionLabel setLineBreakMode:NSLineBreakByTruncatingTail];
    
    [_cellBackgroundView addSubview:_cellImageView];
    [_cellBackgroundView addSubview:_descriptionLabel];
    [self.contentView addSubview:_cellBackgroundView];
}

- (void) layoutSubviews {
    
    [super layoutSubviews];
    
    CGFloat cellWidth = self.bounds.size.width;
    CGFloat cellHeight = self.bounds.size.height;
    
    [_cellBackgroundView setFrame:CGRectMake(15.0f, 15.0f, cellWidth - 2 * 15.0f, cellHeight - 2 * 15.0f)];
    [_cellImageView setFrame:CGRectMake(0, 0, _cellBackgroundView.frame.size.width, 130.0f)];
    [_descriptionLabel setFrame:CGRectMake(10.0f, _cellImageView.frame.size.height + 3.0f, _cellBackgroundView.frame.size.width - 2 * 10.0f, 17.0f)];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
