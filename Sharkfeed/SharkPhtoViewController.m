//
//  SharkPhtoViewController.m
//  Sharkfeed
//
//  Created by Fikirte  Derso on 2/7/18.
//  Copyright © 2018 Fikirte  Derso. All rights reserved.
//

#import "SharkPhtoViewController.h"
#import "SharkFeedCollectionViewCell.h"
#import "PhotoDetailViewController.h"
#import "WebService.h"
#import "Constants.h"
#import "SharkPhoto.h"
#import "ImageCache.h"


typedef void (^SearchPhotoCallback)(NSError * error);

@interface SharkPhtoViewController ()

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic)  UIRefreshControl * refreshControll;
@property (strong, nonatomic) NSMutableArray * photosArray;
@property (strong, nonatomic) SharkPhoto * sharkPhoto;
@property int numberOfItemsInSecion;
@property (strong, nonatomic) NSOperationQueue * operationQueue;

@end

@implementation SharkPhtoViewController 

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _photosArray = [[NSMutableArray alloc] init];
    _sharkPhoto = [[SharkPhoto alloc] init];
    [self setTitle:@"Shark Feed"];
    
    //Pull to Refresh
     [self pullToFrefreshContent];
    
    _operationQueue = [NSOperationQueue new];
    
    //Search and featch Photo
    [self searchPhotoWithCallback:^(NSError *error) {
        if (!error) {
            dispatch_async(dispatch_get_main_queue(), ^{

                [_collectionView reloadData];
                
            });
        }
        else{
           NSLog(@"Error getting photo");
        }
        
    }];
}

-(void)pullToFrefreshContent{
    
    _refreshControll = [[UIRefreshControl alloc] init];
    _refreshControll.attributedTitle = [[NSAttributedString alloc] initWithString:@"Pull to Refresh"];
   [self.refreshControll setTintColor:[UIColor clearColor]];
    UIImageView * imageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(150, 10, 14, 19)];
    UIImageView * imageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(150, 32, 17, 25)];
    
    //Add Image to image View
    imageView1.image = [UIImage imageNamed:@"pull_to_refresh_1.png"];
    imageView2.image = [UIImage imageNamed:@"pull_to_refresh_2.png"];
 
    [_refreshControll insertSubview:imageView1 atIndex:0];
    [_refreshControll insertSubview:imageView2 atIndex:1];
    
    [_refreshControll addTarget:self action:@selector(refreshCollection) forControlEvents:UIControlEventValueChanged];

     [_collectionView addSubview:_refreshControll];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return [_photosArray count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    SharkFeedCollectionViewCell * cell = (SharkFeedCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    
    [cell.activityIndicator startAnimating];
    _sharkPhoto = [_photosArray objectAtIndex:indexPath.item];
 
    NSBlockOperation *loadImageOperation = [[NSBlockOperation alloc] init];
    [loadImageOperation addExecutionBlock:^(void){
        
       __block UIImage  * cachedImage = [[ImageCache sharedInstance] getCachedImageForKey:_sharkPhoto.url_t];
        
        if(!cachedImage) {
            
            //get Photo
            NSData * imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:_sharkPhoto.url_t]];
            
            //cache image if
            if (imageData) {
                cachedImage = [UIImage imageWithData:imageData];
                [[ImageCache sharedInstance] cacheImage:cachedImage forKey:_sharkPhoto.url_t];
            }
          
        }
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^(void) {
            cell.imageView.image = cachedImage;
            [cell.activityIndicator startAnimating];
            cell.activityIndicator.hidden = YES;
        }];
        
    }];
    [_operationQueue addOperation:loadImageOperation];
    

    return cell;
}


#pragma mark <UICollectionViewDelegate>

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    _sharkPhoto = [_photosArray objectAtIndex:indexPath.row];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
  
    PhotoDetailViewController *photoDetailViewController = [storyboard instantiateViewControllerWithIdentifier:@"PhotoDetailViewController"];
    
    photoDetailViewController.photoUrl = _sharkPhoto.url_l;
    photoDetailViewController.pTitle = _sharkPhoto.title;
    photoDetailViewController.photoId = _sharkPhoto.photoId;
   
    [self.navigationController pushViewController:photoDetailViewController animated:YES];
     
    return YES;
 }

#pragma mark collection view cell layout / size
- (CGSize)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    float cellWidth = screenWidth / 3.0;
    CGSize size = CGSizeMake(cellWidth-3, cellWidth);
    
    return size;
  
}
 
#pragma mark <UIScrollViewDelegate>
-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat currentOffsetX = scrollView.contentOffset.x;
    CGFloat currentOffSetY = scrollView.contentOffset.y;
    CGFloat contentHeight = scrollView.contentSize.height;
    
    if (currentOffSetY > ((contentHeight * 6)/ 10.0)) {
        scrollView.contentOffset = CGPointMake(currentOffsetX,(currentOffSetY - (contentHeight/2)));
    }
    
}


#pragma mark - Helper Methods

-(void)refreshCollection{
    
    [self searchPhotoWithCallback:^(NSError *error) {
        if (!error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [_collectionView reloadData];
                
            });
        }
        else{
            NSLog(@"Error getting photo");
        }
        
        [_refreshControll endRefreshing];
        
    }];
    
}

-(void)searchPhotoWithCallback:(SearchPhotoCallback)callback {
   
    WebService * service = [[WebService alloc] init];
    [service makeGetRequestWithURL:SEARCH_PHOTOS_URL withCallback:^(NSDictionary *responseData, NSError *error) {
        
        if(error == nil) {
            
            NSDictionary * photoDict = [responseData valueForKey:@"photos"];
            NSArray * photoArray = [photoDict valueForKey:@"photo"];
            
            NSLog(@"Data : %@", photoArray);
             [_photosArray removeAllObjects];
            for (NSDictionary * item in photoArray) {
                NSString * title = [item valueForKey:@"title"];
                
                //Just to avoid any inappropriate images that were coming in
                if (![title localizedStandardContainsString:@"Leaked"]) {
                    SharkPhoto * photo = [[SharkPhoto alloc] init];
                    photo.title = title;
                    photo.photoId = [item valueForKey:@"id"];
                    photo.url_t = [item valueForKey:@"url_t"];
                    photo.url_l = [item valueForKey:@"url_l"];
                    [_photosArray addObject:photo];
                }
               
            }
            
            callback(nil);
            
        }
        else {
            callback(error);
        }
        
    }];
}


@end
