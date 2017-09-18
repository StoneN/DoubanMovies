//
//  MovieDetailViewController.m
//  DoubanMovies
//
//  Created by StoneN on 2017/8/28.
//  Copyright © 2017年 StoneN. All rights reserved.
//

#import "MovieDetailViewController.h"
#import "FeaturedTableViewController.h"
#import "MovieListTableViewCell.h"
#import "AFNetworking.h"
#import "MovieDetailViewController.h"


@interface MovieDetailViewController ()

@property (strong, nonatomic) NSDictionary *movieDetail;
@property (weak, nonatomic) IBOutlet UITextView *detailTextView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end

@implementation MovieDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = _movie[@"title"];
    [_activityIndicator startAnimating];
    NSString *url = [NSString stringWithFormat:@"https://api.douban.com/v2/movie/subject/%@", _movie[@"id"]];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:url
      parameters:nil
        progress:nil
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             self.movieDetail = responseObject;
             [_activityIndicator stopAnimating];
             self.detailTextView.text = _movieDetail[@"summary"];
         }
         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             NSLog(@"%@",error);
         }
     ];
}




@end
