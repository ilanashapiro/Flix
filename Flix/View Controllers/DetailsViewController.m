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
    // Do any additional setup after loading the view.
    
    NSString *baseURLString = @"https://image.tmdb.org/t/p/w500";
    NSString *posterURLString = self.movie[@"poster_path"];
    NSString *fullPosterURL = [baseURLString stringByAppendingString:posterURLString];
    
    NSURL *posterURL = [NSURL URLWithString:fullPosterURL]; //NSURL is very similar to NSString, except it checks to make sure the given string is a valid URL
    [self.posterView setImageWithURL:posterURL];
    
    NSString *backdropURLString = self.movie[@"backdrop_path"];
    NSString *fullBackdropURL = [baseURLString stringByAppendingString:backdropURLString];
    
    NSURL *backdropURL = [NSURL URLWithString:fullBackdropURL]; //NSURL is very similar to NSString, except it checks to make sure the given string is a valid URL
    [self.backdropView setImageWithURL:backdropURL];
    
    self.titleLabel.text = self.movie[@"title"];
    self.synopsisLabel.text = self.movie[@"overview"];
                               
    [self.titleLabel sizeToFit];
    [self.synopsisLabel sizeToFit];
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
