//
//  MovieApiManager.m
//  Flix
//
//  Created by ilanashapiro on 7/6/19.
//  Copyright © 2019 ilanashapiro. All rights reserved.
//

#import "MovieApiManager.h"
#import "Movie.h"

@interface MovieApiManager()

@property (nonatomic, strong) NSURLSession *session;
@property (nonatomic, strong) NSString *APIKey;

@end

@implementation MovieApiManager

- (id)init {
    self = [super init];
    
    self.APIKey = @"a07e22bc18f5cb106bfe4cc1f83ad8ed";
    self.session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    
    return self;
}

- (void)fetchMoviesWithUrl:(NSURL *)url completion:(void(^)(NSMutableArray *movies, NSError *error))completion {
    //helper function to avoid repeating code in fetchNowPlaying and fetchPopular
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    NSURLSessionDataTask *task = [self.session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error != nil) {
            NSLog(@"%@", [error localizedDescription]);
            
            // The network request has completed, but failed.
            // Invoke the completion block with an error.
            // Think of invoking a block like calling a function with parameters
            completion(nil, error);
        }
        else {
            NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            
            NSArray *dictionaries = dataDictionary[@"results"];
            NSMutableArray *movies = [Movie moviesWithDictionaries:dictionaries];
            
            // The network request has completed, and succeeded.
            // Invoke the completion block with the movies array.
            // Think of invoking a block like calling a function with parameters
            completion(movies, nil);
        }
    }];
    [task resume];
}

- (void)fetchNowPlaying:(void(^)(NSMutableArray *movies, NSError *error))completion {
    //fetch now playing movies from The Movie Database API
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", @"https://api.themoviedb.org/3/movie/now_playing?api_key=", self.APIKey]];
    [self fetchMoviesWithUrl:url completion:completion];
}

- (void)fetchPopular:(void(^)(NSMutableArray *movies, NSError *error))completion {
    //fetch popular movies from The Movie Database API
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", @"https://api.themoviedb.org/3/movie/popular?api_key=", self.APIKey]];
    [self fetchMoviesWithUrl:url completion:completion];
}

@end
