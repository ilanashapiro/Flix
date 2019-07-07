//
//  MovieApiManager.h
//  Flix
//
//  Created by ilanashapiro on 7/6/19.
//  Copyright © 2019 ilanashapiro. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MovieApiManager : NSObject

- (void)fetchNowPlaying:(void(^)(NSMutableArray *movies, NSError *error))completion;

@end

NS_ASSUME_NONNULL_END
