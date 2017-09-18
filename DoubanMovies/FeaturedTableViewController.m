//
//  FeaturedTableViewController.m
//  DoubanMovies
//
//  Created by StoneN on 2017/8/28.
//  Copyright © 2017年 StoneN. All rights reserved.
//

#import "FeaturedTableViewController.h"
#import "MovieListTableViewCell.h"
#import "AFNetworking.h"
#import "MovieDetailViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "MJRefresh.h"

@interface FeaturedTableViewController ()

@property (strong, nonatomic) NSMutableArray *movies;
@property (assign, nonatomic) NSInteger start;
@property (assign, nonatomic) NSInteger count;
@property (assign, nonatomic) NSInteger total;

@end

@implementation FeaturedTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.start = 0;
    self.count = 100;
    self.total = 0;
    
    
    
    self.movies = [[NSMutableArray alloc]init];
    
    if (_url == nil) {
        self.url = @"https://api.douban.com/v2/movie/top250";
        self.hasQuery = false;
        self.navigationItem.title = @"电影推荐";
    }
   
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(featuredRefreshing)];
    
    [self.tableView.mj_header beginRefreshing];
    
    NSLog(@"viewDidLoad=>>");
}

- (NSString *)requestURL
{
    if (_hasQuery) {
        NSLog(@"===>Search!____count=%li&start=%li",_count,_start);
        return [NSString stringWithFormat:@"%@&count=%li&start=%li",_url,_count,_start];
    }
    return [NSString stringWithFormat:@"%@?count=%li&start=%li",_url,_count,_start];
}


- (void)loadMoreData
{
    NSLog(@"loadMoreData");
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:[self requestURL]
      parameters:nil
        progress:nil
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             
             if (_start < _total) {
                 self.total = [responseObject[@"total"] integerValue];
                 self.start = [responseObject[@"start"] integerValue] + [responseObject[@"count"] integerValue];
                 [self.movies addObjectsFromArray:responseObject[@"subjects"]];
                 [self.tableView.mj_footer endRefreshing];
                 if (self.navigationItem.title == NULL) {
                     self.navigationItem.title = responseObject[@"title"];
                 }
                 [self.tableView reloadData];
             } else {
                 [self.tableView.mj_footer endRefreshingWithNoMoreData];
             }
         }
         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             NSLog(@"%@",error);
         }
     ];
}

- (void)featuredRefreshing
{
    NSLog(@"Refreshing!");
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:[self requestURL]
      parameters:nil
        progress:nil
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             if (_total != [responseObject[@"total"] integerValue]) {
                 self.total = [responseObject[@"total"] integerValue];
                 self.start = [responseObject[@"start"] integerValue] + [responseObject[@"count"] integerValue];
                 [self.movies addObjectsFromArray:responseObject[@"subjects"]];
                 
                 if (self.navigationItem.title == NULL) {
                     self.navigationItem.title = responseObject[@"title"];
                 }
             }
             [self.tableView.mj_header endRefreshing];
             [self.tableView reloadData];
         }
         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             NSLog(@"%@",error);
         }
     ];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _movies.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = @"movieListCell";
    
    MovieListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[MovieListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    NSDictionary *movie = _movies[indexPath.row];
    
    [cell.movieImage sd_setImageWithURL:[NSURL URLWithString:movie[@"images"][@"large"]]
                       placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    cell.movieName.text = movie[@"title"];
    cell.movieTime.text = [NSString stringWithFormat:@"%@ ( %@ )",movie[@"original_title"],movie[@"year"]];
    NSNumber *score = movie[@"rating"][@"average"];
    cell.movieScore.text = [NSString stringWithFormat:@"%.1f",[score floatValue]];
    [cell setSelectionStyle:UITableViewCellSelectionStyleBlue];
    return cell;
}




- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    
    MovieDetailViewController *movieDetailViewController=[segue destinationViewController];
    movieDetailViewController.movie = _movies[indexPath.row];
    
}


@end
