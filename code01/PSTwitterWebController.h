//
//  PSTwitterWebController.h
//  code01
//
//  Created by Muhamad Hisham Wahab on 4/4/13.
//  Copyright (c) 2013 Muhamad Hisham Wahab. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PSTwitterWebController : UIViewController<UIWebViewDelegate>{
    BOOL isProgressHUDDismiss;
}

@property(nonatomic, strong) NSURL *urlNews;
@property(nonatomic, strong) IBOutlet UIWebView *webView;

//In case web can't scroll till the bottom
//http://stackoverflow.com/questions/10718903/uiwebview-does-not-scroll-till-bottom

@end
