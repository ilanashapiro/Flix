//
//  Movie.m
//  Flix
//
//  Created by ilanashapiro on 7/6/19.
//  Copyright © 2019 ilanashapiro. All rights reserved.
//

#import "Movie.h"

@implementation Movie

- (id)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    
    self.title = dictionary[@"title"];
    
    NSString *baseURLString = @"https://image.tmdb.org/t/p/w500";
    NSString *posterURLString = dictionary[@"poster_path"];
    NSString *fullPosterURL = [baseURLString stringByAppendingString:posterURLString];
    self.posterURL = [NSURL URLWithString:fullPosterURL]; //NSURL is very similar to NSString, except it checks to make sure the given string is a valid URL
    
    NSString *backdropURLString = dictionary[@"backdrop_path"];
    NSString *fullBackdropURL = [baseURLString stringByAppendingString:backdropURLString];
    
    self.backdropURL = [NSURL URLWithString:fullBackdropURL];
    
    self.overview = dictionary[@"overview"];
    
    return self;
}

+ (NSMutableArray *)moviesWithDictionaries:(NSArray *)dictionaries {
    NSMutableArray *movies = [NSMutableArray arrayWithCapacity:[dictionaries count]];
    
    int index = 0;
    for (NSDictionary *dictionary in dictionaries) {
        Movie *movie = [[self alloc] initWithDictionary:dictionary];
        [movies insertObject:movie atIndex:index];
        index++;
    }
    
    return movies;
}

@end
