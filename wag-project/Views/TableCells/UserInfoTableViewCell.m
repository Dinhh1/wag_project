//
//  UserInfoTableViewCell.m
//  wag-project
//
//  Created by Dinh Ho on 6/1/18.
//  Copyright © 2018 DInh Ho. All rights reserved.
//

#import "UserInfoTableViewCell.h"
#import "UIImageView+AFNetworking.h"

static CGFloat kReputationFontSize = 15.0f;
static CGFloat kNameFontSize = 17.0f;
static CGFloat kBadgeFontSize = 13.0f;

@interface UserInfoTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *reputationLabel;
@property (weak, nonatomic) IBOutlet UILabel *goldBadgeLabel;
@property (weak, nonatomic) IBOutlet UILabel *silverBadgeLabel;
@property (weak, nonatomic) IBOutlet UILabel *bronzeBadgeLabel;
@property (weak, nonatomic) IBOutlet UIView *goldBadgeView;
@property (weak, nonatomic) IBOutlet UIView *silverBadgeView;
@property (weak, nonatomic) IBOutlet UIView *bronzeBadgeView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end

@implementation UserInfoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // circle images
    self.profileImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self setupBadgeView:self.goldBadgeView];
    [self setupBadgeView:self.silverBadgeView];
    [self setupBadgeView:self.bronzeBadgeView];
    [self setupLabels];
}

- (void)prepareForReuse {
    [super prepareForReuse];
    [self.profileImageView cancelImageDownloadTask];
    self.activityIndicator.hidden = false;
    self.nameLabel.text = nil;
    self.reputationLabel.text = nil;
    self.goldBadgeLabel.text = nil;
    self.silverBadgeLabel.text = nil;
    self.bronzeBadgeLabel.text = nil;
}

- (void)setupLabels {
    [self setupBadgeLabel:self.goldBadgeLabel];
    [self setupBadgeLabel:self.silverBadgeLabel];
    [self setupBadgeLabel:self.bronzeBadgeLabel];
    
    self.reputationLabel.font = [UIFont systemFontOfSize:kReputationFontSize];
    self.reputationLabel.textColor = [UIColor darkGrayColor];
    
    self.nameLabel.font = [UIFont systemFontOfSize:kNameFontSize];
    self.nameLabel.textColor = [UIColor darkGrayColor];
}

- (void)setupBadgeView:(UIView *)badgeView {
    badgeView.layer.cornerRadius = badgeView.frame.size.height / 2;
    badgeView.layer.masksToBounds = YES;
}

- (void)setupBadgeLabel:(UILabel *)badgeLabel {
    badgeLabel.font = [UIFont systemFontOfSize:kBadgeFontSize];
    badgeLabel.textColor = [UIColor lightGrayColor];
}

- (void)populateContentWithUserInfo:(UserInfo *)userInfo {
    if (!userInfo)
        return;
    self.nameLabel.text = userInfo.displayName;
    self.reputationLabel.text = [userInfo formattedReputation];
    self.goldBadgeLabel.text = [userInfo.badgeCount.gold stringValue];
    self.silverBadgeLabel.text = [userInfo.badgeCount.silver stringValue];
    self.bronzeBadgeLabel.text = [userInfo.badgeCount.bronze stringValue];
    
    
    NSMutableURLRequest *imageRequest = [NSMutableURLRequest requestWithURL:[userInfo profileImageURL]];
    
    [self.activityIndicator startAnimating];
    
    //AFNetworking calls block on mainthread
    __weak __typeof__(self) weakSelf = self;
    [self.profileImageView setImageWithURLRequest:imageRequest
                      placeholderImage:nil
                               success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image)
     {
         [weakSelf.activityIndicator stopAnimating];
         weakSelf.profileImageView.image = image;

     }
                               failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error)
     {
         [weakSelf.activityIndicator stopAnimating];
         weakSelf.profileImageView.image = [UIImage imageNamed:NSLocalizedString(@"image.placeholder", nil)];
     }];

}

@end
