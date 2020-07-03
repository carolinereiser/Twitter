//
//  DetailsViewController.m
//  twitter
//
//  Created by Caroline Reiser on 7/1/20.
//  Copyright © 2020 Emerson Malca. All rights reserved.
//

#import "APIManager.h"
#import "ComposeViewController.h"
#import "DetailsViewController.h"
#import "ProfileViewController.h"
#import "UIImageView+AFNetworking.h"


@interface DetailsViewController ()

@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSURL *profPicURL = [NSURL URLWithString:self.tweet.user.profilePic];
    
    UIImageView *imageView = [[UIImageView alloc] init];
    [imageView setImageWithURL:profPicURL];
    
    [self.profilePic setBackgroundImage:imageView.image forState:UIControlStateNormal];
    
    self.username.text = self.tweet.user.name;
    self.screenname.text = [NSString stringWithFormat:@"@%@", self.tweet.user.screenName];
    
    //FORMAT THIS BETTER
    self.datePosted.text = self.tweet.createdAtString;
    
    self.tweetText.text = self.tweet.text;
    
    self.numRetweets.text = [self formatNumber:self.tweet.retweetCount];
    self.numLikes.text = [self formatNumber:self.tweet.favoriteCount];
    
    [self.favoriteButton setImage:[UIImage imageNamed:@"favor-icon"] forState:UIControlStateNormal];
    [self.favoriteButton setImage:[UIImage imageNamed:@"favor-icon-red"] forState:UIControlStateSelected];
       
    [self.retweetButton setImage:[UIImage imageNamed:@"retweet-icon"] forState:UIControlStateNormal];
    [self.retweetButton setImage:[UIImage imageNamed:@"retweet-icon-green"] forState:UIControlStateSelected];
       
    self.retweetButton.selected = self.tweet.retweeted;
    self.favoriteButton.selected = self.tweet.favorited;
    
    [self.username sizeToFit];
    [self.screenname sizeToFit];
    [self.numRetweets sizeToFit];
    [self.numLikes sizeToFit];
    [self.tweetText sizeToFit];
    
}

- (void)refreshData{
    self.numLikes.text = [NSString stringWithFormat:@"%d", self.tweet.favoriteCount];
    
    self.numRetweets.text = [NSString stringWithFormat:@"%d", self.tweet.retweetCount];
    
}

- (IBAction)didTapRetweet:(id)sender {
    if(self.tweet.retweeted)
    {
        self.tweet.retweetCount -= 1;
        self.tweet.retweeted = NO;
        [[APIManager shared] unretweet:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if(error){
                 NSLog(@"Error unretweeting tweet: %@", error.localizedDescription);
            }
            else{
                NSLog(@"Successfully unretweeted the following Tweet: %@", tweet.text);
            }
        }];
    }
    else
    {
        self.tweet.retweetCount += 1;
        self.tweet.retweeted = YES;
        [[APIManager shared] retweet:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if(error){
                 NSLog(@"Error retweeting tweet: %@", error.localizedDescription);
            }
            else{
                NSLog(@"Successfully retweeted the following Tweet: %@", tweet.text);
            }
        }];
    }
    self.retweetButton.selected = self.tweet.retweeted;
    [self refreshData];
}

- (IBAction)didTapFavorite:(id)sender {
    if(self.tweet.favorited)
    {
        self.tweet.favorited = NO;
        self.tweet.favoriteCount -= 1;
        [[APIManager shared] unfavorite:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if(error){
                 NSLog(@"Error unfavoriting tweet: %@", error.localizedDescription);
            }
            else{
                NSLog(@"Successfully unfavorited the following Tweet: %@", tweet.text);
            }
        }];
    }
    else
    {
        self.tweet.favorited = YES;
        self.tweet.favoriteCount += 1;
        [[APIManager shared] favorite:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if(error){
                 NSLog(@"Error favoriting tweet: %@", error.localizedDescription);
            }
            else{
                NSLog(@"Successfully favorited the following Tweet: %@", tweet.text);
            }
        }];
    }
    self.favoriteButton.selected = self.tweet.favorited;
    [self refreshData];
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




#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([[segue identifier] isEqualToString:@"replySegue"])
    {
        UINavigationController *navigationController = [segue destinationViewController];
        ComposeViewController *composeController = (ComposeViewController*)navigationController.topViewController;
        composeController.isReply = YES;
        composeController.replyUserName = self.tweet.user.name;
        composeController.replyId = self.tweet.idStr;
    }
    else if([[segue identifier] isEqualToString:@"profileSegue"])
    {
        UIButton *tappedPic = sender;
        User* user = self.tweet.user;
        ProfileViewController *profileViewController = [segue destinationViewController];
        profileViewController.user = user;
    }
}


@end
