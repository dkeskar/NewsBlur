//
//  FeedDetailViewController.m
//  NewsBlur
//
//  Created by Samuel Clay on 6/20/10.
//  Copyright 2010 NewsBlur. All rights reserved.
//

#import "FeedDetailViewController.h"
#import "NewsBlurAppDelegate.h"
#import "FeedDetailTableCell.h"
#import "JSON.h"

#define kTableViewRowHeight 55;

@implementation FeedDetailViewController

@synthesize storyTitlesTable, feedViewToolbar, feedScoreSlider;
@synthesize stories;
@synthesize appDelegate;
@synthesize jsonString;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    NSLog(@"Loaded Feed view: %@", appDelegate.activeFeed);
    
    [self fetchFeedDetail];
    
	[super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    //[appDelegate showNavigationBar:animated];
    
	[super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
    //NSLog(@"Unloading detail view: %@", self);
    self.appDelegate = nil;
    self.jsonString = nil;
}

- (void)dealloc {
    [appDelegate release];
    [stories release];
    [jsonString release];
    [super dealloc];
}

#pragma mark -
#pragma mark Initialization

- (void)fetchFeedDetail {
    if ([appDelegate.activeFeed objectForKey:@"id"] != nil) {
        NSString *theFeedDetailURL = [[NSString alloc] initWithFormat:@"http://www.newsblur.com/reader/load_single_feed/?feed_id=%@", 
                                      [appDelegate.activeFeed objectForKey:@"id"]];
        //NSLog(@"Url: %@", theFeedDetailURL);
        NSURL *urlFeedDetail = [NSURL URLWithString:theFeedDetailURL];
        [theFeedDetailURL release];
        jsonString = [[NSMutableData data] retain];
        NSURLRequest *request = [[NSURLRequest alloc] initWithURL: urlFeedDetail];
        NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
        [connection release];
        [request release];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [jsonString setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data 
{   
    [jsonString appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSString *jsonS = [[NSString alloc] 
                       initWithData:jsonString 
                       encoding:NSUTF8StringEncoding];
    NSDictionary *results = [[NSDictionary alloc] 
                             initWithDictionary:[jsonS JSONValue]];
	
    NSArray *storiesArray = [[NSArray alloc] 
                             initWithArray:[results objectForKey:@"stories"]];
    [appDelegate setActiveFeedStories:storiesArray];
    //NSLog(@"Stories: %d -- %@", [appDelegate.activeFeedStories count], [self storyTitlesTable]);
	[[self storyTitlesTable] reloadData];
    
    [storiesArray release];
    [results release];
    [jsonS release];
	[jsonString release];
}

- (void)connection:(NSURLConnection *)connection
  didFailWithError:(NSError *)error
{
    // release the connection, and the data object
    [connection release];
    // receivedData is declared as a method instance elsewhere
    [jsonString release];
    
    // inform the user
    NSLog(@"Connection failed! Error - %@ %@",
          [error localizedDescription],
          [[error userInfo] objectForKey:NSErrorFailingURLStringKey]);
}


#pragma mark -
#pragma mark Table View - Feed List

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //NSLog(@"Stories: %d", [appDelegate.activeFeedStories count]);
    return [appDelegate.activeFeedStories count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *FeedDetailCellIdentifier = @"FeedDetailCellIdentifier";
	
	FeedDetailTableCell *cell = (FeedDetailTableCell *)[tableView dequeueReusableCellWithIdentifier:FeedDetailCellIdentifier];
	if (cell == nil) {
		NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"FeedDetailTableCell"
                                                     owner:self
                                                   options:nil];
        for (id oneObject in nib) {
            if ([oneObject isKindOfClass:[FeedDetailTableCell class]]) {
                cell = (FeedDetailTableCell *)oneObject;
            }
        }
	}
    
    NSDictionary *story = [appDelegate.activeFeedStories objectAtIndex:indexPath.row];
    if ([[story objectForKey:@"story_authors"] class] != [NSNull class]) {
        cell.storyAuthor.text = [story objectForKey:@"story_authors"];
    } else {
        cell.storyAuthor.text = @"";
    }
    cell.storyTitle.text = [story objectForKey:@"story_title"];
    cell.storyDate.text = [story objectForKey:@"long_parsed_date"];
    cell.storyUnreadIndicator.image = [UIImage imageNamed:@"bullet_orange.png"];

	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [appDelegate setActiveStory:[[appDelegate activeFeedStories] objectAtIndex:indexPath.row]];
    NSLog(@"Active Story: %@", [appDelegate activeStory]);
	[appDelegate loadStoryDetailView];
	
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kTableViewRowHeight;
}

@end
