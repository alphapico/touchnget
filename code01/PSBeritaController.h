//
//  PSBeritaController.h
//  code01
//
//  Created by Muhamad Hisham Wahab on 3/21/13.
//  Copyright (c) 2013 Muhamad Hisham Wahab. All rights reserved.
//

#import "PaperFoldMenuController.h"

@class PSBeritaRSSController;

@interface PSBeritaController : UIViewController<UITableViewDataSource, UITableViewDelegate>{

}

@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) PSBeritaRSSController *beritaRSSController;

@end
