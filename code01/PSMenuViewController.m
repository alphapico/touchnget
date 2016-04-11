//
//  PSMenuViewController.m
//  code01
//
//  Created by Muhamad Hisham Wahab on 2/14/13.
//  Copyright (c) 2013 Muhamad Hisham Wahab. All rights reserved.
//

#import "PSMenuViewController.h"
#import "TBXML.h"
#import "PSCommonCode.h"
#import "PSWebClient.h"
#import "TFHpple.h"
#import "NSString+HTML.h"

//DTCoreText
#import "DTAttributedTextView.h"
#import "DTAttributedTextContentView.h"
#import "NSAttributedString+HTML.h"
#import "DTTextAttachment.h"
#import "DTLinkButton.h"
#import "DTLazyImageView.h"

#import <QuartzCore/QuartzCore.h>
#import <MediaPlayer/MediaPlayer.h>

@interface PSMenuViewController ()

//DTCoreText
- (void)_segmentedControlChanged:(id)sender;
- (void)linkPushed:(DTLinkButton *)button;
- (void)linkLongPressed:(UILongPressGestureRecognizer *)gesture;
- (void)debugButton:(UIBarButtonItem *)sender;

//DTCoreText
@property (nonatomic, retain) NSMutableSet *mediaPlayers;

@end

@implementation PSMenuViewController

@synthesize rssTableView = _rssTableView;
@synthesize parseFormatter, xmlData, rssConnection;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        
        //DTCoreText register notifications 
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(lazyImageDidFinishLoading:) name:@"DTLazyImageViewDidFinishLoading" object:nil];
    }
    return self;
}

//DTCoreText
- (void)loadView {
	[super loadView];
	
	CGRect frame = CGRectMake(0.0, 0.0, self.view.frame.size.width, self.view.frame.size.height);
	
	// Create data view
	_dataView = [[UITextView alloc] initWithFrame:frame];
	_dataView.editable = NO;
	_dataView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	[self.view addSubview:_dataView];
	
	// Create chars view
	_charsView = [[UITextView alloc] initWithFrame:frame];
	_charsView.editable = NO;
	_charsView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	[self.view addSubview:_charsView];
	
	// Create range view
	_rangeView = [[UITextView alloc] initWithFrame:frame];
	_rangeView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	_rangeView.editable = NO;
	[self.view addSubview:_rangeView];
	
	// Create text view
	[DTAttributedTextContentView setLayerClass:[CATiledLayer class]];
	_textView = [[DTAttributedTextView alloc] initWithFrame:frame];
	_textView.textDelegate = self;
	_textView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	[self.view addSubview:_textView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    //[self requestBMHarakahRSS];
    //[self requestBMHarakahHTML];
    //NSURL *url = [NSURL URLWithString:@"http://bm.harakahdaily.net/index.php/berita-utama?format=feed&type=rss"];
    //[self downloadAndParse:url];
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
    //DTCoreText
    CGRect bounds = self.view.bounds;
    _textView.frame = CGRectMake(10, bounds.origin.y, 300, bounds.size.height); //bounds;
    [_textView setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)]; //44
    [_textView setScrollIndicatorInsets:UIEdgeInsetsMake(0, 0, 0, 0)]; //44
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	
    
    //DTCoreText
	// now the bar is up so we can autoresize again
	_textView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	
	// fill other tabs
	// Create range view
	NSMutableString *dumpOutput = [[NSMutableString alloc] init];
	NSDictionary *attributes = nil;
	NSRange effectiveRange = NSMakeRange(0, 0);
	
	if ([_textView.attributedString length])
	{
		while ((attributes = [_textView.attributedString attributesAtIndex:effectiveRange.location effectiveRange:&effectiveRange]))
		{
			[dumpOutput appendFormat:@"Range: (%d, %d), %@\n\n", effectiveRange.location, effectiveRange.length, attributes];
			effectiveRange.location += effectiveRange.length;
			
			if (effectiveRange.location >= [_textView.attributedString length])
			{
				break;
			}
		}
	}
	_rangeView.text = dumpOutput;
	
	
	// Create characters view
	[dumpOutput setString:@""];
	NSData *dump = [[_textView.attributedString string] dataUsingEncoding:NSUTF8StringEncoding];
	for (NSInteger i = 0; i < [dump length]; i++)
	{
		char *bytes = (char *)[dump bytes];
		char b = bytes[i];
		
		[dumpOutput appendFormat:@"%x %c\n", b, b];
	}
	_charsView.text = dumpOutput;
	[dumpOutput release];
}

- (void)viewWillDisappear:(BOOL)animated;
{
	//DTCoreText
	// stop all playing media
	for (MPMoviePlayerController *player in self.mediaPlayers)
	{
		[player stop];
	}
	
	[super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return (toInterfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Networking action

-(void)requestBMHarakahRSS
{
    NSURL *url = [NSURL URLWithString:@"http://bm.harakahdaily.net/index.php/berita-utama?format=feed&type=rss"];
    NSURLRequest *request  = [NSURLRequest requestWithURL:url];
    
    AFHTTPRequestOperation *operationHttp =
    [[PSWebClient sharedClient] HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         //http://www.w3schools.com/xpath/xpath_syntax.asp
         //http://stackoverflow.com/questions/9746745/xpath-attributes-selection
         //http://stackoverflow.com/questions/6310773/nsstring-with-some-html-tags-how-can-i-search-for-img-tag-and-get-the-content
         
         //NSString *responseHTML = [[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding] autorelease];
         
         TFHpple *xmlParser = [TFHpple hppleWithXMLData:responseObject];
         NSString *itemXpathQuery = @"//item"; 
         NSArray *itemsNodes = [xmlParser searchWithXPathQuery:itemXpathQuery];
         
         for (TFHppleElement *element in itemsNodes) {
             
             for (TFHppleElement *childElement in element.children) {
                 
                 if (![childElement.tagName isEqualToString:@"text"]) {
                     NSLog(@"%@", childElement.tagName);
                     
                     if ([childElement.tagName isEqualToString:@"description"]) {
                         
                         NSString *url = nil;
                         NSScanner *theScanner = [NSScanner scannerWithString:[[childElement firstChild] content]];
                         [theScanner scanUpToString:@"<img" intoString:nil];
                         
                         if (![theScanner isAtEnd]) {
                             [theScanner scanUpToString:@"src" intoString:nil];
                             NSCharacterSet *charset = [NSCharacterSet characterSetWithCharactersInString:@"\"'"];
                             [theScanner scanUpToCharactersFromSet:charset intoString:nil];
                             [theScanner scanCharactersFromSet:charset intoString:nil];
                             [theScanner scanUpToCharactersFromSet:charset intoString:&url];
                             // "url" now contains the URL of the img
                         }
                         
                         NSLog(@"URL: %@", url);
                         
                     }else{
                         NSLog(@"%@", [[childElement firstChild] content]);
                     }
                     
                 }
                 
             }
         }
         
         
     }
     failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"Response StatusCode: %d", [(NSHTTPURLResponse *)[operation response] statusCode]);
         NSLog(@"Operation Error: %@", error.localizedDescription);
     }];
    
    [[PSWebClient sharedClient] enqueueHTTPRequestOperation:operationHttp];
}

-(void)requestBMHarakahHTML
{
    NSURL *url = [NSURL URLWithString:@"http://bm.harakahdaily.net/index.php/berita-utama/16888-umno-bawa-4m-ke-penempatan-orang-asal"];
    //:@"http://bm.harakahdaily.net/index.php/berita-utama/16872-ribuan-sambut-kepulangan-tok-guru-nik-aziz"
    
    NSURLRequest *request  = [NSURLRequest requestWithURL:url];
    
    AFHTTPRequestOperation *operationHttp =
    [[PSWebClient sharedClient] HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         //DTCoreText
         // Create attributed string from HTML
         NSString *responseHTML = [[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding] autorelease];
         
         NSString *stripHTML = nil;
         NSScanner *theScanner = [NSScanner scannerWithString:responseHTML];
         [theScanner scanUpToString:@"<div id=\"main-content\">" intoString:nil];
         if (![theScanner isAtEnd]) {
             [theScanner scanUpToString:@"<h1 class=\"contentheading\">" intoString:nil];
             if (![theScanner isAtEnd]) {
                 NSLog(@"Crazy");
                 [theScanner scanUpToString:@"<div id=\"komen\">" intoString:&stripHTML]; //@"<div id=\"komen\">"
             }
             
         }
         //NSLog(@"%@", stripHTML);
         NSString *extendedStringHTML = [NSString stringWithFormat:@"<html><head></head><body>%@</body></html>", stripHTML];
         
         //NSString *entityHTML = [responseHTML stringByReplacingHTMLEntities];
         NSData *dataHTML = [extendedStringHTML dataUsingEncoding:NSUTF8StringEncoding];
         
         NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:1.4], NSTextSizeMultiplierDocumentOption, @"Times New Roman", DTDefaultFontFamily,  @"black", DTDefaultLinkColor,  nil]; // @"green",DTDefaultTextColor, [NSValue valueWithCGSize:CGSizeMake(260, 100)]  , DTMaxImageSize,
         
         NSAttributedString *string = [[NSAttributedString alloc] initWithHTML:dataHTML options:options documentAttributes:NULL];
         
         // Display string
         _textView.contentView.edgeInsets = UIEdgeInsetsMake(10, 0, 0, 0); //UIEdgeInsetsMake(10, 10, 10, 10);
         _textView.attributedString = string;
         
         // Data view
         _dataView.text = [responseObject description];
         
         [string release];
         
         
         
         
         //NSString *HTMLTagss = @"<img[^>]*>"; //regex to remove img tag
         //NSString *stringWithoutImage = [responseHTML stringByReplacingOccurrencesOfRegex:HTMLTagss withString:@""];
         
//         TFHpple *htmlParser = [TFHpple hppleWithHTMLData:dataHTML];
//         NSString *contentXpathQuery = @"//div[@class='text-article']/p/text()";
//         //@"//div[@class='text-article']/p/text()"
//         NSArray *contentNodes = [htmlParser searchWithXPathQuery:contentXpathQuery];
//         
//         
//         
//         for (TFHppleElement *contentElement in contentNodes) {
//             
//             //ignore &nbsp
//             //http://stackoverflow.com/questions/2522393/incomplete-universal-character-name-with-stringwithutf8string
//             if (![[contentElement content] isEqualToString:@"\u00a0"])
//             {
//                 NSLog(@"%@", [contentElement content]);
//             }
//             
//             /*
//             for (TFHppleElement *pElement in contentElement.children) {
//                 if ([pElement.tagName isEqualToString:@"p"]) {
//                     
//                     if ([[[pElement firstChild] content] isEqual:[NSNull null]] || [[[pElement firstChild] content] isEqualToString:@" "]) {
//                         
//                         for (TFHppleElement *subPElement in pElement.children) {
//                             NSLog(@"Sub : %@", subPElement.description);
//                         }
//                         
//                     }else{
//                         NSLog(@"%@", [[pElement firstChild] content]);
//                     }
//                     
//                     
//                 }
//             
//             }*/
//         }
         
     }
     failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"Response StatusCode: %d", [(NSHTTPURLResponse *)[operation response] statusCode]);
         NSLog(@"Operation Error: %@", error.localizedDescription);
     }];
    
    [[PSWebClient sharedClient] enqueueHTTPRequestOperation:operationHttp];
}

-(NSString *) stringByStrippingHTML:(NSString *)s
{
    NSRange r;
    while ((r = [s rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound)
        s = [s stringByReplacingCharactersInRange:r withString:@""];
    return s;
}


#pragma mark - Alpha Action

- (void)downloadAndParse:(NSURL *)url {
    
    done = NO;
    self.parseFormatter = [[NSDateFormatter alloc] init];
    [parseFormatter setDateStyle:NSDateFormatterLongStyle];
    [parseFormatter setTimeStyle:NSDateFormatterNoStyle];
    // necessary because iTunes RSS feed is not localized, so if the device region has been set to other than US
    // the date formatter must be set to US locale in order to parse the dates
    [parseFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en-MY"]];
    self.xmlData = [NSMutableData data];
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    NSURLRequest *theRequest = [NSURLRequest requestWithURL:url];
    // create the connection with the request and start loading the data
    rssConnection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    if (rssConnection != nil) {
        do {
            [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
        } while (!done);
    }
    
    self.rssConnection = nil;
    self.parseFormatter = nil;
    
}

#pragma mark NSURLConnection Delegate methods

/*
 Disable caching so that each time we run this app we are starting with a clean slate. You may not want to do this in your application.
 */
- (NSCachedURLResponse *)connection:(NSURLConnection *)connection willCacheResponse:(NSCachedURLResponse *)cachedResponse {
    return nil;
}

// Forward errors to the delegate.
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    done = YES;
    NSLog(@"Error: %@", error.localizedDescription);
}

// Called when a chunk of data has been downloaded.
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    // Append the downloaded chunk of data.
    [xmlData appendData:data];
}

static NSString *kRSS_Channel = @"channel";
static NSString *kRSS_Item = @"item";
static NSString *kRSS_Title= @"title";

#pragma mark NSURLConnectionDataDelegate
-(void)connectionDidFinishLoading:(NSURLConnection *)connection{
    NSError *error;
    TBXML * tbxml = [[TBXML alloc] initWithXMLData:xmlData error:&error];
    TBXMLElement *root = tbxml.rootXMLElement;
    if (root) {
        
        nTrack = 0;
        [self traverseElement:root];
//        TBXMLElement * channel = [TBXML childElementNamed:kRSS_Channel parentElement:root];
//        if (channel) {
//            TBXMLElement *item = [TBXML childElementNamed:kRSS_Item parentElement:channel];
//            while (item != nil) {
//                TBXMLElement *title = [TBXML childElementNamed:kRSS_Title parentElement:item];
//                if (title != nil) {
//                    NSLog(@"%@", [TBXML textForElement:title]);
//                }
//                
//                item = [TBXML nextSiblingNamed:kRSS_Item searchFromElement:item];
//            }
//            
//        }
    }
}

-(void)traverseElement:(TBXMLElement *)element ByQuery:(NSString *)szQuery{
    // error var
    __block NSError *error = nil;
    
    [TBXML iterateElementsForQuery:@"item" fromElement:element withBlock:^(TBXMLElement *anElement) {
        
        // get the name of the current element
        NSString * name = [TBXML elementName:anElement error:&error];
        
        // if an error occured, log it
        if (error) {
            NSLog(@"Error! %@ %@", [error localizedDescription], [error userInfo]);
        } else {
            // log the element name and "name" attribute
            NSLog(@"Author Name:%@", name);
            NSLog(@"Author Name:%@", [TBXML valueOfAttributeNamed:@"name" forElement:anElement]);
        }
    }];
}

-(void)traverseElement:(TBXMLElement *)element {
    
    __block NSError *error = nil;
	
	do {
		// Display the name of the element
		NSLog(@"[%d] %@", nTrack++ ,[TBXML elementName:element]);
        
        if (element->parentElement) {
            TBXMLElement *elementValue = [TBXML childElementNamed:[TBXML elementName:element] parentElement:element->parentElement error:&error];
            if (error) {
                NSLog(@"Error: %@" , error.localizedDescription);
            }else{
                if ([[TBXML elementName:element] isEqualToString:@"description"]) {
                    
                    NSLog(@"%@", [TBXML textForElement:elementValue] );
                }else{
                    NSLog(@"%@", [TBXML textForElement:elementValue] );
                }
            
                
            }
        }
        
        
        // iterate all child elements of tbxml.rootXMLElement that are named "author"
//        [TBXML iterateAttributesOfElement:element withBlock:^(TBXMLAttribute *attribute, NSString *name, NSString *value) {
//            
//            // Display name and value of attribute to the log window
//			NSLog(@"[%d] %@->%@ = %@", nTrack ,[TBXML elementName:element], name, value);
//        }];
		
		// if the element has child elements, process them
		if (element->firstChild) [self traverseElement:element->firstChild];
        
        // Obtain next sibling element
	} while ((element = element->nextSibling));
}

-(void)traverseElementOld:(TBXMLElement *)element {
    
    do {
        // Display the name of the element
        NSLog(@"%@",[TBXML elementName:element]);
        
        // Obtain first attribute from element
        TBXMLAttribute * attribute = element->firstAttribute;
        
        // if attribute is valid
        while (attribute) {
            // Display name and value of attribute to the log window
            NSLog(@"%@->%@ = %@",  [TBXML elementName:element],
                  [TBXML attributeName:attribute],
                  [TBXML attributeValue:attribute]);
            
            // Obtain the next attribute
            attribute = attribute->next;
        }
        
        // if the element has child elements, process them
        if (element->firstChild)
            [self traverseElement:element->firstChild];
        
        // Obtain next sibling element
    } while ((element = element->nextSibling));  
}



#pragma mark Private Methods

- (void)_segmentedControlChanged:(id)sender {
	UIScrollView *selectedView = _textView;
	
	switch (_segmentedControl.selectedSegmentIndex) {
		case 1:
			selectedView = _rangeView;
			break;
		case 2:
			selectedView = _charsView;
			break;
		case 3:
			selectedView = _dataView;
			break;
	}
	
	[self.view bringSubviewToFront:selectedView];
	[selectedView flashScrollIndicators];
}


#pragma mark Custom Views on Text
- (UIView *)attributedTextContentView:(DTAttributedTextContentView *)attributedTextContentView viewForLink:(NSURL *)url identifier:(NSString *)identifier frame:(CGRect)frame
{
	DTLinkButton *button = [[[DTLinkButton alloc] initWithFrame:frame] autorelease];
	button.url = url;
	button.minimumHitSize = CGSizeMake(25, 25); // adjusts it's bounds so that button is always large enough
	button.guid = identifier;
	
	// use normal push action for opening URL
	[button addTarget:self action:@selector(linkPushed:) forControlEvents:UIControlEventTouchUpInside];
	
	// demonstrate combination with long press
	UILongPressGestureRecognizer *longPress = [[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(linkLongPressed:)] autorelease];
	[button addGestureRecognizer:longPress];
	
	return button;
}

- (UIView *)attributedTextContentView:(DTAttributedTextContentView *)attributedTextContentView viewForAttachment:(DTTextAttachment *)attachment frame:(CGRect)frame
{
	if (attachment.contentType == DTTextAttachmentTypeVideoURL)
	{
		NSURL *url = (id)attachment.contentURL;
		
		// we could customize the view that shows before playback starts
		UIView *grayView = [[[UIView alloc] initWithFrame:frame] autorelease];
		grayView.backgroundColor = [UIColor blackColor];
		
		MPMoviePlayerController *player =[[[MPMoviePlayerController alloc] initWithContentURL:url] autorelease];
		
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_4_2
		NSString *airplayAttr = [attachment.attributes objectForKey:@"x-webkit-airplay"];
		if ([airplayAttr isEqualToString:@"allow"])
		{
			if ([player respondsToSelector:@selector(setAllowsAirPlay:)])
			{
				player.allowsAirPlay = YES;
			}
		}
#endif
		
		NSString *controlsAttr = [attachment.attributes objectForKey:@"controls"];
		if (controlsAttr)
		{
			player.controlStyle = MPMovieControlStyleEmbedded;
		}
		else
		{
			player.controlStyle = MPMovieControlStyleNone;
		}
		
		NSString *loopAttr = [attachment.attributes objectForKey:@"loop"];
		if (loopAttr)
		{
			player.repeatMode = MPMovieRepeatModeOne;
		}
		else
		{
			player.repeatMode = MPMovieRepeatModeNone;
		}
		
		NSString *autoplayAttr = [attachment.attributes objectForKey:@"autoplay"];
		if (autoplayAttr)
		{
			player.shouldAutoplay = YES;
		}
		else
		{
			player.shouldAutoplay = NO;
		}
		
		[player prepareToPlay];
		[self.mediaPlayers addObject:player];
		
		player.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		player.view.frame = grayView.bounds;
		[grayView addSubview:player.view];
		
		return grayView;
	}
	else if (attachment.contentType == DTTextAttachmentTypeImage)
	{
		// if the attachment has a hyperlinkURL then this is currently ignored
		DTLazyImageView *imageView = [[[DTLazyImageView alloc] initWithFrame:frame] autorelease];
		if (attachment.contents)
		{
			imageView.image = attachment.contents;
		}
		
		// url for deferred loading
		imageView.url = attachment.contentURL;
		
		return imageView;
	}
	
	return nil;
}


#pragma mark Actions

- (void)linkPushed:(DTLinkButton *)button
{
	[[UIApplication sharedApplication] openURL:[button.url absoluteURL]];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (buttonIndex != actionSheet.cancelButtonIndex)
	{
		[[UIApplication sharedApplication] openURL:[self.lastActionLink absoluteURL]];
	}
}

- (void)linkLongPressed:(UILongPressGestureRecognizer *)gesture
{
	if (gesture.state == UIGestureRecognizerStateBegan)
	{
		DTLinkButton *button = (id)[gesture view];
		button.highlighted = NO;
		self.lastActionLink = button.url;
		
		if ([[UIApplication sharedApplication] canOpenURL:[button.url absoluteURL]])
		{
			UIActionSheet *action = [[[UIActionSheet alloc] initWithTitle:[[button.url absoluteURL] description] delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Open in Safari", nil] autorelease];
			[action showFromRect:button.frame inView:button.superview animated:YES];
		}
	}
}

- (void)debugButton:(UIBarButtonItem *)sender
{
	_textView.contentView.drawDebugFrames = !_textView.contentView.drawDebugFrames;
	[DTCoreTextLayoutFrame setShouldDrawDebugFrames:_textView.contentView.drawDebugFrames];
	[self.view setNeedsDisplay];
}

#pragma mark Notifications
- (void)lazyImageDidFinishLoading:(NSNotification *)notification
{
	NSDictionary *userInfo = [notification userInfo];
	NSURL *url = [userInfo objectForKey:@"ImageURL"];
	CGSize imageSize = [[userInfo objectForKey:@"ImageSize"] CGSizeValue];
	
	NSPredicate *pred = [NSPredicate predicateWithFormat:@"contentURL == %@", url];
	
	// update all attachments that matchin this URL (possibly multiple images with same size)
	for (DTTextAttachment *oneAttachment in [_textView.contentView.layoutFrame textAttachmentsWithPredicate:pred])
	{
		oneAttachment.originalSize = imageSize;
		
		if (!CGSizeEqualToSize(imageSize, oneAttachment.displaySize))
		{
			oneAttachment.displaySize = imageSize;
		}
	}
	
	// redo layout
	// here we're layouting the entire string, might be more efficient to only relayout the paragraphs that contain these attachments
	[_textView.contentView relayoutText];
}

#pragma mark Properties

- (NSMutableSet *)mediaPlayers
{
	if (!mediaPlayers)
	{
		mediaPlayers = [[NSMutableSet alloc] init];
	}
	
	return mediaPlayers;
}

@synthesize fileName = _fileName;
@synthesize lastActionLink;
@synthesize mediaPlayers;
@synthesize baseURL;


@end
