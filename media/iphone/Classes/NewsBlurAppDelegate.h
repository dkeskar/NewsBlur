//
//  NewsBlurAppDelegate.h
//  NewsBlur
//
//  Created by Samuel Clay on 6/16/10.
//  Copyright NewsBlur 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NewsBlurViewController;
@class FeedDetailViewController;
@class StoryDetailViewController;

@interface NewsBlurAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    UINavigationController *navigationController;
    NewsBlurViewController *feedsViewController;
    FeedDetailViewController *feedDetailViewController;
    StoryDetailViewController *storyDetailViewController;
    
    NSDictionary * activeFeed;
    NSArray * activeFeedStories;
    NSDictionary * activeStory;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, readonly, retain) IBOutlet UINavigationController *navigationController;
@property (nonatomic, retain) IBOutlet NewsBlurViewController *feedsViewController;
@property (nonatomic, retain) IBOutlet FeedDetailViewController *feedDetailViewController;
@property (nonatomic, retain) IBOutlet StoryDetailViewController *storyDetailViewController;

@property (readwrite, retain) NSDictionary * activeFeed;
@property (readwrite, retain) NSArray * activeFeedStories;
@property (readwrite, retain) NSDictionary * activeStory;

- (void)loadFeedDetailView;
- (void)loadStoryDetailView;
- (void)hideNavigationBar:(BOOL)animated;
- (void)showNavigationBar:(BOOL)animated;

@end

