//
//  DetailsViewController.m
//  Flix
//
//  Created by ilanashapiro on 6/26/19.
//  Copyright © 2019 ilanashapiro. All rights reserved.
//

#import "DetailsViewController.h"
#import "UIImageView+AFNetworking.h"

@interface DetailsViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *backdropView;
@property (weak, nonatomic) IBOutlet UIImageView *posterView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *synopsisLabel;

@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.posterView setImageWithURL:self.movie.posterURL];
    
   
    [self.backdropView setImageWithURL:self.movie.backdropURL];
    
    self.titleLabel.text = self.movie.title;
    self.synopsisLabel.text = self.movie.overview;
    
    [self.titleLabel sizeToFit];
    [self.synopsisLabel sizeToFit];
}

@end
