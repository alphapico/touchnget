//
//  PSKenaliPasWebController.h
//  code01
//
//  Created by Muhamad Hisham Wahab on 3/28/13.
//  Copyright (c) 2013 Muhamad Hisham Wahab. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PSKenaliPasWebController : UIViewController<UIWebViewDelegate>{

    BOOL isProgressHUDDismiss;
}

@property(nonatomic, copy) NSString *urlWebStr;
@property(nonatomic, strong) IBOutlet UIWebView *webView;
@property (nonatomic, strong) NSNumber *webType;

@end

//In case web can't scroll till the bottom
//http://stackoverflow.com/questions/10718903/uiwebview-does-not-scroll-till-bottom