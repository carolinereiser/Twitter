//
//  ProfileViewController.m
//  twitter
//
//  Created by Caroline Reiser on 7/1/20.
//  Copyright © 2020 Emerson Malca. All rights reserved.
//

#import "APIManager.h"
#import "ComposeViewController.h"
#import "DetailsViewController.h"
#import "ProfileViewController.h"
#import "TweetCell.h"
#import "UIImageView+AFNetworking.h"


@interface ProfileViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) NSMutableArray<Tweet *>* tweetList;
@property (weak, nonatomic) IBOutlet UITableView *tableView;


@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    if(!self.user)
    {
        [[APIManager shared] getCurrentUser:^(User* user, NSError* error){
            if(user)
            {
                NSLog(@"Got user credentials!");
                self.user = user;
                [self setUpUser];
                [self fetchTimeline];
            }
            else
            {
                NSLog(@"Error getting credentials: %@", error.localizedDescription);
            }
        }];
    }
    else
    {
        [self setUpUser];
        [self fetchTimeline];
    }
}

-(void) setUpUser
{
    // Do any additional setup after loading the view.
    NSURL *backgroundURL = [NSURL URLWithString:self.user.backgroundPic];
    //self.backgroundImage = nil;
    [self.backgroundImage setImageWithURL:backgroundURL];


    NSURL *profileURL = [NSURL URLWithString:self.user.profilePic];
    //self.profileImage = nil;
    [self.profileImage setImageWithURL:profileURL];

    self.username.text = self.user.name;
    self.screenname.text = [NSString stringWithFormat:@"@%@", self.user.screenName];
    self.bio.text = self.user.bio;
    self.followingCount.text = [self formatNumber:self.user.numFollowing];
    self.followerCount.text = [self formatNumber:self.user.numFollowers];
    self.tweetCount.text = [self formatNumber:self.user.numTweets];
    
    [self.followingCount sizeToFit];
    [self.followerCount sizeToFit];
    [self.tweetCount sizeToFit];
    [self.bio sizeToFit];
}

- (void) refreshData
{
    self.tweetCount.text = [self formatNumber:self.user.numTweets];
}

- (void) fetchTimeline
{
    [[APIManager shared] getUserTimeline:self.user.screenName completion:^(NSMutableArray* tweets, NSError* error){
        if(tweets)
        {
            self.tweetList = tweets;
            NSLog(@"Got tweets!");
            [self.tableView reloadData];
            self.isMoreDataLoading = false;
        }
        else
        {
            NSLog(@"Error getting tweets: %@", error.localizedDescription);
        }
    }];
    
}
- (NSString*) formatNumber:(int)num{
    //if had more time, figure out simpler way to do this
    if(num >= 10000 && num < 1000000)
    {
        int first = num / 1000;
        int second = num % 1000 / 1000;
        return [NSString stringWithFormat:@"%d.%dK", first, second];
    }
    else if(num >= 1000000 && num < 1000000000)
    {
        int first = num / 1000000;
        int second = num % 1000000 / 1000000;
        return [NSString stringWithFormat:@"%d.%dM", first, second];
    }
    else
    {
        return [NSString stringWithFormat:@"%d", num];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TweetCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"TweetCell" forIndexPath:indexPath];
    cell.profilePic.tag = indexPath.row;

    //get the tweet from the query
    cell.tweet = self.tweetList[indexPath.row];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tweetList.count;
}

- (void)didTweet:(nonnull Tweet *)tweet {
    [self.tweetList insertObject:tweet atIndex:0];
    [self.tableView reloadData];
    [self refreshData];
}





#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([[segue identifier] isEqualToString:@"replySegue"])
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

}


@end
