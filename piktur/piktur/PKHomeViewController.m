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
#import "FICDFullscreenPhotoDisplayController.h"
#import "PKFlickerPresentationViewController.h"
#import "GridLayout.h"
#import "LineLayout.h"
#import "CoverFlowLayout.h"
#import "StacksLayout.h"
#import "FAKFontAwesome.h"
#import <QuartzCore/QuartzCore.h>


const int MAX_PHOTOS = 300;

@interface PKHomeViewController () <FICDFullscreenPhotoDisplayControllerDelegate>{
    BOOL isAnimating;
}
@property(nonatomic, assign) PKLayoutStyle layoutStyle;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic) NSMutableArray* numbers;
@property(nonatomic, strong) NSMutableArray *imagePaths;
@property(nonatomic, strong) NSMutableArray *assignedImagesForCell;

@end

int num = 0;

@implementation PKHomeViewController

- (void)viewDidLoad {


    [self configureNavBar];

    self.title = @"piktur";

    self.assignedImagesForCell = [NSMutableArray arrayWithCapacity:MAX_PHOTOS];
    for(int i=0; i< MAX_PHOTOS; i++)
        self.assignedImagesForCell[i] = [NSNull null];
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

    UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handle3FingerTap:)];
    tap3.numberOfTouchesRequired = 2;
    [self.collectionView addGestureRecognizer:tap3];


}

- (void)configureNavBar
{
    FAKFontAwesome *camIcon = [FAKFontAwesome cameraRetroIconWithSize:20];
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 40)];
    UILabel *lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(120, 0, 100, 40)];
    lblTitle.text = @"piktur";
    lblTitle.backgroundColor = [UIColor clearColor];
    lblTitle.textColor = [UIColor blackColor];
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[camIcon imageWithSize:CGSizeMake(40, 40)]];
    CGRect f = imgView.frame;
    f.origin.x = 155;
    imgView.frame = f;
    [titleView addSubview:lblTitle];
    [titleView addSubview:imgView];
    self.navigationItem.titleView = titleView;
}

-(void )viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    self.collectionView.frame =self.view.frame;

}

- (void) viewDidAppear:(BOOL)animated {
    [self.collectionView reloadData];

    [[FICDFullscreenPhotoDisplayController sharedDisplayController] setDelegate:self];
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
    PKImageCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
//    cell.backgroundColor = [self colorForNumber:self.numbers[indexPath.row]];

    UIImage *img = [self assignedImageForCell:cell atIndexPath:indexPath];

    UIViewContentMode mode = [self contentModeForLayout];

    [cell loadImage:img contentMode:mode];
    return cell;

}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%s", __func__);
    PKImageCell * cell = [collectionView cellForItemAtIndexPath:indexPath];
//    UIView * snapshotView = [cell.imageView snapshotViewAfterScreenUpdates:YES];
//    CGSize fittingSize = [snapshotView sizeThatFits:CGSizeZero];
//    UIGraphicsBeginImageContext(fittingSize);
//    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
//    UIImage *snapshot = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
    [[FICDFullscreenPhotoDisplayController sharedDisplayController] showFullscreenPhoto:cell.imageView.image withThumbnailImageView:cell.imageView];

//    PKFlickerPresentationViewController * flickerVC = [[PKFlickerPresentationViewController alloc] init];
//    flickerVC.imageToPresent = self.assignedImagesForCell[indexPath.item];
//    [self.navigationController pushViewController:flickerVC animated:YES];
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

-(UIImage*) assignedImageForCell:(UICollectionViewCell*) cell atIndexPath:(NSIndexPath *) indexPath
{
    NSInteger  which = indexPath.item;
    UIImage *img = self.assignedImagesForCell[which];

    if([img isKindOfClass:[NSNull class]])
    {
        img = [self nextRandomImageForSize:cell.contentView.bounds.size];
        self.assignedImagesForCell[which] = img;
    }

    return img;
}

-(NSInteger) nextRandomIndex
{
    return  arc4random() % self.imagePaths.count;
}

- (UIImage *)nextRandomImageForSize:(CGSize)size
{

    UIImage *img = nil;
    BOOL imageSizeFits = NO;
    NSInteger bailOutAfterCnt = 4;
    NSInteger cnt = 0;
    NSInteger index = [self nextRandomIndex];
    while (!imageSizeFits)
    {
        NSURL *path = self.imagePaths[index];

        img = [UIImage imageNamed:[path lastPathComponent]];
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
}

-(void) loadImagePaths
{
    if (!self.imagePaths)
    {
        self.imagePaths = [NSMutableArray array];
        NSArray *directoryContents = [[NSBundle mainBundle] URLsForResourcesWithExtension:@"jpg" subdirectory:nil];

        for (NSURL *p in directoryContents)
        {
            [self.imagePaths addObject:p];
        }
    }


}


#pragma mark - FICDPhotosTableViewCellDelegate
//[[FICDFullscreenPhotoDisplayController sharedDisplayController] showFullscreenPhoto:photo withThumbnailImageView:imageView];


#pragma mark - FICDFullscreenPhotoDisplayControllerDelegate

- (void)photoDisplayController:(FICDFullscreenPhotoDisplayController *)photoDisplayController willShowSourceImage:(UIImage *)sourceImage forPhoto:(FICDPhoto *)photo withThumbnailImageView:(UIImageView *)thumbnailImageView {
    // If we're running on iOS 7, we'll try to intelligently determine whether the photo contents underneath the status bar is light or dark.
    if ([self respondsToSelector:@selector(preferredStatusBarStyle)]) {
    }

    
}


- (void)photoDisplayController:(FICDFullscreenPhotoDisplayController *)photoDisplayController willHideSourceImage:(UIImage *)sourceImage forPhoto:(FICDPhoto *)photo withThumbnailImageView:(UIImageView *)thumbnailImageView {
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
}

#pragma mark - scroll view
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
//    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^
//    {
//        [self.navigationController.navigationBar setHidden:YES];
//    }                completion:nil];
//    [self.navigationController.navigationBar setHidden:YES];
}

#pragma mark - layouts

-(UIViewContentMode) contentModeForLayout
{
    switch (self.layoutStyle)
    {
        case PKLayoutStyleQuilt:
            return UIViewContentModeCenter;
        case PKLayoutStyleCoverFlow:
            return UIViewContentModeCenter;
        case PKLayoutStyleLine:
            return UIViewContentModeCenter;

        default:
            return UIViewContentModeCenter;
    }
}

- (void)setLayoutStyle:(PKLayoutStyle)layoutStyle animated:(BOOL)animated
{
    if (layoutStyle == self.layoutStyle)
        return;

    UICollectionViewLayout *newLayout = nil;
    BOOL delayedInvalidate = NO;

    switch (layoutStyle)
    {
        case PKLayoutStyleGrid:
            newLayout = [[GridLayout alloc] init];
            break;

        case PKLayoutStyleLine:
            newLayout = [[LineLayout alloc] init];
            delayedInvalidate = YES;
            break;

        case PKLayoutStyleCoverFlow:
            newLayout = [[CoverFlowLayout alloc] init];
            delayedInvalidate = YES;

            break;
        case PKLayoutStyleQuilt:
        {
            RFQuiltLayout *layout = [[RFQuiltLayout alloc] init];
//            layout.direction = UICollectionViewScrollDirectionVertical;
//            layout.blockPixels = CGSizeMake(100, 100);
            layout.delegate = self;
            newLayout = layout;
            delayedInvalidate = YES;
            break;
        }

//        case SpeakerLayoutStacks:
//            newLayout = [[StacksLayout alloc] init];
//            break;

        default:
            break;
    }

    if (!newLayout)
        return;

    self.layoutStyle = layoutStyle;
    [self.collectionView setCollectionViewLayout:newLayout animated:animated];
//    self.collectionView.pagingEnabled = (layoutStyle == SpeakerLayoutSpiral);
    self.collectionView.pagingEnabled = NO;

    if (delayedInvalidate)
    {
        [self.collectionView.collectionViewLayout performSelector:@selector(invalidateLayout) withObject:nil afterDelay:0.4];
    }

    // WORKAROUND: There's a UICollectionView bug where the supplementary views from StacksLayout are leftover and remain in other layouts
    /*if (layoutStyle != SpeakerLayoutStacks)
    {
        NSMutableArray *leftoverViews = [NSMutableArray array];
        for (UIView *subview in self.collectionView.subviews)
        {
            // Find all the leftover supplementary views
            if ([subview isKindOfClass:[SmallConferenceHeader class]])
            {
                [leftoverViews addObject:subview];
            }
        }

        // remove them from the view hierarchy
        for (UIView *subview in leftoverViews)
            [subview removeFromSuperview];
    }*/
}

- (void)handle3FingerTap:(UITapGestureRecognizer *)gestureRecognizer
{
    PKLayoutStyle newLayout = self.layoutStyle + 1;
    if (newLayout >= SpeakerLayoutCount)
        newLayout = 0;
    [self setLayoutStyle:newLayout animated:YES];

}


@end
