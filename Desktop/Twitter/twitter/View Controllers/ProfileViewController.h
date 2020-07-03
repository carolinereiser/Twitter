//
//  ProfileViewController.h
//  twitter
//
//  Created by Caroline Reiser on 7/1/20.
//  Copyright © 2020 Emerson Malca. All rights reserved.
//

#import "User.h"
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ProfileViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *username;
@property (weak, nonatomic) IBOutlet UILabel *screenname;
@property (weak, nonatomic) IBOutlet UILabel *bio;
@property (weak, nonatomic) IBOutlet UILabel *followingCount;
@property (weak, nonatomic) IBOutlet UILabel *followerCount;
@property (weak, nonatomic) IBOutlet UILabel *tweetCount;
@property (assign, nonatomic) BOOL isMoreDataLoading;

@property (strong,nonatomic) User *user;

@end

NS_ASSUME_NONNULL_END
