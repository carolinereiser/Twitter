//
//  MentionsViewController.m
//  twitter
//
//  Created by Caroline Reiser on 7/2/20.
//  Copyright © 2020 Emerson Malca. All rights reserved.
//

#import"APIManager.h"
#import "MentionsViewController.h"
#import "TweetCell.h"

@interface MentionsViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic, strong) NSMutableArray *tweetList;
@end

@implementation MentionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    // Do any additional setup after loading the view.
    [self fetchTweets];
}

-(void)fetchTweets {
    [[APIManager shared] getMentionsTimeline:^(NSMutableArray *tweets, NSError *error) {
        if (tweets) {
            NSLog(@"😎😎😎 Successfully loaded mentions timeline");
            self.tweetList = tweets;
            [self.tableView reloadData];
    } else{
            NSLog(@"😫😫😫 Error getting mentions timeline: %@", error.localizedDescription);
        }
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tweetList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TweetCell* cell = [self.tableView  dequeueReusableCellWithIdentifier:@"TweetCell" forIndexPath:indexPath];
    cell.profilePic.tag = indexPath.row;

    //get the tweet from the query
    cell.tweet = self.tweetList[indexPath.row];
    
    return cell;
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
