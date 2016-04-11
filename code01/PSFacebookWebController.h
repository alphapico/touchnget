//
//  PSFacebookWebController.h
//  code01
//
//  Created by Muhamad Hisham Wahab on 4/3/13.
//  Copyright (c) 2013 Muhamad Hisham Wahab. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PSFacebookWebController : UIViewController<UIWebViewDelegate>{
    BOOL isProgressHUDDismiss;
}

@property(nonatomic, strong) NSURL *urlNews;
@property(nonatomic, strong) IBOutlet UIWebView *webView;

@end

//In case web can't scroll till the bottom
//http://stackoverflow.com/questions/10718903/uiwebview-does-not-scroll-till-bottom