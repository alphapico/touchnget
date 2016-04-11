//
//  PSKenaliPasController.h
//  code01
//
//  Created by Muhamad Hisham Wahab on 3/27/13.
//  Copyright (c) 2013 Muhamad Hisham Wahab. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PSKenaliPasWebController;
@class PSVideoController;
@class PSKenaliPasSubMenuController;

@interface PSKenaliPasController : UIViewController<UITableViewDataSource, UITableViewDelegate>{

    
}

@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) PSKenaliPasWebController *kenaliPasWebController;
@property (nonatomic, strong) PSVideoController *videoController;
@property (nonatomic, strong) PSKenaliPasSubMenuController *subMenuController;

@end
