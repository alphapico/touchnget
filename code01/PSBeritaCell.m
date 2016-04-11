//
//  PSBeritaCell.m
//  code01
//
//  Created by Muhamad Hisham Wahab on 4/26/13.
//  Copyright (c) 2013 Muhamad Hisham Wahab. All rights reserved.
//

#import "PSBeritaCell.h"

@implementation PSBeritaCell

@synthesize title, imgView;

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
    self.title = nil;
    self.imgView = nil;
    
    [super dealloc];
}

@end
