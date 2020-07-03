//
//  TweetCell.h
//  twitter
//
//  Created by Caroline Reiser on 6/29/20.
//  Copyright © 2020 Emerson Malca. All rights reserved.
//

#import "ResponsiveLabel.h"
#import "Tweet.h"
#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN

@interface TweetCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *date;
@property (weak, nonatomic) IBOutlet UIButton *profilePic;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *screenName;
@property (weak, nonatomic) IBOutlet UILabel *rtCount;
@property (weak, nonatomic) IBOutlet UILabel *favCount;
@property (weak, nonatomic) IBOutlet UIButton *shareButton;
@property (weak, nonatomic) IBOutlet UIButton *rtButton;
@property (weak, nonatomic) IBOutlet UIButton *favButton;
@property (weak, nonatomic) IBOutlet UIButton *dmButton;
@property (weak, nonatomic) IBOutlet UILabel *tweetText;



@property (strong, nonatomic) Tweet *tweet;
- (void)setTweet:(Tweet *)tweet;

@end

NS_ASSUME_NONNULL_END
