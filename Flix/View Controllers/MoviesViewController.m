//
//  MoviesViewController.m
//  Flix
//
//  Created by ilanashapiro on 6/26/19.
//  Copyright © 2019 ilanashapiro. All rights reserved.
//

#import "MoviesViewController.h"
#import "MovieCell.h"
#import "UIImageView+AFNetworking.h" //there isn't a built in library to load an image from URL so we use one of the third party libraries from CocoaPod. this is a category and adds helper functions to augment UIImageView's capabilities.
#import "DetailsViewController.h"

@interface MoviesViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView; //create an outlet for the table view from the view controller so that we can refer to the table view
@property (nonatomic, strong) NSArray *movies;
@property (nonatomic, strong) UIRefreshControl *refreshControl;

@property (strong, nonatomic) NSArray *filteredData;
@property (strong, nonatomic) UISearchBar *searchBar;
@end

@implementation MoviesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tableView.dataSource = self; //set data source equal to the view controller (self). once you're scrolling and want to show cells, use self for the data source methods
    self.tableView.delegate = self; //set delegate equal to the view controller (self)
    self.searchBar.delegate = self;
    
    [self fetchMovies];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(fetchMovies) forControlEvents:UIControlEventValueChanged];
    
    [self.tableView insertSubview:self.refreshControl atIndex:0]; //insertSubview is similar to addSubview, but puts the subview at specified index so there's no overlap with other elements. controls where it is in the view hierarchy
}

- (void)fetchMovies {
    NSURL *url = [NSURL URLWithString:@"https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error != nil) {
            NSLog(@"Error! ---------- %@", [error localizedDescription]);
            [self displayNetworkError];
        }
        else {
            NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            // NSLog(@"%@", dataDictionary);
            self.movies = dataDictionary[@"results"];
            self.filteredData = self.movies;
//            NSLog(@"%@", self.movies);
//            for (NSDictionary *movie in self.movies) {
//                // NSLog(@"%@", movie[@"title"]);
//            }
            
            [self.tableView reloadData]; //call data source methods again as underlying data (self.movies) may have changed
            // TODO: Get the array of movies
            // TODO: Store the movies in a property to use elsewhere
            // TODO: Reload your table view data
            [self.refreshControl endRefreshing];
        }
        
    }];
    [task resume];
}

- (void)displayNetworkError {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                   message:@"Network connection failed."
                                                            preferredStyle:(UIAlertControllerStyleAlert)];
    // create an OK action
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * _Nonnull action) {
                                                         [self.refreshControl endRefreshing];
                                                     }];
    // add the OK action to the alert controller
    [alert addAction:okAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}
    
    
- (void) didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    //Dispose of any resources that can be recreated
}


-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //tells you how many rows you have
    // NSLog(@"%i", self.movies.count);
    return self.filteredData.count; //formerly self.movies.count
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //create and configure cell based on index path
    
    MovieCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MovieCell"]; //see if there is a template in the queue for the tableView with the identifier "MovieCell" and if so, create the cell based on this template. if there is no template, create from scratch.
    
    NSDictionary *movie = self.filteredData[indexPath.row];
    cell.titleLabel.text = movie[@"title"];
    cell.synopsisLabel.text = movie[@"overview"];
    
    NSString *baseURLString = @"https://image.tmdb.org/t/p/w500";
    NSString *posterURLString = movie[@"poster_path"];
    NSString *fullPosterURL = [baseURLString stringByAppendingString:posterURLString];
    
    NSURL *posterURL = [NSURL URLWithString:fullPosterURL]; //NSURL is very similar to NSString, except it checks to make sure the given string is a valid URL
    
    cell.posterView.image = nil; //clear out the old image so there's no "flicker" before the new one loads because recall we are reusing the cells from the queue
    [cell.posterView setImageWithURL:posterURL];
    
//    cell.textLabel.text = movie[@"title"];
    
    return cell;
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
// the id is the cell that got tapped on
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    UITableViewCell *tappedCell = sender;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:tappedCell];
    NSDictionary *movie = self.filteredData[indexPath.row];
    DetailsViewController *detailsViewController = [segue destinationViewController]; //returns a UIViewController, which DetailsViewController is a subclass of
    
    detailsViewController.movie = movie;
    NSLog(@"Tapping on a movie!");
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (searchText.length != 0) {
        NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
//            NSLog(@"search bar activated. SEARCH TEXT IS:%@", evaluatedObject);
//            BOOL isDict = [bindings isKindOfClass:[NSString class]];
            
//            NSLog(@"bindings is a %@", NSStringFromClass([bindings class]));
//            NSLog(@"evaluatedObject is a %@", NSStringFromClass([evaluatedObject class]));
//            NSString *title = @"title";
//            NSString *titlePointerString = [[title mutableCopy] copy];
//            NSLog(@"%p %p %@", title, titlePointerString, NSStringFromClass([titlePointerString class]));
//            for(id key in evaluatedObject) {
//                NSLog(@"key %@ is of type %@", key, NSStringFromClass([key class]));
//                NSLog(@"%@", evaluatedObject[key]);
//            }
            
//            NSLog(@"%@", evaluatedObject[titlePointerString]);
            return [evaluatedObject[@"title"] containsString:searchText];  //evaluatedObject
        }];
        self.filteredData = [self.movies filteredArrayUsingPredicate:predicate];

        NSLog(@"Filtered data: %@", self.filteredData);

    }
    else {
        self.filteredData = self.movies;
    }

    [self.tableView reloadData];

}


@end
