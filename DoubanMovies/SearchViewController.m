//
//  SearchViewController.m
//  DoubanMovies
//
//  Created by StoneN on 2017/8/29.
//  Copyright © 2017年 StoneN. All rights reserved.
//

#import "SearchViewController.h"
#import "SearchHistoryTableViewCell.h"
#import "FeaturedTableViewController.h"

@interface SearchViewController () <UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *searchHistoryTableView;
@property (strong, nonatomic) NSMutableArray *history;

@end

@implementation SearchViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    
    //-------------------------
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"history.plist"];
    
    if ([fileManager fileExistsAtPath:path]) {
        self.history = [NSMutableArray arrayWithContentsOfFile:path];
    } else {
        [fileManager createFileAtPath:path contents:nil attributes:nil];
        _history = [[NSMutableArray alloc]init];
        [_history writeToFile:path atomically:TRUE];
    }
    //-------------------------
    
    _searchBar.delegate = self;
    _searchHistoryTableView.delegate = self;
    _searchHistoryTableView.dataSource = self;
    
}



- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    if (_history.count >= 20) {
        [_history removeLastObject];
    }
    if ([_history indexOfObject:searchBar.text] != NSNotFound) {
        [_history removeObjectAtIndex:[_history indexOfObject:searchBar.text]];
    };
    [_history insertObject:searchBar.text atIndex:0];
    [_searchHistoryTableView reloadData];
    
    //-------------------------
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"history.plist"];
    
    if ([fileManager fileExistsAtPath:path]) {
        [fileManager removeItemAtPath:path error:nil];
    }
    [fileManager createFileAtPath:path contents:nil attributes:nil];
    [_history writeToFile:path atomically:TRUE];
    //-------------------------
    
    FeaturedTableViewController *nextController = [self.storyboard instantiateViewControllerWithIdentifier:@"featuredTableViewController"];
    nextController.url = [NSString stringWithFormat:@"https://api.douban.com/v2/movie/search?q=%@", searchBar.text];
    nextController.hasQuery = true;
    [self.navigationController pushViewController:nextController animated:true];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _history.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = @"historyCell";
    SearchHistoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[SearchHistoryTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    cell.label.text = _history[indexPath.row];
    cell.deleteButton.tag = indexPath.row;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _searchBar.text = _history[indexPath.row];
    [self searchBarSearchButtonClicked:_searchBar];
}

- (IBAction)deleteHistory:(UIButton *)sender
{
    [_history removeObjectAtIndex:sender.tag];
    NSLog(@"tag===%li",(long)sender.tag);
    [_searchHistoryTableView reloadData];
}

@end
