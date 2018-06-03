//
//  UserInfoTableViewCell.h
//  wag-project
//
//  Created by Dinh Ho on 6/1/18.
//  Copyright © 2018 DInh Ho. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserInfo.h"

@interface UserInfoTableViewCell : UITableViewCell

- (void)populateContentWithUserInfo:(UserInfo *)userInfo;

@end
