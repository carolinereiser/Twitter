//
//  TweetCell.m
//  twitter
//
//  Created by Caroline Reiser on 6/29/20.
//  Copyright © 2020 Emerson Malca. All rights reserved.
//

#import "APIManager.h"
#import "DateTools.h"
#import "ResponsiveLabel.h"
#import "TweetCell.h"
#import "UIImageView+AFNetworking.h"


@implementation TweetCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.favButton setImage:[UIImage imageNamed:@"favor-icon"] forState:UIControlStateNormal];
    [self.favButton setImage:[UIImage imageNamed:@"favor-icon-red"] forState:UIControlStateSelected];
    
    [self.rtButton setImage:[UIImage imageNamed:@"retweet-icon"] forState:UIControlStateNormal];
    [self.rtButton setImage:[UIImage imageNamed:@"retweet-icon-green"] forState:UIControlStateSelected];
    
    self.rtButton.selected = self.tweet.retweeted;
    self.favButton.selected = self.tweet.favorited;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    

    // Configure the view for the selected state
}

- (void)setTweet:(Tweet *)tweet
{
    _tweet = tweet;
    
    //set profile pic
    NSURL *profPicURL = [NSURL URLWithString:tweet.user.profilePic];
    
    UIImageView *imageView = [[UIImageView alloc] init];
    [imageView setImageWithURL:profPicURL];
    [self.profilePic setBackgroundImage:imageView.image forState:UIControlStateNormal];
    
    
    //self.profilePic.image = nil;
    //[self.profilePic setImageWithURL:profPicURL];
    
    self.userName.text = tweet.user.name;
    self.screenName.text = [NSString stringWithFormat:@"@%@", tweet.user.screenName];
    
    self.date.text = tweet.date.shortTimeAgoSinceNow;
    self.tweetText.text = tweet.text;
    
    if(tweet.retweetCount)
    {
        self.rtCount.text = [self formatNumber:tweet.retweetCount];
    }
    else
    {
        self.rtCount.text = @"";
    }

    if(tweet.favoriteCount)
    {
        self.favCount.text = [self formatNumber:tweet.favoriteCount];
    }
    else
    {
        self.favCount.text = @"";
    }

    
    [self.userName sizeToFit];
    [self.tweetText sizeToFit];
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
    self.favButton.selected = self.tweet.favorited;
    [self refreshData];
}

- (void)refreshData{
    if(self.tweet.favoriteCount)
    {
        self.favCount.text = [self formatNumber:self.tweet.favoriteCount];
    }
    else
    {
        self.favCount.text = @"";
    }
    
    if(self.tweet.retweetCount)
    {
        self.rtCount.text = [self formatNumber:self.tweet.retweetCount];
    }
    else
    {
        self.rtCount.text = @"";
    }
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
    self.rtButton.selected = self.tweet.retweeted;
    [self refreshData];
}

@end
