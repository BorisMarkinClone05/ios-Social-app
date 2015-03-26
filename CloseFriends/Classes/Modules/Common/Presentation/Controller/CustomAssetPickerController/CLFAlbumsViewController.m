/***********************************************************************
 *
 * iOS Client
 * Copyright (C) by CloseFriends, Inc.
 *
 ***********************************************************************/


#import "CLFAlbumsViewController.h"
#import "CLFAssetPickerController.h"
#import "CLFAssetGridViewController.h"


@import Photos;

@interface CLFAlbumsViewController ()

@property (strong) NSMutableArray* collectionsArray;

@end


@implementation CLFAlbumsViewController

static NSString * const CollectionSegue = @"showCollection";

- (void)awakeFromNib
{
    [self addActivityIndicatorToNavigationBar];
}

-(BOOL)prefersStatusBarHidden
{
    return YES;
}

#pragma mark -
#pragma mark -

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.backgroundColor = [UIColor colorWithRed:239.0f/255.0f green:239.0f/255.0f blue:244.0f/255.0f alpha:1.0f];
 
    self.customAssetPickerController = (CLFAssetPickerController*)self.navigationController;
    
    filterType = self.customAssetPickerController.filterType;
    
    if (!self.collectionsArray)
    {
        self.collectionsArray = [[NSMutableArray alloc] init];
    }
    
    //smart albums
    PHFetchResult *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    
    //top level albums
    PHFetchResult *topLevelUserCollections = [PHCollectionList fetchTopLevelUserCollectionsWithOptions:nil];
    
    [self addCollections:smartAlbums];
    [self addCollections:topLevelUserCollections];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self removeActivityIndicatorFromNavigationBar];
}

#pragma mark -

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:CollectionSegue])
    {
        CLFAssetGridViewController *assetGridViewController = segue.destinationViewController;
        
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        
        PHFetchOptions *options = [[PHFetchOptions alloc] init];
        options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
        
        PHCollection *collection = [self.collectionsArray objectAtIndex:indexPath.row];
        
        if ([collection isKindOfClass:[PHAssetCollection class]])
        {
            PHAssetCollection *assetCollection = (PHAssetCollection *)collection;
            
            assetGridViewController.assetsFetchResults = [PHAsset fetchAssetsInAssetCollection:assetCollection options:options];
            assetGridViewController.assetCollection = assetCollection;
            assetGridViewController.title = assetCollection.localizedTitle;
            assetGridViewController.filterType = filterType;
            assetGridViewController.customAssetPickerController = self.customAssetPickerController;
        }
    }
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger numberOfRows = self.collectionsArray.count;
    
    return numberOfRows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    NSString *localizedTitle = nil;
    NSInteger count = 0;
    
    cell = [tableView dequeueReusableCellWithIdentifier:@"CollectionCell" forIndexPath:indexPath];
    
    PHCollection *collection = [self.collectionsArray objectAtIndex:indexPath.row];
    localizedTitle = collection.localizedTitle;
    
    if ([collection isKindOfClass:[PHAssetCollection class]])
    {
        PHAssetCollection *assetCollection = (PHAssetCollection *)collection;
        PHFetchResult *assetsFetchResult = [PHAsset fetchAssetsInAssetCollection:assetCollection options:nil];
        count = [assetsFetchResult countOfAssetsWithMediaType:filterType];
    }
    
    cell.textLabel.text = localizedTitle;
    cell.textLabel.font = [UIFont fontWithName:@"Avenir-Medium" size:15.0];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%d", (int)count];
    cell.detailTextLabel.textColor = [UIColor blackColor];
    cell.detailTextLabel.font = [UIFont fontWithName:@"Avenir-Medium" size:15.0];
    
    cell.backgroundColor = [UIColor colorWithWhite:1.0f alpha:0.75f];

    return cell;
}


#pragma mark - Actions

- (IBAction)handleCancelButtonItem:(id)sender
{
    if ([self.customAssetPickerController.delegate respondsToSelector:@selector(customAssetsPickerControllerDidCancel:)])
    {
        [self.customAssetPickerController.delegate customAssetsPickerControllerDidCancel:self.customAssetPickerController];
    }
}


#pragma mark - Add PHFetchResult

-(void) addCollections:(PHFetchResult*) result
{
    for (int i=0; i<result.count; i++)
    {
        PHCollection *collection = result[i];
        
        if ([collection isKindOfClass:[PHAssetCollection class]])
        {
            PHAssetCollection *assetCollection = (PHAssetCollection *)collection;
            PHFetchResult *assetsFetchResult = [PHAsset fetchAssetsInAssetCollection:assetCollection options:nil];
            
            if ([assetsFetchResult countOfAssetsWithMediaType:filterType] > 0)
            {
                [self.collectionsArray addObject:collection];
            }
        }
    }
}


- (void)addActivityIndicatorToNavigationBar
{
    if (!_indicatorView)
    {
        _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [_indicatorView setHidesWhenStopped:YES];
    }
    
    UIBarButtonItem *itemIndicator = [[UIBarButtonItem alloc] initWithCustomView:_indicatorView];
    [self.navigationItem setRightBarButtonItem:itemIndicator];
    [_indicatorView startAnimating];
}

- (void)removeActivityIndicatorFromNavigationBar
{
    [_indicatorView stopAnimating];
}



@end
