//
//  PSBeritaRSSController.h
//  code01
//
//  Created by Muhamad Hisham Wahab on 3/22/13.
//  Copyright (c) 2013 Muhamad Hisham Wahab. All rights reserved.
//

#import <UIKit/UIKit.h>


@class PSBeritaWebViewController;

@interface PSBeritaRSSController : UIViewController<UITableViewDelegate, UITableViewDataSource>{

}

@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) PSBeritaWebViewController *beritaWebController;
@property (nonatomic, strong) NSURL *urlRSS;
@property (nonatomic, strong) NSNumber *rssType;

@end
