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
#import "Movie.h"
#import "MovieApiManager.h"

@interface MoviesViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView; //create an outlet for the table view from the view controller so that we can refer to the table view
@property (nonatomic, strong) NSMutableArray *movies;
@property (nonatomic, strong) UIRefreshControl *refreshControl;

@property (strong, nonatomic) NSArray *filteredData;
@property (strong, nonatomic) UISearchBar *searchBar;
@end

@implementation MoviesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.dataSource = self; //set data source equal to the view controller (self). once you're scrolling and want to show cells, use self for the data source methods
    self.tableView.delegate = self; //set delegate equal to the view controller (self)
    self.searchBar.delegate = self;
    
    [self fetchMovies];
    
    [self createRefreshControl];
    [self customizeNavigationBarShadowGreen];
}

- (void) createRefreshControl {
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(fetchMovies) forControlEvents:UIControlEventValueChanged];
    
    [self.tableView insertSubview:self.refreshControl atIndex:0]; //insertSubview is similar to addSubview, but puts the subview at specified index so there's no overlap with other elements. controls where it is in the view hierarchy
}

- (void) customizeNavigationBarShadowGreen {
    self.navigationItem.title = @"Movies";
    UINavigationBar *navigationBar = self.navigationController.navigationBar;
    NSShadow *shadow = [NSShadow new];
    shadow.shadowColor = [[UIColor grayColor] colorWithAlphaComponent:0.5];
    shadow.shadowOffset = CGSizeMake(2, 2);
    shadow.shadowBlurRadius = 4;
    navigationBar.titleTextAttributes = @{NSFontAttributeName : [UIFont boldSystemFontOfSize:22],
                                          NSForegroundColorAttributeName : [UIColor colorWithRed:0 green:0.2 blue:0 alpha:0.8],
                                          NSShadowAttributeName : shadow};
}

- (void)fetchMovies {
    MovieApiManager *manager = [MovieApiManager new];
    [manager fetchNowPlaying:^(NSMutableArray *movies, NSError *error) {
        if (error != nil) {
            NSLog(@"Error! ---------- %@", [error localizedDescription]);
            [self displayNetworkError];
        }
        else {
            self.movies = movies;
            self.filteredData = self.movies;
            [self.tableView reloadData];
            [self.refreshControl endRefreshing];
        }
    }];
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

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //tells you how many rows you have
    return self.filteredData.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //create and configure cell based on index path
    
    MovieCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MovieCell"]; //see if there is a template in the queue for the tableView with the identifier "MovieCell" and if so, create the cell based on this template. if there is no template, create from scratch.
    
    Movie *movie = self.filteredData[indexPath.row];
    cell.movie = movie;
    
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
    Movie *movie = self.filteredData[indexPath.row];
    UIView *backgroundView = [[UIView alloc] init];
    backgroundView.backgroundColor = UIColor.yellowColor;
    tappedCell.selectedBackgroundView = backgroundView;
    DetailsViewController *detailsViewController = [segue destinationViewController]; //returns a UIViewController, which DetailsViewController is a subclass of
    detailsViewController.movie = movie;
    NSLog(@"Tapping on a movie!");
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (searchText.length != 0) {
        NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(Movie *evaluatedMovie, NSDictionary *bindings) {
            return [evaluatedMovie.title containsString:searchText];  
        }];
        
        self.filteredData = [self.movies filteredArrayUsingPredicate:predicate];
        NSLog(@"Filtered data: %@", self.filteredData);
    }
    else {
        self.filteredData = self.movies;
    }

    [self.tableView reloadData];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    self.searchBar.showsCancelButton = YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    self.searchBar.showsCancelButton = NO;
    self.searchBar.text = @"";
    [self.searchBar resignFirstResponder];
    self.filteredData = self.movies;
    [self.tableView reloadData];
}

@end
