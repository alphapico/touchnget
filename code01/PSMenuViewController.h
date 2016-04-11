//
//  PSMenuViewController.h
//  code01
//
//  Created by Muhamad Hisham Wahab on 2/14/13.
//  Copyright (c) 2013 Muhamad Hisham Wahab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DTAttributedTextView.h"

@interface PSMenuViewController : UIViewController<NSURLConnectionDelegate, NSURLConnectionDataDelegate, UIActionSheetDelegate, DTAttributedTextContentViewDelegate /*, UITableViewDataSource, UITableViewDelegate*/>{
    
    //TBXML
    BOOL done;
    int nTrack;
    
    //DTCoreText
    NSString *_fileName;
	UISegmentedControl *_segmentedControl;
	DTAttributedTextView *_textView;
	UITextView *_rangeView;
	UITextView *_charsView;
	UITextView *_dataView;
	NSURL *baseURL;
	// private
	NSURL *lastActionLink;
	NSMutableSet *mediaPlayers;
}

//TBXML
@property (nonatomic, strong) NSDateFormatter *parseFormatter;
@property (nonatomic, strong) NSMutableData *xmlData;
@property (nonatomic, strong) NSURLConnection *rssConnection;

//DTCoreText
@property (nonatomic, retain) NSString *fileName;
@property (nonatomic, retain) NSURL *lastActionLink;
@property (nonatomic, retain) NSURL *baseURL;

@property (nonatomic, strong) IBOutlet UITableView *rssTableView;


@end
