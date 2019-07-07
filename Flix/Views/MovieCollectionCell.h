//
//  MovieCollectionCell.h
//  Flix
//
//  Created by ilanashapiro on 6/26/19.
//  Copyright © 2019 ilanashapiro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Movie.h"

NS_ASSUME_NONNULL_BEGIN

@interface MovieCollectionCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *posterView;
@property (nonatomic, strong) Movie *movie;

@end

NS_ASSUME_NONNULL_END
