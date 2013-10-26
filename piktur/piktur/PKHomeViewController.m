//
//  PKHomeViewController.m
//  piktur
//
//  Created by Garrett Richards on 10/26/13.
//
//

//  RFViewController.m
//  QuiltDemo
//
//  Created by Bryce Redd on 12/26/12.
//  Copyright (c) 2012 Bryce Redd. All rights reserved.
//

#import "PKHomeViewController.h"
#import "PKImageCell.h"
#import "FICDPhoto.h"
#import "FICImageCache.h"
#import <QuartzCore/QuartzCore.h>

const int MAX_PHOTOS = 100;

@interface PKHomeViewController ()<FICImageCacheDelegate> {
    BOOL isAnimating;
}

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic) NSMutableArray* numbers;
@property(nonatomic, strong) NSMutableArray *imagePaths;

@end

int num = 0;

@implementation PKHomeViewController

//-(void)loadView
//{
//    [super loadView];
//    self.layout = [[RFQuiltLayout alloc] init];
//    CGRect f = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
//    self.collectionView = [[UICollectionView alloc] initWithFrame:f collectionViewLayout:self.layout];
//    self.collectionView.autoresizesSubviews =UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
//    [self.view addSubview:self.collectionView];
//}

- (void)viewDidLoad {

    [self configureImageCache];

    self.numbers = [@[] mutableCopy];
    for(; num<MAX_PHOTOS; num++) { [self.numbers addObject:@(num)]; }


    NSLog(@"%s cv: %@", __func__, self.collectionView);

//    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    [self.collectionView registerClass:[PKImageCell class] forCellWithReuseIdentifier:@"cell"];
    RFQuiltLayout* layout = (id)[self.collectionView collectionViewLayout];
    layout.direction = UICollectionViewScrollDirectionVertical;
    layout.blockPixels = CGSizeMake(100, 100);

    [self loadImagePaths];

//    [self.view setBackgroundColor:[UIColor whiteColor]];

    [self.collectionView reloadData];

}

-(void )viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    self.collectionView.frame =self.view.frame;
}

- (void) viewDidAppear:(BOOL)animated {
    [self.collectionView reloadData];
}

- (IBAction)remove:(id)sender {
    if(!self.numbers.count) return;

    if(isAnimating) return;
    isAnimating = YES;

    [self.collectionView performBatchUpdates:^{
        int index = arc4random() % MAX(1, self.numbers.count);
        [self.numbers removeObjectAtIndex:index];
        [self.collectionView deleteItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]]];
    } completion:^(BOOL done) {
        isAnimating = NO;
    }];
}

- (IBAction)refresh:(id)sender {
    [self.collectionView reloadData];
}

- (IBAction)add:(id)sender {
    if(isAnimating) return;
    isAnimating = YES;

    [self.collectionView performBatchUpdates:^{
        int index = arc4random() % MAX(self.numbers.count,1);
        [self.numbers insertObject:@(++num) atIndex:index];
        [self.collectionView insertItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]]];
    } completion:^(BOOL done) {
        isAnimating = NO;
    }];
}

- (UIColor*) colorForNumber:(NSNumber*)num {
    return [UIColor colorWithHue:((19 * num.intValue) % 255)/255.f saturation:1.f brightness:1.f alpha:1.f];
}

#pragma mark - UICollectionView Datasource

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    return self.numbers.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
//    UICollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    PKImageCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];

    cell.backgroundColor = [self colorForNumber:self.numbers[indexPath.row]];

    id <FICEntity> ranImg = [self nextRandomImageForSize:cell.contentView.bounds.size];
    [cell loadPhoto:ranImg];

    return cell;

}

-(void) loadImageForCellAtIndexPath:(NSIndexPath *) indexPath
{

//    NSString *formatName = XXImageFormatNameUserThumbnailSmall;
//    FICImageCacheCompletionBlock completionBlock = ^(id <FICEntity> entity, NSString *formatName, UIImage *image) {
//        _imageView.image = image;
//        [_imageView.layer addAnimation:[CATransition animation] forKey:kCATransition];
//    };
//
//    BOOL imageExists = [sharedImageCache retrieveImageForEntity:user withFormatName:formatName completionBlock:completionBlock];
//
//    if (imageExists == NO) {
//        _imageView.image = [self _userPlaceholderImage];
//    }
}

#pragma mark – RFQuiltLayoutDelegate

- (CGSize) blockSizeForItemAtIndexPath:(NSIndexPath *)indexPath {

    if(indexPath.row >= self.numbers.count)
        NSLog(@"Asking for index paths of non-existant cells!! %d from %d cells", indexPath.row, self.numbers.count);

    if (indexPath.row % 10 == 0)
        return CGSizeMake(3, 1);
    if (indexPath.row % 11 == 0)
        return CGSizeMake(2, 1);
    else if (indexPath.row % 7 == 0)
        return CGSizeMake(1, 3);
    else if (indexPath.row % 8 == 0)
        return CGSizeMake(1, 2);
    else if(indexPath.row % 11 == 0)
        return CGSizeMake(2, 2);
    if (indexPath.row == 0) return CGSizeMake(5, 5);

    return CGSizeMake(1, 1);
}

- (UIEdgeInsets)insetsForItemAtIndexPath:(NSIndexPath *)indexPath {
    return UIEdgeInsetsMake(2, 2, 2, 2);
}


#pragma mark - images
- (NSInteger)nextRandomImageIndex
{
    return arc4random() % self.imagePaths.count;
}

- (id<FICEntity>)nextRandomImageForSize:(CGSize)size
{
    id <FICEntity> photo = self.imagePaths[arc4random() % self.imagePaths.count];
    return photo;
}

/*- (UIImage *)nextRandomImageForSize:(CGSize)size
{
//    NSLog(@"%s count: %d", __func__, self.imagePaths.count);
//    NSLog(@"%s ran: %d", __func__,arc4random() % self.imagePaths.count);

    UIImage *img = nil;
    BOOL imageSizeFits = NO;
    NSInteger bailOutAfterCnt = 4;
    NSInteger cnt = 0;

    while (!imageSizeFits)
    {
        NSString *path = self.imagePaths[arc4random() % self.imagePaths.count];
        img = [UIImage imageNamed:path];
        imageSizeFits = YES;
        if (img.size.width < size.width || img.size.height < size.height)
        {
            NSLog(@"%s *** img is tool small for cell size: %@", __func__, NSStringFromCGSize(size));
            imageSizeFits = NO;
        }
        cnt++;
        if (cnt == bailOutAfterCnt)
            imageSizeFits = YES;
    }

    return img;
}*/

-(void) loadImagePaths
{
    if (!self.imagePaths)
    {
        self.imagePaths = [NSMutableArray array];
        NSArray *directoryContents = [[NSBundle mainBundle] URLsForResourcesWithExtension:@"jpg" subdirectory:nil];

        for (NSURL *p in directoryContents)
        {
            FICDPhoto *photo = [[FICDPhoto alloc] init];
            [photo setSourceImageURL:p];
            [self.imagePaths addObject:photo];
        }
    }


    dispatch_block_t callbackReloadCollectionView = ^
    {
        [self.collectionView reloadData];
    };

    FICImageCache *sharedImageCache = [FICImageCache sharedImageCache];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^
    {
        NSSet *uniquePhotos = [NSSet setWithArray:self.imagePaths];
        __block NSInteger callbackCnt = 0;
        CFAbsoluteTime startTime = CFAbsoluteTimeGetCurrent();
        for (FICDPhoto *photo in uniquePhotos)
        {
            if ([sharedImageCache imageExistsForEntity:photo withFormatName:FICDPhotoSquareImageFormatName] == NO)
            {
                callbackCnt++;
                [sharedImageCache asynchronouslyRetrieveImageForEntity:photo withFormatName:FICDPhotoSquareImageFormatName completionBlock:^(id <FICEntity> entity, NSString *formatName, UIImage *image)
                {
                    NSLog(@"%s image: %@", __func__, image);
                    callbackCnt--;
                    if (callbackCnt == 0)
                    {
                        NSLog(@"*** FIC Demo: Fast Image Cache: Generated thumbnails in %g seconds", CFAbsoluteTimeGetCurrent() - startTime);
                        dispatch_async(dispatch_get_main_queue(), callbackReloadCollectionView);
                    }
                }];
            }
        }
    });

}



#pragma mark - FICImageCacheDelegate

-(void) configureImageCache
{
    NSMutableArray *mutableImageFormats = [NSMutableArray array];

    // Square image format
    NSInteger squareImageFormatMaximumCount = 400;
    FICImageFormatDevices squareImageFormatDevices = FICImageFormatDevicePhone | FICImageFormatDevicePad;

    FICImageFormat *squareImageFormat = [FICImageFormat formatWithName:FICDPhotoSquareImageFormatName family:FICDPhotoImageFormatFamily imageSize:FICDPhotoSquareImageSize style:FICImageFormatStyle32BitBGRA
                                                          maximumCount:squareImageFormatMaximumCount devices:squareImageFormatDevices];

    [mutableImageFormats addObject:squareImageFormat];

    if ([UIViewController instancesRespondToSelector:@selector(preferredStatusBarStyle)])
    {
        // Pixel image format
        NSInteger pixelImageFormatMaximumCount = 1000;
        FICImageFormatDevices pixelImageFormatDevices = FICImageFormatDevicePhone | FICImageFormatDevicePad;

        FICImageFormat *pixelImageFormat = [FICImageFormat formatWithName:FICDPhotoPixelImageFormatName family:FICDPhotoImageFormatFamily imageSize:FICDPhotoPixelImageSize style:FICImageFormatStyle32BitBGRA
                                                             maximumCount:pixelImageFormatMaximumCount devices:pixelImageFormatDevices];

        [mutableImageFormats addObject:pixelImageFormat];
    }

    // Configure the image cache
    FICImageCache *sharedImageCache = [FICImageCache sharedImageCache];
    [sharedImageCache setDelegate:self];
    [sharedImageCache setFormats:mutableImageFormats];
}


- (void)imageCache:(FICImageCache *)imageCache wantsSourceImageForEntity:(id<FICEntity>)entity withFormatName:(NSString *)formatName completionBlock:(FICImageRequestCompletionBlock)completionBlock {
    // Images typically come from the Internet rather than from the app bundle directly, so this would be the place to fire off a network request to download the image.
    // For the purposes of this demo app, we'll just access images stored locally on disk.
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIImage *sourceImage = [(FICDPhoto *)entity sourceImage];
        dispatch_async(dispatch_get_main_queue(), ^{
            completionBlock(sourceImage);
        });
    });
}

- (BOOL)imageCache:(FICImageCache *)imageCache shouldProcessAllFormatsInFamily:(NSString *)formatFamily forEntity:(id<FICEntity>)entity {
    BOOL shouldProcessAllFormats = [formatFamily isEqualToString:FICDPhotoImageFormatFamily];

    return shouldProcessAllFormats;
}

- (void)imageCache:(FICImageCache *)imageCache errorDidOccurWithMessage:(NSString *)errorMessage {
    NSLog(@"%@", errorMessage);
}

@end
