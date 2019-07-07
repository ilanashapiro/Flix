//
//  MovieCell.m
//  Flix
//
//  Created by ilanashapiro on 6/26/19.
//  Copyright © 2019 ilanashapiro. All rights reserved.
//

#import "MovieCell.h"
#import "UIImageView+AFNetworking.h"

@implementation MovieCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setMovie:(Movie *)movie {
    _movie = movie;
    self.titleLabel.text = movie.title;
    self.synopsisLabel.text = movie.overview;
    
    NSURL *posterURL = movie.posterURL; //NSURL is very similar to NSString, except it checks to make sure the given string is a valid URL
    
    self.posterView.image = nil; //clear out the old image so there's no "flicker" before the new one loads because recall we are reusing the cells from the queue
    
    //fade in images
    NSURLRequest *request = [NSURLRequest requestWithURL:posterURL];
    __weak MovieCell *weakSelf = self;
    [self.posterView setImageWithURLRequest:request placeholderImage:nil
                                    success:^(NSURLRequest *imageRequest, NSHTTPURLResponse *imageResponse, UIImage *image) {
                                        
                                        // imageResponse will be nil if the image is cached
                                        if (imageResponse) {
                                            NSLog(@"Image was NOT cached, fade in image");
                                            weakSelf.posterView.alpha = 0.0;
                                            weakSelf.posterView.image = image;
                                            
                                            //Animate UIImageView back to alpha 1 over 1sec
                                            [UIView animateWithDuration:1 animations:^{
                                                weakSelf.posterView.alpha = 1.0;
                                            }];
                                        }
                                        else {
                                            NSLog(@"Image was cached so just update the image");
                                            weakSelf.posterView.image = image;
                                        }
                                    }
                                    failure:^(NSURLRequest *request, NSHTTPURLResponse * response, NSError *error) {
                                        NSLog(@"There was a network error.ß");
                                    }];
}

@end
