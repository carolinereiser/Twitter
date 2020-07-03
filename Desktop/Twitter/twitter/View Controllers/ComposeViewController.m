//
//  ComposeViewController.m
//  twitter
//
//  Created by Caroline Reiser on 6/30/20.
//  Copyright © 2020 Emerson Malca. All rights reserved.
//

#import "APIManager.h"
#import "ComposeViewController.h"
#import "UIImageView+AFNetworking.h"


@interface ComposeViewController () <UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextView *tweetText;
@property (weak, nonatomic) IBOutlet UILabel *characterCount;

@end

@implementation ComposeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if(self.isReply)
    {
        self.tweetText.text = [NSString stringWithFormat:@"@%@ ", self.replyUserName];
    }
    
    [[APIManager shared] getCurrentUser:^(User* user, NSError* error){
        if(user)
        {
            NSLog(@"Got user credentials!");
            NSURL *profilePicURL = [NSURL URLWithString:user.profilePic];
            [self.profilePic setImageWithURL:profilePicURL];
        }
        else
        {
            NSLog(@"Error getting credentials: %@", error.localizedDescription);
        }
    }];
    
    self.tweetText.delegate = self;
    [self.tweetText becomeFirstResponder];
}

- (IBAction)close:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}

- (IBAction)postTweet:(id)sender {
    if(self.isReply)
    {
        [[APIManager shared] postReplyWithText:self.tweetText.text replyId:self.replyId completion:^(Tweet* tweet, NSError *error){
            if(tweet)
            {
                NSLog(@"Successfully posted reply!");
                [self.delegate didTweet:tweet];
                [self dismissViewControllerAnimated:true completion:nil];
            }
            else
            {
                NSLog(@"There was an error: %@", error.localizedDescription);
            }
        }];
    }
    else
    {
        [[APIManager shared] postStatusWithText:self.tweetText.text completion:^(Tweet* tweet, NSError *error) {
            if(tweet)
            {
                NSLog(@"Successfully posted!");
                [self.delegate didTweet:tweet];
                [self dismissViewControllerAnimated:true completion:nil];
            }
            else
            {
                NSLog(@"There was an error: %@", error.localizedDescription);
            }
        }];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    // Set the max character limit
    int characterLimit = 280;

    // Construct what the new text would be if we allowed the user's latest edit
    NSString *newText = [self.tweetText.text stringByReplacingCharactersInRange:range withString:text];

    int charactersLeft = characterLimit - (int)newText.length;
    self.characterCount.text = [NSString stringWithFormat:@"%d", charactersLeft];
    

    // The new text should be allowed? True/False
    return newText.length < characterLimit;
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
