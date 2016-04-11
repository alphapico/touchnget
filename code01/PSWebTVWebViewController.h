//
//  PSWebTVWebViewController.h
//  code01
//
//  Created by Muhamad Hisham Wahab on 4/23/13.
//  Copyright (c) 2013 Muhamad Hisham Wahab. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PSWebTVWebViewController : UIViewController<UIWebViewDelegate>{
    
    BOOL isProgressHUDDismiss;
}

@property(nonatomic, strong) NSURL *urlNews;
@property(nonatomic, strong) IBOutlet UIWebView *webView;

@end
