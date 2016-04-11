//
//  PSAktivitiController.h
//  code01
//
//  Created by Muhamad Hisham Wahab on 3/29/13.
//  Copyright (c) 2013 Muhamad Hisham Wahab. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PSAktivitiWebController;

@interface PSAktivitiController : UIViewController<UITableViewDataSource, UITableViewDelegate>{

}

@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) PSAktivitiWebController *webController;

@end
