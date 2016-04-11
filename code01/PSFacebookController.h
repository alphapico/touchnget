//
//  PSFacebookController.h
//  code01
//
//  Created by Muhamad Hisham Wahab on 4/3/13.
//  Copyright (c) 2013 Muhamad Hisham Wahab. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PSFacebookWebController;

@interface PSFacebookController : UIViewController<UITableViewDataSource, UITableViewDelegate>{

}

@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) PSFacebookWebController *webController;

@end
