//
//  PSExtraSubMenuController.h
//  code01
//
//  Created by Muhamad Hisham Wahab on 4/4/13.
//  Copyright (c) 2013 Muhamad Hisham Wahab. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PSExtraWebController;

@interface PSExtraSubMenuController : UIViewController<UITableViewDelegate, UITableViewDataSource>{

}

@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, copy) NSString *subMenu;
@property (nonatomic, strong) PSExtraWebController *webController;

@end
