//
//  ChartsViewController.m
//  DoubanMovies
//
//  Created by StoneN on 2017/9/17.
//  Copyright © 2017年 StoneN. All rights reserved.
//

#import "ChartsViewController.h"
#import "CollectionViewCell.h"
#import "AFNetworking.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "MJRefresh.h"


typedef NS_ENUM(NSInteger, MovieChartsType)
{
    ComingSoon,
    InTheaters,
    Top250,
};



@interface ChartsViewController () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (strong, nonatomic) NSMutableArray *movies;
@property (strong, nonatomic) NSMutableArray *start;
@property (strong, nonatomic) NSMutableArray *count;
@property (strong, nonatomic) NSMutableArray *total;

@property (assign, nonatomic) MovieChartsType chartsType;

@end


@implementation ChartsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    
    //    _collectionView.
    [self configurationSegmentTitle];
    
    self.movies = [[NSMutableArray alloc]init];
    self.start = [[NSMutableArray alloc]init];
    self.count = [[NSMutableArray alloc]init];
    self.total = [[NSMutableArray alloc]init];
    
    for (NSInteger i=0; i<_segmentedControl.numberOfSegments; i++) {
        NSMutableArray *movies0 = [[NSMutableArray alloc]init];
        [_movies addObject:movies0];
        
        NSNumber *start0 = [NSNumber numberWithInteger:0];
        NSNumber *count0 = [NSNumber numberWithInteger:30];
        NSNumber *total0 = [NSNumber numberWithInteger:0];
        [_start addObject:start0];
        [_count addObject:count0];
        [_total addObject:total0];
    }
    
    self.chartsType = ComingSoon;
    
    
    if (_url == nil) {
        [self writeURLByChartsType];
    }
    
    self.collectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(featuredRefreshing)];
    
    [self.collectionView.mj_header beginRefreshing];
    
    NSLog(@"viewDidLoad=>>");
}

- (void)configurationSegmentTitle
{
    [_segmentedControl setTitle:@"即将上映" forSegmentAtIndex:0];
    [_segmentedControl setTitle:@"正在上映" forSegmentAtIndex:1];
    [_segmentedControl setTitle:@"Top250" forSegmentAtIndex:2];
}

- (void)writeURLByChartsType
{
    switch (_chartsType) {
        case ComingSoon:
            self.url = @"https://api.douban.com/v2/movie/coming_soon";
            break;
        case InTheaters:
            self.url = @"https://api.douban.com/v2/movie/in_theaters";
            break;
        case Top250:
            self.url = @"https://api.douban.com/v2/movie/top250";
            break;
        default:
            //                self.url = @"https://api.douban.com/v2/movie/coming_soon";
            break;
    }
}

- (NSString *)requestURL
{
    NSLog(@"%@",[NSString stringWithFormat:@"%@?count=%li&start=%li",_url,[_count[_segmentedControl.selectedSegmentIndex] integerValue],[_start[_segmentedControl.selectedSegmentIndex] integerValue]]);
    return [NSString stringWithFormat:@"%@?count=%li&start=%li",_url,[_count[_segmentedControl.selectedSegmentIndex] integerValue],[_start[_segmentedControl.selectedSegmentIndex] integerValue]];
}

- (void)collectionViewLoadData
{
    if (((NSArray *)_movies[_segmentedControl.selectedSegmentIndex]).count!=0) {
        [self.collectionView reloadData];
    } else {
        [self.collectionView.mj_header beginRefreshing];
        [self featuredRefreshing];
    }
}

- (void)loadMoreData
{
    NSLog(@"loadMoreData");
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:[self requestURL]
      parameters:nil
        progress:nil
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             
             if ([_start[_segmentedControl.selectedSegmentIndex] integerValue] < [_total[_segmentedControl.selectedSegmentIndex] integerValue] || [_total[_segmentedControl.selectedSegmentIndex] integerValue] == 0) {
                 self.total[_segmentedControl.selectedSegmentIndex] = [NSNumber numberWithInteger:[responseObject[@"total"] integerValue]];
                 self.start[_segmentedControl.selectedSegmentIndex] = [NSNumber numberWithInteger:[responseObject[@"start"] integerValue] + [responseObject[@"count"] integerValue]];
                 
                 [self.movies[_segmentedControl.selectedSegmentIndex] addObjectsFromArray:responseObject[@"subjects"]];
                 [self.collectionView.mj_footer endRefreshing];
                 if (self.navigationItem.title == NULL) {
                     self.navigationItem.title = responseObject[@"title"];
                 }
                 [self.collectionView reloadData];
             } else {
                 [self.collectionView.mj_footer endRefreshingWithNoMoreData];
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
             NSLog(@"1===>");
             if (![_total[_segmentedControl.selectedSegmentIndex] isEqualToNumber:[NSNumber numberWithInteger:[responseObject[@"total"] integerValue]]]) {
                 NSLog(@"2===>");
                 self.total[_segmentedControl.selectedSegmentIndex] = [NSNumber numberWithInteger:[responseObject[@"total"] integerValue]];
                 NSLog(@"3===>");
                 self.start[_segmentedControl.selectedSegmentIndex] = [NSNumber numberWithInteger:[responseObject[@"start"] integerValue] + [responseObject[@"count"] integerValue]];
                 NSLog(@"4===>");
                 [self.movies[_segmentedControl.selectedSegmentIndex] addObjectsFromArray:responseObject[@"subjects"]];
                 NSLog(@"5===>");
                 
                 if (self.navigationItem.title == NULL) {
                     self.navigationItem.title = responseObject[@"title"];
                 }
             }
             [self.collectionView.mj_header endRefreshing];
             [self.collectionView reloadData];
         }
         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             NSLog(@"%@",error);
         }
     ];
    
}

- (IBAction)segmentValueChanged:(UISegmentedControl *)sender
{
    switch (sender.selectedSegmentIndex) {
        case 0:
            self.chartsType = 0;
            break;
        case 1:
            self.chartsType = 1;
            break;
        case 2:
            self.chartsType = 2;
            break;
        default:
            break;
    }
    if ([_start[_segmentedControl.selectedSegmentIndex] integerValue] < [_total[_segmentedControl.selectedSegmentIndex] integerValue] || [_total[_segmentedControl.selectedSegmentIndex] integerValue] == 0) {
        [self.collectionView.mj_footer setState:MJRefreshStateIdle];
    } else {
        [self.collectionView.mj_footer setState:MJRefreshStateNoMoreData];
    }
    [self writeURLByChartsType];
    [self collectionViewLoadData];
}
//
//- (nullable NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
//{
//    NSMutableArray *attributesArray = [[NSMutableArray alloc]init];//[UICollectionViewLayoutAttributes]();
//    NSInteger cellCount = [_collectionView numberOfItemsInSection:0];
//    for (NSInteger i=0; i<cellCount; i++) {
//        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
//        UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
//        //        let attributes =  self.layoutAttributesForItem(at: indexPath)
//        [attributesArray addObject:attributes];
//    }
//    NSLog(@"come in===>");
//    return attributesArray;
//}
//
//
//- (nullable UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    NSLog(@"come in===>===>");
//    //当前单元格布局属性
//    UICollectionViewLayoutAttributes *attribute = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
//    
//    //单元格边长
//    CGFloat cellWidth = _collectionView.contentSize.width / 2;
//    CGFloat cellHeight = cellWidth * (138 / 100);
//    
//    //当前行数，每行显示3个图片，1大2小
//    NSInteger line =  indexPath.item / 2;
//    //当前行的Y坐标
//    CGFloat lineOriginY = cellHeight * (CGFloat)line;
//    //右侧单元格X坐标，这里按左右对齐，所以中间空隙大
//    CGFloat rightX = _collectionView.contentSize.width - cellWidth;
//    
//    
//    // 每行2个图片，2行循环一次，一共6种位置
//    if (indexPath.item % 2 == 0) {
//        attribute.frame = CGRectMake(0, lineOriginY, cellWidth, cellHeight);
//    } else if (indexPath.item % 2 == 1) {
//        attribute.frame = CGRectMake(rightX, lineOriginY, cellWidth, cellHeight);
//    }
//    
//    return attribute;
//}
//
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return ((NSArray *)_movies[_segmentedControl.selectedSegmentIndex]).count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = @"cell";
    
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    NSDictionary *movie = _movies[_segmentedControl.selectedSegmentIndex][indexPath.item];
    
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:movie[@"images"][@"large"]]
                      placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    cell.label.text = movie[@"title"];
    
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
