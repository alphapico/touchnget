//
//  PSExtraController.h
//  code01
//
//  Created by Muhamad Hisham Wahab on 4/4/13.
//  Copyright (c) 2013 Muhamad Hisham Wahab. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PSExtraSubMenuController;

@interface PSExtraController : UIViewController<UITableViewDelegate, UITableViewDataSource>{

}

@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) PSExtraSubMenuController *subMenuController;

@end
//touchnget@pas.org.my
//Subject: Maklumbalas: PAS Touch 'n Get