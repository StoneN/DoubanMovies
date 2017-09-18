//
//  MeViewController.m
//  DoubanMovies
//
//  Created by StoneN on 2017/9/16.
//  Copyright © 2017年 StoneN. All rights reserved.
//

#import "MeViewController.h"

@interface MeViewController () <UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end

@implementation MeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _webView.scrollView.bounces = false;
    _webView.delegate = self;
    
    [_activityIndicator startAnimating];
    [_webView loadRequest:[NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://accounts.douban.com/login"]]];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [_activityIndicator stopAnimating];
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
