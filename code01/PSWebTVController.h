//
//  PSWebTVController.h
//  code01
//
//  Created by Muhamad Hisham Wahab on 4/16/13.
//  Copyright (c) 2013 Muhamad Hisham Wahab. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PSWebTVWebViewController;

@interface PSWebTVController : UIViewController<UITableViewDataSource, UITableViewDelegate>{

    
}

@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) PSWebTVWebViewController *webController;

//test
//@property (nonatomic, strong) NSMutableArray *tableViewData;
@property (nonatomic, strong) NSIndexPath *selectedIndexPath;

@end

//Effect like tweetbot
//http://stackoverflow.com/questions/9227359/customized-tableview-a-la-tweetbot