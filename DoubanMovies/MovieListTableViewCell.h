//
//  MovieListTableViewCell.h
//  DoubanMovies
//
//  Created by StoneN on 2017/8/25.
//  Copyright © 2017年 StoneN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MovieListTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *movieImage;
@property (weak, nonatomic) IBOutlet UILabel *movieName;
@property (weak, nonatomic) IBOutlet UILabel *movieTime;
@property (weak, nonatomic) IBOutlet UILabel *movieScore;


@end
