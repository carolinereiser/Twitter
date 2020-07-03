//
//  TimelineViewController.m
//  twitter
//
//  Created by emersonmalca on 5/28/18.
//  Copyright © 2018 Emerson Malca. All rights reserved.
//

#import "APIManager.h"
#import "AppDelegate.h"
#import "ComposeViewController.h"
#import "DateTools.h"
#import "DetailsViewController.h"
#import "LoginViewController.h"
#import "ProfileViewController.h"
#import "ResponsiveLabel.h"
#import "TimelineViewController.h"
#import "TweetCell.h"
#import "UIImageView+AFNetworking.h"
#import "User.h"
#import "Tweet.h"


@interface TimelineViewController () <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>
 
@end

//static const NSString *kTweetCellIdentifier = @"TweetCell";

@implementation TimelineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    // Get timeline
    [self fetchTweets];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(fetchTweets) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];
}

-(void)fetchTweets {
    [[APIManager shared] getHomeTimelineWithCompletion:^(NSMutableArray *tweets, NSError *error) {
        if (tweets) {
            NSLog(@"😎😎😎 Successfully loaded home timeline");
            self.tweetList = tweets;
            [self.tableView reloadData];
            self.isMoreDataLoading = false;
    } else{
            NSLog(@"😫😫😫 Error getting home timeline: %@", error.localizedDescription);
        }
    }];
    [self.refreshControl endRefreshing];
} 

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tweetList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TweetCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"TweetCell" forIndexPath:indexPath];
    cell.profilePic.tag = indexPath.row;

    //get the tweet from the query
    cell.tweet = self.tweetList[indexPath.row];
    
    return cell;
}

- (IBAction)logout:(id)sender {
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    appDelegate.window.rootViewController = loginViewController;
}

- (void)didTweet:(nonnull Tweet *)tweet {
    [self.tweetList insertObject:tweet atIndex:0];
    [self.tableView reloadData];
}

- (void)fetchMoreTweets
{
     [[APIManager shared] getMoreTweets:self.tweetList[[self.tweetList count]-1].idStr withCompletion:^(NSMutableArray *tweets, NSError *error) {
        if (tweets) {
            NSLog(@"😎😎😎 Successfully loaded more");
            [self.tweetList addObjectsFromArray:tweets];
            [self.tableView reloadData];
            self.isMoreDataLoading = false;
    } else{
            NSLog(@"😫😫😫 Error getting more: %@", error.localizedDescription);
        }
    }];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
     // Handle scroll behavior here
    if(!self.isMoreDataLoading){
       if(!self.isMoreDataLoading){
           // Calculate the position of one screen length before the bottom of the results
           int scrollViewContentHeight = self.tableView.contentSize.height;
           int scrollOffsetThreshold = scrollViewContentHeight - self.tableView.bounds.size.height;
           
           // When the user has scrolled past the threshold, start requesting
           if(scrollView.contentOffset.y > scrollOffsetThreshold && self.tableView.isDragging) {
               self.isMoreDataLoading = true;
               [self fetchMoreTweets];
           }
       }
    }
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([[segue identifier] isEqualToString:@"composeTweet"])
    {
        UINavigationController *navigationController = [segue destinationViewController];
        ComposeViewController *composeController = (ComposeViewController*)navigationController.topViewController;
        composeController.delegate = self;
    }
    else if([[segue identifier] isEqualToString:@"details"])
    {
        
        UITableViewCell *tappedCell = sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:tappedCell];
        Tweet* tweet = self.tweetList[indexPath.row];
        DetailsViewController *detailsViewController = [segue destinationViewController];
        detailsViewController.tweet = tweet;
    }
    else if([[segue identifier] isEqualToString:@"replySegue"])
    {
        UITableViewCell *tappedCell = sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:tappedCell];
        Tweet* tweet = self.tweetList[indexPath.row];
        UINavigationController *navigationController = [segue destinationViewController];
        ComposeViewController *composeController = (ComposeViewController*)navigationController.topViewController;
        composeController.isReply = YES;
        composeController.replyUserName = tweet.user.name;
        composeController.replyId = tweet.idStr;
    }
    else if([[segue identifier] isEqualToString:@"profileSegue"])
    {
        UIButton *tappedButton = sender;
        Tweet* tweet = self.tweetList[tappedButton.tag];
        User* user = tweet.user;
        ProfileViewController *profileViewController = [segue destinationViewController];
        profileViewController.user = user;
    }

}

@end
