//
//  PSMenuCell.m
//  code01
//
//  Created by Muhamad Hisham Wahab on 3/21/13.
//  Copyright (c) 2013 Muhamad Hisham Wahab. All rights reserved.
//

#import "PSMenuCell.h"

@implementation PSMenuCell

@synthesize iconView, titleMenu;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
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
    self.iconView = nil;
    self.titleMenu = nil;
    
    [super dealloc];
}

@end
