//
//  UsersTableViewController.m
//  wag-project
//
//  Created by Dinh Ho on 6/1/18.
//  Copyright © 2018 DInh Ho. All rights reserved.
//

#import "UsersTableViewController.h"
#import "StackOverflowAPIClient.h"
#import "UserInfoTableViewCell.h"

#import "UIRefreshControl+AFNetworking.h"

#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>

static CGFloat kEmptyTitleFontSize = 18.0f;
static CGFloat kEmptyDescriptionFontSize = 14.0f;
static CGFloat kEstimatedRowHeight = 70.0f;

@interface UsersTableViewController () <DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (readwrite, nonatomic, strong) NSArray *dataSource;
@property (nonatomic, assign) BOOL hasError;
@property (nonatomic, assign) BOOL isLoading;

@end

@implementation UsersTableViewController

#pragma mark - View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavigationBar];
    [self setupProperties];
    [self setupTableView];
    [self reload:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Configurations

- (void)setupTableView {
    self.refreshControl = [[UIRefreshControl alloc] initWithFrame:CGRectZero];
    [self.refreshControl addTarget:self action:@selector(reload:) forControlEvents:UIControlEventValueChanged];
    [self.tableView.tableHeaderView addSubview:self.refreshControl];
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = kEstimatedRowHeight;
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([UserInfoTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([UserInfoTableViewCell class])];
    
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    
    // hack to remove cell separators when empty
    self.tableView.tableFooterView = [UIView new];
}

- (void)setupProperties {
    self.hasError = NO;
    self.isLoading = NO;
    self.dataSource = @[];
}

- (void)setupNavigationBar {
    //    self.navigationController.navigationBar.titleTextAttributes = @{ NSForegroundColorAttributeName: [UIColor colorWithRed:244.0/255.0 green:128.0/255.0 blue:36.0/255.0 alpha:1.0] };
    //    self.title = NSLocalizedString(@"users.navigation.title", nil);
    UIImage *image = [UIImage imageNamed:NSLocalizedString(@"image.brand", nil)];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:image];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataSource count];
}

- (void)reload:(__unused id)sender {
    self.hasError = NO;
    self.isLoading = YES;
    // reloading data here to have dzn update accordingly
    [self.tableView reloadData];
    
    __weak __typeof__(self) weakSelf = self;
   [[StackOverflowAPIClient sharedInstance] fetch:^(NSArray *users, NSError *err) {
       weakSelf.isLoading = NO;
       weakSelf.hasError = err;
       weakSelf.dataSource = users;
       [weakSelf.refreshControl endRefreshing];
       [weakSelf.tableView reloadData];
    }];
}


#pragma mark - Table view delegates

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UserInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UserInfoTableViewCell class]) forIndexPath:indexPath];
    
    if (!cell)
        cell = [[UserInfoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([UserInfoTableViewCell class])];
    
    
    UserInfo *userInfoData = self.dataSource[indexPath.row];
    [cell populateContentWithUserInfo:userInfoData];
    return cell;
}

#pragma mark - DZNEmptyDataSetSource

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:NSLocalizedString(@"image.error", nil)];
}

- (UIColor *)imageTintColorForEmptyDataSet:(UIScrollView *)scrollView {
    return (self.hasError) ? [UIColor redColor] : [UIColor darkGrayColor];
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text = (self.hasError) ? NSLocalizedString(@"empty.title.error", nil) : NSLocalizedString(@"empty.title.nodata", nil);
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:kEmptyTitleFontSize],
                                 NSForegroundColorAttributeName: [UIColor darkGrayColor]};

    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text = (self.hasError) ? NSLocalizedString(@"empty.description.error", nil) : NSLocalizedString(@"empty.description.nodata", nil);

    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:kEmptyDescriptionFontSize],
                                 NSForegroundColorAttributeName: [UIColor lightGrayColor],
                                 NSParagraphStyleAttributeName: paragraph};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (NSAttributedString *)buttonTitleForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state {
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:kEmptyTitleFontSize]};
    return [[NSAttributedString alloc] initWithString:NSLocalizedString(@"empty.button.title", nil) attributes:attributes];
}

- (UIView *)customViewForEmptyDataSet:(UIScrollView *)scrollView {
    // if there's an error or loading is done and data is empty, return nil, DZNEmptyDataSet will call the image and text datasource
    if (self.hasError || (!self.isLoading && [self.dataSource count] == 0))
        return nil;
    UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [activityView startAnimating];
    return activityView;

}

#pragma mark - DZNEmptyDataSetDelegate

- (void)emptyDataSet:(UIScrollView *)scrollView didTapButton:(UIButton *)button {
    [self reload:nil];
}

@end
