//
//  Movie.h
//  Flix
//
//  Created by ilanashapiro on 7/6/19.
//  Copyright © 2019 ilanashapiro. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Movie : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSURL *posterURL;
@property (nonatomic, strong) NSURL *backdropURL;
@property (nonatomic, strong) NSString *overview;

- (id)initWithDictionary:(NSDictionary *)dictionary;
+ (NSMutableArray *)moviesWithDictionaries:(NSArray *)dictionaries;

@end

NS_ASSUME_NONNULL_END
