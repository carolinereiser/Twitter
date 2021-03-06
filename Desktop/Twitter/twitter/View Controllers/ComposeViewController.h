//
//  ComposeViewController.h
//  twitter
//
//  Created by Caroline Reiser on 6/30/20.
//  Copyright © 2020 Emerson Malca. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ComposeViewControllerDelegate
- (void)didTweet:(Tweet *)tweet;
@end

@interface ComposeViewController : UIViewController
@property (nonatomic, weak) id<ComposeViewControllerDelegate> delegate;
@property (nonatomic) BOOL isReply;
@property (nonatomic, strong) NSString* replyUserName;
@property (nonatomic, strong) NSString* replyId;
@property (weak, nonatomic) IBOutlet UIImageView *profilePic;
@end

NS_ASSUME_NONNULL_END
