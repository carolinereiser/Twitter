//
//  DetailsViewController.m
//  twitter
//
//  Created by Caroline Reiser on 7/1/20.
//  Copyright © 2020 Emerson Malca. All rights reserved.
//

#import "DetailsViewController.h"
#import "UIImageView+AFNetworking.h"


@interface DetailsViewController ()

@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSURL *profPicURL = [NSURL URLWithString:self.tweet.user.profilePic];
    self.profilePic.image = nil;
    [self.profilePic setImageWithURL:profPicURL];
    
    self.username.text = self.tweet.user.name;
    self.screenname.text = [NSString stringWithFormat:@"@%@", self.tweet.user.screenName];
    
    //FORMAT THIS BETTER
    self.datePosted.text = self.tweet.createdAtString;
    
    self.tweetText.text = self.tweet.text;
    
    self.numRetweets.text = [NSString stringWithFormat:@"%d", self.tweet.retweetCount];
    self.numLikes.text = [NSString stringWithFormat:@"%d", self.tweet.favoriteCount];
    
    
    [self.username sizeToFit];
    [self.screenname sizeToFit];
    [self.numRetweets sizeToFit];
    [self.numLikes sizeToFit];
    [self.tweetText sizeToFit];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
