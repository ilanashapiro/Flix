//
//  MoviesGridViewController.m
//  Flix
//
//  Created by ilanashapiro on 6/26/19.
//  Copyright ©/Users/ilanashapiro/Desktop/Flix/Flix/View Controllers/MoviesGridViewController.m 2019 ilanashapiro. All rights reserved.
//

#import "MoviesGridViewController.h"
#import "MovieCollectionCell.h"
#import "UIImageView+AFNetworking.h"
#import "DetailsViewController.h"
#import "MovieApiManager.h"

@interface MoviesGridViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UISearchBarDelegate>

@property (nonatomic, strong) NSArray *movies;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) NSArray *filteredData;

@end

@implementation MoviesGridViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.searchBar.delegate = self;
    
    [self fetchMovies];
    
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
    layout.minimumInteritemSpacing = 5;
    layout.minimumLineSpacing = 5;
    
    CGFloat postersPerLine = 2;
    CGFloat itemWidth = (self.collectionView.frame.size.width - layout.minimumInteritemSpacing * (postersPerLine - 1)) / postersPerLine;
    CGFloat itemHeight = itemWidth * 1.5;
    layout.itemSize = CGSizeMake(itemWidth, itemHeight);
    
    [self createRefreshControl];
    [self customizeNavigationBarShadowGreen];
}

- (void) createRefreshControl {
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(fetchMovies) forControlEvents:UIControlEventValueChanged];
    
    [self.collectionView insertSubview:self.refreshControl atIndex:0]; //insertSubview is similar to addSubview, but puts the subview at specified index so there's no overlap with other elements. controls where it is in the view hierarchy
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
            [self.collectionView reloadData];
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

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    MovieCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MovieCollectionCell" forIndexPath:indexPath];
    
    Movie *movie = self.filteredData[indexPath.item];
    cell.movie = movie;
    
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.filteredData.count;
}

#pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
    UICollectionViewCell *tappedCell = sender;
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:tappedCell];
    Movie *movie = self.filteredData[indexPath.row];
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

    [self.collectionView reloadData];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    self.searchBar.showsCancelButton = YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    self.searchBar.showsCancelButton = NO;
    self.searchBar.text = @"";
    [self.searchBar resignFirstResponder];
    self.filteredData = self.movies;
    [self.collectionView reloadData];
}

@end
