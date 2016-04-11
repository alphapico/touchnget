//
//  PSRSSCell.m
//  code01
//
//  Created by Muhamad Hisham Wahab on 3/22/13.
//  Copyright (c) 2013 Muhamad Hisham Wahab. All rights reserved.
//

#import "PSRSSCell.h"

@implementation PSRSSCell

@synthesize imgView,publishedDate, title;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)dealloc
{
    self.imgView = nil;
    self.publishedDate = nil;
    self.title = nil;
    
    [super dealloc];
}


-(void)layoutSubviews
{
    [super layoutSubviews];
    
    self.imgView.frame = CGRectMake(10, 8, 80, 80);
    float imgWidth = self.imgView.image.size.width;
    if (imgWidth > 0) {
        //do nothing, i can move text label somewhere else also
    }
}

@end
