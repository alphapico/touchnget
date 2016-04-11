//
//  PSRSSCell.h
//  code01
//
//  Created by Muhamad Hisham Wahab on 3/22/13.
//  Copyright (c) 2013 Muhamad Hisham Wahab. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PSRSSCell : UITableViewCell{

}

@property (nonatomic, strong) IBOutlet UIImageView *imgView;
@property (nonatomic, strong) IBOutlet UILabel *title;
@property (nonatomic, strong) IBOutlet UILabel *publishedDate;

@end
