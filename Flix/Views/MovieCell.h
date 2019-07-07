//
//  MovieCell.h
//  Flix
//
//  Created by ilanashapiro on 6/26/19.
//  Copyright © 2019 ilanashapiro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Movie.h"

NS_ASSUME_NONNULL_BEGIN

@interface MovieCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *posterView; //don't call it imageView or will override UITableViewCell's imageView!!
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;  //don't call it textLabel or will override UITableViewCell's textLabel!!
@property (weak, nonatomic) IBOutlet UILabel *synopsisLabel;

@property (nonatomic, strong) Movie *movie;

@end

NS_ASSUME_NONNULL_END
