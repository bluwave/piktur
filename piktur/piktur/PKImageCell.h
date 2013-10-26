//
//  PKImageCell.h
//  piktur
//
//  Created by Garrett Richards on 10/26/13.
//
//

#import <UIKit/UIKit.h>

@protocol PKImageCellDelegate;

@interface PKImageCell : UICollectionViewCell
@property(nonatomic, strong) UIImageView *imageView;
@property(nonatomic, assign) NSInteger assignedIndex;
@property (nonatomic, weak) id <PKImageCellDelegate> delegate;

-(void) loadImage:(UIImage * ) img contentMode:(UIViewContentMode) mode;

@end

@protocol PKImageCellDelegate <NSObject>

@required
- (void)photosTableViewCell:(PKImageCell *)photosTableViewCell didSelectPhoto:(UIImage *)photo withImageView:(UIImageView *)imageView;
        @end