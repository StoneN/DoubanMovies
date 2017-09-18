//
//  FeaturedTableViewController.h
//  DoubanMovies
//
//  Created by StoneN on 2017/8/28.
//  Copyright © 2017年 StoneN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FeaturedTableViewController : UITableViewController

@property (copy, nonatomic) NSString *url;
@property (assign, nonatomic) BOOL hasQuery;

@end
