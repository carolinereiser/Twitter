//
//  User.m
//  twitter
//
//  Created by Caroline Reiser on 6/29/20.
//  Copyright © 2020 Emerson Malca. All rights reserved.
//

#import "User.h"

@implementation User

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        self.name = dictionary[@"name"];
        self.screenName = dictionary[@"screen_name"];
        self.profilePic = dictionary[@"profile_image_url_https"];
        self.backgroundPic = dictionary[@"profile_banner_url"];
        self.numTweets = [dictionary[@"statuses_count"] intValue];
        self.numFollowers = [dictionary[@"followers_count"] intValue];
        self.numFollowing = [dictionary[@"friends_count"] intValue];
        self.bio = dictionary[@"description"];
    }
    return self;
}

@end
